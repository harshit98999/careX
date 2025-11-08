// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
// Import all screens, including the new ones
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/core/home_dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/lab_results_screen.dart';
import 'screens/find_a_doctor_screen.dart';
import 'screens/prescriptions_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/hospitals_screen.dart'; // <-- NEW
import 'screens/pharmacy_screen.dart'; // <-- NEW
import 'screens/book_lab_test_screen.dart'; // <-- NEW

void
main() {
  runApp(
    ChangeNotifierProvider(
      create:
          (
            _,
          ) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp
    extends
        StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    final themeProvider =
        Provider.of<
          ThemeProvider
        >(
          context,
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareX',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        primaryColor: const Color(
          0xFF6A49E2,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFF6A49E2,
          ),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(
          0xFF8A6EE5,
        ),
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFF8A6EE5,
          ),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        // Auth Flow
        '/splash':
            (
              context,
            ) => const SplashScreen(),
        '/login':
            (
              context,
            ) => const LoginScreen(),

        // Main App
        '/dashboard':
            (
              context,
            ) => const HomeDashboardScreen(),
        '/profile':
            (
              context,
            ) => const ProfileScreen(),
        '/appointments':
            (
              context,
            ) => const AppointmentsScreen(),
        '/history':
            (
              context,
            ) => const HistoryScreen(),
        '/settings':
            (
              context,
            ) => const SettingsScreen(),
        '/lab-results':
            (
              context,
            ) => const LabResultsScreen(),
        '/find_a_doctor':
            (
              context,
            ) => const FindADoctorScreen(),
        '/prescriptions':
            (
              context,
            ) => const PrescriptionsScreen(),
        '/billing':
            (
              context,
            ) => const BillingScreen(),

        // --- ADDED NEW ROUTES ---
        '/hospitals':
            (
              context,
            ) => const HospitalsScreen(),
        '/pharmacy':
            (
              context,
            ) => const PharmacyScreen(),
        '/book_lab_test':
            (
              context,
            ) => const BookLabTestScreen(),
      },
    );
  }
}
