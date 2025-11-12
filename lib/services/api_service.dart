// lib/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'secure_storage_service.dart';

// A global navigator key is essential for handling redirects from the interceptor.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ApiService {
  final Dio _dio;
  final SecureStorageService _storageService = SecureStorageService();

  // The base URL for your API.
  // For Android Emulator, use 10.0.2.2 to connect to your local machine's localhost.
  // For physical devices, use your machine's local network IP address.
  static const String _baseUrl = "http://172.16.2.6:8000/api/";

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(milliseconds: 20000),
          receiveTimeout: const Duration(milliseconds: 20000),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
          final token = await _storageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          debugPrint(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          // Handle token expiration and refresh
          if (e.response?.statusCode == 401) {
            // Avoid refresh loop if the refresh token itself fails
            if (e.requestOptions.path == 'accounts/token/refresh/') {
              debugPrint("Refresh token itself is invalid. Logging out.");
              await _logoutUser();
              return handler.next(e);
            }

            final storedRefreshToken = await _storageService.getRefreshToken();
            if (storedRefreshToken != null) {
              try {
                debugPrint("Access token expired. Attempting to refresh...");
                final newAccessToken = await refreshToken();
                debugPrint("Token refreshed successfully.");

                // Retry the original request with the new token
                e.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } catch (refreshError) {
                debugPrint(
                  "Failed to refresh token: $refreshError. Logging out.",
                );
                await _logoutUser();
                return handler.next(e);
              }
            } else {
              // No refresh token found, log out
              await _logoutUser();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _logoutUser() async {
    // Use the global navigator key to navigate without a build context
    if (navigatorKey.currentContext != null) {
      Provider.of<UserProvider>(
        navigatorKey.currentContext!,
        listen: false,
      ).logout();
    }
    await _storageService.deleteTokens();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  /// Deletes the stored access and refresh tokens.
  Future<void> clearAuthToken() async {
    await _storageService.deleteTokens();
  }

  // --- AUTH ENDPOINTS ---

  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) {
    return _dio.post(
      'accounts/register/',
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "password2": password,
        "role": role,
      },
    );
  }

  Future<Response> verifyRegistrationOtp({
    required String email,
    required String otp,
  }) {
    return _dio.post(
      'accounts/register-verify/',
      data: {"email": email, "otp": otp},
    );
  }

  Future<Response> resendRegistrationOtp({required String email}) {
    return _dio.post('accounts/register-resend-otp/', data: {"email": email});
  }

  Future<Response> login({required String email, required String password}) {
    return _dio.post(
      'accounts/login/',
      data: {"email": email, "password": password},
    );
  }

  Future<Response> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _dio.post(
      'accounts/login-verify/',
      data: {"email": email, "otp": otp},
    );
    debugPrint('Login Verify API Response: ${response.data}');
    return response;
  }

  Future<Response> resendLoginOtp({required String email}) {
    return _dio.post('accounts/login-resend-otp/', data: {"email": email});
  }

  Future<String> refreshToken() async {
    final storedRefreshToken = await _storageService.getRefreshToken();
    if (storedRefreshToken == null) {
      throw Exception('No refresh token available');
    }
    final response = await _dio.post(
      'accounts/token/refresh/',
      data: {'refresh': storedRefreshToken},
    );

    if (response.statusCode == 200) {
      final newAccessToken = response.data['access'];
      await _storageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: storedRefreshToken,
      );
      return newAccessToken;
    } else {
      throw Exception(
        'Failed to refresh token with status code: ${response.statusCode}',
      );
    }
  }

  // --- USER PROFILE ENDPOINTS ---

  Future<User> getUserProfile() async {
    try {
      final response = await _dio.get('accounts/profile/');

      // --- THIS IS THE MOST IMPORTANT LINE FOR DEBUGGING YOUR ROLE ISSUE ---
      // When you log in as a DOCTOR, this will print the exact JSON from your server.
      // Look at this output in your "Debug Console" to see how the 'role' is sent.
      debugPrint("ApiService: Received user profile JSON: ${response.data}");

      return User.fromJson(response.data);
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
      rethrow; // Rethrow the error so the provider can handle it
    }
  }

  Future<User> updateUserProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? dateOfBirth,
    String? phoneNumber,
    String? imagePath,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (bio != null) data['bio'] = bio;
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;

      if (imagePath != null && imagePath.isNotEmpty) {
        String fileName = imagePath.split('/').last;
        data['profile_picture'] = await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.patch('accounts/profile/', data: formData);
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(getErrorMessage(e));
    } catch (e) {
      throw Exception(
        "An unexpected error occurred while updating profile: $e",
      );
    }
  }

  // --- GENERIC ERROR HELPER ---
  static String getErrorMessage(DioException e) {
    if (e.response != null && e.response!.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      // Try to extract a meaningful error message from the response body
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }
      if (data.values.isNotEmpty) {
        final firstValue = data.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue[0].toString();
        }
        return firstValue.toString();
      }
    }
    // Fallback to the generic Dio error message
    return e.message ?? "An unexpected error occurred.";
  }
}
