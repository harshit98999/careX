// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all providers
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

// --- Import the new AuthWrapper ---
import 'screens/core/auth_wrapper.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/profile_screen.dart';

// Import all your other existing screens to register their routes
import 'screens/hospitals_screen.dart';
import 'screens/find_a_doctor_screen.dart';
import 'screens/pharmacy_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/lab_results_screen.dart';
import 'screens/prescriptions_screen.dart';
import 'screens/book_lab_test_screen.dart';

// A global navigator key is useful for service-level navigation.
final GlobalKey<
  NavigatorState
>
navigatorKey =
    GlobalKey<
      NavigatorState
    >();

void
main() async {
  // --- MODIFIED: No changes here, but confirming it's correct ---
  WidgetsFlutterBinding.ensureInitialized();
  // We no longer need to call tryAutoLogin here, as the SplashScreen will handle it.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => ThemeProvider(),
        ),
        // --- MODIFIED: Initialize UserProvider directly ---
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => UserProvider(),
        ),
      ],
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'CareX',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(
          0xFF6A49E2,
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF4F6F8,
        ),
        fontFamily: 'Lato',
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
            ).copyWith(
              secondary: Colors.amber,
            ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(
            0xFF6A49E2,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(
          0xFF7B5DFF,
        ),
        scaffoldBackgroundColor: const Color(
          0xFF121212,
        ),
        fontFamily: 'Lato',
        colorScheme:
            ColorScheme.fromSwatch(
              brightness: Brightness.dark,
              primarySwatch: Colors.deepPurple,
            ).copyWith(
              secondary: Colors.amberAccent,
            ),
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
        '/register':
            (
              context,
            ) => const RegisterScreen(),

        // --- CORE CHANGE ---
        // Create a single, central route for authenticated users.
        // The AuthWrapper will decide which dashboard to show.
        '/':
            (
              context,
            ) => const AuthWrapper(),

        // --- DEPRECATED: Remove the old direct dashboard routes ---
        // '/dashboard': (context) => const HomeDashboardScreen(),
        // '/doctor-dashboard': (context) => const DoctorDashboardScreen(),

        // Your other routes remain unchanged
        '/profile':
            (
              context,
            ) => const ProfileScreen(),
        '/hospitals':
            (
              context,
            ) => const HospitalsScreen(),
        '/find_a_doctor':
            (
              context,
            ) => const FindADoctorScreen(),
        '/pharmacy':
            (
              context,
            ) => const PharmacyScreen(),
        '/appointments':
            (
              context,
            ) => const AppointmentsScreen(),
        '/lab-results':
            (
              context,
            ) => const LabResultsScreen(),
        '/prescriptions':
            (
              context,
            ) => const PrescriptionsScreen(),
        '/book_lab_test':
            (
              context,
            ) => const BookLabTestScreen(),
      },
    );
  }
}
