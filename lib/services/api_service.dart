import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// A global navigator key is used to allow navigation from outside the widget tree,
// which is essential for handling redirects from the interceptor.
final GlobalKey<
  NavigatorState
>
navigatorKey =
    GlobalKey<
      NavigatorState
    >();

class ApiService {
  final Dio _dio;

  // The base URL for your API.
  // Remember to replace this with your actual API endpoint.
  static const String _baseUrl = "https://api.yourapp.com/v1/";

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(
            milliseconds: 5000,
          ),
          receiveTimeout: const Duration(
            milliseconds: 3000,
          ),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // -- Intercepts the request before it is sent.
        onRequest:
            (
              options,
              handler,
            ) {
              print(
                'REQUEST[${options.method}] => PATH: ${options.path}',
              );
              // Here, you can add headers like an authentication token.
              // For example, you might retrieve a token from shared preferences.
              // String? token = yourAuthService.getToken();
              // if (token != null) {
              //   options.headers['Authorization'] = 'Bearer $token';
              // }
              return handler.next(
                options,
              ); // Continues the request process.
            },
        // -- Intercepts the response after it is received.
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
              ); // Continues the response process.
            },
        // -- Intercepts any errors that occur during the request.
        onError:
            (
              DioException e,
              handler,
            ) async {
              print(
                'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
              );

              // If the error is a 401 Unauthorized, it likely means the user's token has expired.
              // In this case, you can redirect them to the login screen.
              if (e.response?.statusCode ==
                  401) {
                // You might want to clear user data and tokens from storage here.
                // await yourAuthService.logout();

                // Use the global navigator key to navigate to the login screen,
                // removing all previous routes.
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/login',
                  (
                    route,
                  ) => false,
                );
              }

              return handler.next(
                e,
              ); // Continues the error handling process.
            },
      ),
    );
  }

  // A generic GET request method.
  Future<
    Response
  >
  get(
    String path, {
    Map<
      String,
      dynamic
    >?
    queryParameters,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  // A generic POST request method.
  Future<
    Response
  >
  post(
    String path, {
    dynamic data,
  }) {
    return _dio.post(
      path,
      data: data,
    );
  }

  // You can add other HTTP methods (PUT, DELETE, etc.) as needed.
}
