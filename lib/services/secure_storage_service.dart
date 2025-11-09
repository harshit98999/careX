// lib/services/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Save both tokens
  Future<
    void
  >
  saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(
      key: _accessTokenKey,
      value: accessToken,
    );
    await _storage.write(
      key: _refreshTokenKey,
      value: refreshToken,
    );
  }

  // Get the access token
  Future<
    String?
  >
  getAccessToken() async {
    return await _storage.read(
      key: _accessTokenKey,
    );
  }

  // Get the refresh token
  Future<
    String?
  >
  getRefreshToken() async {
    return await _storage.read(
      key: _refreshTokenKey,
    );
  }

  // Delete all tokens (for logout)
  Future<
    void
  >
  deleteTokens() async {
    await _storage.delete(
      key: _accessTokenKey,
    );
    await _storage.delete(
      key: _refreshTokenKey,
    );
  }
}
