// lib/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Fetches the user profile from the API and updates the state.
  Future<void> fetchAndSetUser() async {
    // Only set loading to true if the user isn't already set.
    // This prevents a full-screen loader on simple profile refreshes.
    if (_user == null) {
      _setLoading(true);
    }

    try {
      final userProfile = await _apiService.getUserProfile();
      _user = userProfile;
      // --- CRITICAL FIX ---
      // Explicitly notify listeners right after the user object is successfully set.
      // This ensures the AuthWrapper rebuilds immediately with the new user role.
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to fetch user in provider: $e");
      _user = null;
      // Also notify listeners of the failure to update the UI.
      notifyListeners();
    } finally {
      // Ensure loading is always set to false at the end.
      _setLoading(false);
    }
  }

  /// Clears user data and the stored auth token on logout.
  void logout() {
    _user = null;
    _apiService.clearAuthToken();
    // Notify listeners that the user is now null.
    notifyListeners();
  }
}
