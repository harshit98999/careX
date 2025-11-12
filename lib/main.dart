// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all providers
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

// Import services and wrappers
import 'services/api_service.dart'; // Import to use the navigatorKey
import 'screens/core/auth_wrapper.dart';

// Import all screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/hospitals_screen.dart';
import 'screens/find_a_doctor_screen.dart';
import 'screens/pharmacy_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/lab_results_screen.dart';
import 'screens/prescriptions_screen.dart';
import 'screens/book_lab_test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      // Use the global navigatorKey from ApiService for context-less navigation
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'CareX',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6A49E2),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.amber),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF6A49E2),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF7B5DFF),
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.amberAccent),
      ),
      initialRoute: '/splash',
      routes: {
        // Auth Flow
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // --- CORE AUTHENTICATED ROUTE ---
        // This is the single entry point for any logged-in user.
        // AuthWrapper will correctly direct CLIENTS and DOCTORS.
        '/': (context) => const AuthWrapper(),

        // Other application routes
        '/profile': (context) => const ProfileScreen(),
        '/hospitals': (context) => const HospitalsScreen(),
        '/find_a_doctor': (context) => const FindADoctorScreen(),
        '/pharmacy': (context) => const PharmacyScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/lab-results': (context) => const LabResultsScreen(),
        '/prescriptions': (context) => const PrescriptionsScreen(),
        '/book_lab_test': (context) => const BookLabTestScreen(),
      },
    );
  }
}
