// lib/screens/core/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'doctor_dashboard_screen.dart';
import 'home_dashboard_screen.dart';
import '../auth/login_screen.dart';

class AuthWrapper
    extends
        StatelessWidget {
  const AuthWrapper({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Listen to the UserProvider to get the current user's state
    final user =
        Provider.of<
              UserProvider
            >(
              context,
            )
            .user;

    // This is a safety check. If for some reason we get to this screen
    // without a logged-in user, we send them back to the login page.
    if (user ==
        null) {
      return const LoginScreen();
    }

    // This is the core logic:
    // Check the user's role and return the appropriate dashboard.
    if (user.role ==
        'DOCTOR') {
      return const DoctorDashboardScreen();
    } else {
      // For 'CLIENT' or any other role, show the default home dashboard.
      return const HomeDashboardScreen();
    }
  }
}
