// lib/services/api_service.dart

// Required for File and path operations
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'secure_storage_service.dart';

// A global navigator key is essential for handling redirects from the interceptor.
final GlobalKey<
  NavigatorState
>
navigatorKey =
    GlobalKey<
      NavigatorState
    >();

class ApiService {
  final Dio _dio;
  final SecureStorageService _storageService = SecureStorageService();

  // The base URL for your API.
  // For Android Emulator, use 10.0.2.2 to connect to your local machine's localhost.
  // For physical devices, use your machine's local network IP address (e.g., 192.168.1.10).
  static const String _baseUrl = "http://172.16.2.7:8000/api/";

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(
            milliseconds: 5000,
          ),
          receiveTimeout: const Duration(
            milliseconds: 10000,
          ),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (
              options,
              handler,
            ) async {
              print(
                'REQUEST[${options.method}] => PATH: ${options.path}',
              );
              final token = await _storageService.getAccessToken();
              if (token !=
                  null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(
                options,
              );
            },
        onResponse:
            (
              response,
              handler,
            ) {
              print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
              );
              return handler.next(
                response,
              );
            },
        onError:
            (
              DioException e,
              handler,
            ) async {
              print(
                'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
              );
              if (e.response?.statusCode ==
                  401) {
                if (e.requestOptions.path ==
                    'accounts/token/refresh/') {
                  print(
                    "Refresh token itself failed. Logging out.",
                  );
                  await _logoutUser();
                  return handler.next(
                    e,
                  );
                }
                final storedRefreshToken = await _storageService.getRefreshToken();
                if (storedRefreshToken !=
                    null) {
                  try {
                    print(
                      "Access token expired. Attempting to refresh...",
                    );
                    final newAccessToken = await refreshToken();
                    print(
                      "Token refreshed successfully.",
                    );
                    e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                    print(
                      "Retrying original request to ${e.requestOptions.path}",
                    );
                    final response = await _dio.fetch(
                      e.requestOptions,
                    );
                    return handler.resolve(
                      response,
                    );
                  } catch (
                    refreshError
                  ) {
                    print(
                      "Failed to refresh token: $refreshError. Logging out.",
                    );
                    await _logoutUser();
                    return handler.next(
                      e,
                    );
                  }
                } else {
                  await _logoutUser();
                }
              }
              return handler.next(
                e,
              );
            },
      ),
    );
  }

  Future<
    void
  >
  _logoutUser() async {
    if (navigatorKey.currentContext !=
        null) {
      Provider.of<
            UserProvider
          >(
            navigatorKey.currentContext!,
            listen: false,
          )
          .logout();
    }
    await _storageService.deleteTokens();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (
        route,
      ) => false,
    );
  }

  // --- NEW: Public method to clear auth tokens ---
  /// Deletes the stored access and refresh tokens.
  Future<
    void
  >
  clearAuthToken() async {
    await _storageService.deleteTokens();
  }

  // --- AUTH ENDPOINTS ---

  Future<
    Response
  >
  register({
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

  Future<
    Response
  >
  verifyRegistrationOtp({
    required String email,
    required String otp,
  }) {
    return _dio.post(
      'accounts/register-verify/',
      data: {
        "email": email,
        "otp": otp,
      },
    );
  }

  Future<
    Response
  >
  resendRegistrationOtp({
    required String email,
  }) {
    return _dio.post(
      'accounts/register-resend-otp/',
      data: {
        "email": email,
      },
    );
  }

  Future<
    Response
  >
  login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      'accounts/login/',
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  // --- MODIFIED: Added logging for the login-verify response ---
  Future<
    Response
  >
  verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        'accounts/login-verify/',
        data: {
          "email": email,
          "otp": otp,
        },
      );
      // --- ADDED: Print the full response data to the debug console ---
      print(
        'Login Verify API Response: ${response.data}',
      );
      return response;
    } catch (
      e
    ) {
      // The existing onError interceptor will still handle and log errors.
      rethrow;
    }
  }

  Future<
    Response
  >
  resendLoginOtp({
    required String email,
  }) {
    return _dio.post(
      'accounts/login-resend-otp/',
      data: {
        "email": email,
      },
    );
  }

  Future<
    String
  >
  refreshToken() async {
    final storedRefreshToken = await _storageService.getRefreshToken();
    final response = await _dio.post(
      'accounts/token/refresh/',
      data: {
        'refresh': storedRefreshToken,
      },
    );

    if (response.statusCode ==
        200) {
      final newAccessToken = response.data['access'];
      await _storageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: storedRefreshToken!,
      );
      return newAccessToken;
    } else {
      throw Exception(
        'Failed to refresh token',
      );
    }
  }

  // --- USER PROFILE ENDPOINTS ---

  Future<
    User
  >
  getUserProfile() async {
    try {
      final response = await _dio.get(
        'accounts/profile/',
      );
      return User.fromJson(
        response.data,
      );
    } catch (
      e
    ) {
      throw Exception(
        'Failed to fetch user profile: $e',
      );
    }
  }

  Future<
    User
  >
  updateUserProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? dateOfBirth,
    String? phoneNumber,
    String? imagePath, // Path to the new image file
  }) async {
    try {
      // Create a map for all fields
      final Map<
        String,
        dynamic
      >
      data = {};
      if (firstName !=
          null) {
        data['first_name'] = firstName;
      }
      if (lastName !=
          null) {
        data['last_name'] = lastName;
      }
      if (bio !=
          null) {
        data['bio'] = bio;
      }
      if (dateOfBirth !=
          null) {
        data['date_of_birth'] = dateOfBirth;
      }
      if (phoneNumber !=
          null) {
        data['phone_number'] = phoneNumber;
      }

      // Handle the image file separately
      if (imagePath !=
              null &&
          imagePath.isNotEmpty) {
        String fileName = imagePath
            .split(
              '/',
            )
            .last;
        data['profile_picture'] = await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        );
      }

      // Use FormData to send a multipart/form-data request
      final formData = FormData.fromMap(
        data,
      );

      final response = await _dio.patch(
        'accounts/profile/',
        data: formData,
      );

      // Return the updated user data, parsed into our model
      return User.fromJson(
        response.data,
      );
    } on DioException catch (
      e
    ) {
      // Use the existing error handler
      throw Exception(
        getErrorMessage(
          e,
        ),
      );
    } catch (
      e
    ) {
      throw Exception(
        "An unexpected error occurred while updating profile: $e",
      );
    }
  }

  // --- GENERIC ERROR HELPER ---

  static String getErrorMessage(
    DioException e,
  ) {
    if (e.response !=
            null &&
        e.response!.data
            is Map) {
      final data =
          e.response!.data
              as Map<
                String,
                dynamic
              >;
      if (data.values.isNotEmpty) {
        final firstValue = data.values.first;
        if (firstValue
                is List &&
            firstValue.isNotEmpty) {
          return firstValue[0].toString();
        }
        return firstValue.toString();
      }
    }
    return e.message ??
        "An unexpected error occurred.";
  }
}
