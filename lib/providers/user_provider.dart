// lib/providers/user_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider
    with
        ChangeNotifier {
  User? _user;
  final ApiService _apiService = ApiService();

  User? get user => _user;

  // Fetches the user profile from the API and updates the state
  Future<
    void
  >
  fetchAndSetUser() async {
    try {
      final userProfile = await _apiService.getUserProfile();
      _user = userProfile;
      notifyListeners(); // Notify all listening widgets of the change
    } catch (
      e
    ) {
      print(
        "Failed to fetch user in provider: $e",
      );
      // Optionally handle the error, e.g., by logging the user out
      _user = null;
      notifyListeners();
    }
  }

  // Clears user data on logout
  void logout() {
    _user = null;
    notifyListeners();
  }
}
