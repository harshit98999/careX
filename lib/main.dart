// lib/main.dart

import 'package:flutter/material.dart';

// Import all of your screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
// Note: OtpVerificationScreen is navigated to from LoginScreen, so it doesn't need a named route here.
import 'screens/core/home_dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareX',
      theme: ThemeData(
        primaryColor: const Color(0xFF6A49E2),
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A49E2)),
        useMaterial3: true,
      ),
      // The app will always start at the splash screen.
      initialRoute: '/splash',
      // Define all the navigation routes for your app.
      routes: {
        // Auth Flow Routes
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),

        // Main App Routes (after login)
        // We rename the dashboard route to avoid conflict with the root '/'.
        '/dashboard': (context) => const HomeDashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
