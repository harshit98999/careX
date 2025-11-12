// lib/screens/core/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'doctor_dashboard_screen.dart';
import 'home_dashboard_screen.dart';
import '../auth/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchAndSetUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = userProvider.user;

        if (user != null) {
          // --- ADDED FOR DEBUGGING ---
          // Check your debug console for this message when you log in.
          // It will tell you exactly what role the AuthWrapper is seeing.
          debugPrint("AuthWrapper: User is present. Role: ${user.role}");

          if (user.role == 'DOCTOR') {
            return const DoctorDashboardScreen();
          } else {
            return const HomeDashboardScreen();
          }
        }

        // If user is null after loading is finished, they are logged out.
        debugPrint("AuthWrapper: No user found. Directing to LoginScreen.");
        return const LoginScreen();
      },
    );
  }
}
