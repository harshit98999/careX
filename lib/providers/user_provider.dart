// lib/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider
    with
        ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();

  User? get user => _user;

  // --- NEW: Implement the tryAutoLogin method ---
  /// Checks for a stored token and tries to fetch the user profile.
  /// This is called on app startup to automatically log the user in.
  Future<
    void
  >
  tryAutoLogin() async {
    // This relies on your ApiService to have a mechanism for securely storing
    // and retrieving an authentication token.
    // fetchAndSetUser will use that token to get the profile.
    // If no token exists or the token is invalid, it will fail gracefully.
    await fetchAndSetUser();
  }

  /// Fetches the user profile from the API and updates the state.
  /// If it succeeds, the user is considered logged in.
  Future<
    void
  >
  fetchAndSetUser() async {
    try {
      // This assumes your apiService.getUserProfile() method is set up
      // to automatically include the auth token in its headers.
      final userProfile = await _apiService.getUserProfile();
      _user = userProfile;
      notifyListeners(); // Notify all listening widgets of the change
    } catch (
      e
    ) {
      // --- UPDATED: Replaced print with debugPrint ---
      debugPrint(
        "Failed to fetch user in provider: $e",
      );
      // If fetching fails (e.g., no token, expired token), ensure user is null.
      _user = null;
      notifyListeners();
    }
  }

  /// Clears user data and the stored auth token on logout.
  void logout() {
    _user = null;
    // This assumes your ApiService has a method to delete the token.
    _apiService.clearAuthToken(); // This will now work correctly.
    notifyListeners();
  }
}
