// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all providers
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

// Import all services
import 'services/api_service.dart';
import 'services/secure_storage_service.dart';

// Import all screen routes
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/core/home_dashboard_screen.dart';
import 'screens/profile_screen.dart';

/// The main entry point of the application.
/// It is `async` to allow for pre-run checks.
void
main() async {
  // Step 1: Ensure Flutter's widget binding is initialized.
  // This is mandatory before using any plugins or async operations before runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Step 2: Determine the initial route based on authentication status.
  final secureStorage = SecureStorageService();
  final userProvider = UserProvider();
  String initialRoute = '/splash'; // Default to splash for new users

  // Check if a refresh token exists in secure storage.
  final refreshToken = await secureStorage.getRefreshToken();

  // If a token exists, try to use it to fetch the user's profile.
  if (refreshToken !=
      null) {
    try {
      // Pre-load the user data into the UserProvider instance.
      await userProvider.fetchAndSetUser();
      // If successful, the user is authenticated. Set the starting screen to the dashboard.
      initialRoute = '/dashboard';
    } catch (
      e
    ) {
      // If fetching fails, the token is likely invalid or expired.
      print(
        "Pre-run authentication check failed: $e",
      );
      // Clear the invalid token to prevent future errors.
      await secureStorage.deleteTokens();
      // Keep the initial route as '/splash' to force a new login.
      initialRoute = '/splash';
    }
  }

  // Step 3: Run the Flutter app.
  runApp(
    MultiProvider(
      providers: [
        // Provider for theme (light/dark mode)
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => ThemeProvider(),
        ),
        // Provider for user data. Use .value since we created the instance above.
        ChangeNotifierProvider.value(
          value: userProvider,
        ),
      ],
      // Pass the determined initialRoute to the MyApp widget.
      child: MyApp(
        initialRoute: initialRoute,
      ),
    ),
  );
}

/// The root widget of the application.
class MyApp
    extends
        StatelessWidget {
  /// The initial route the app should start on ('/splash' or '/dashboard').
  final String initialRoute;

  const MyApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Access the ThemeProvider to set the app's theme mode.
    final themeProvider =
        Provider.of<
          ThemeProvider
        >(
          context,
        );

    return MaterialApp(
      // The global navigator key is essential for service-level navigation (e.g., auto-logout).
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'CareX',
      themeMode: themeProvider.themeMode,

      // --- Define Light Theme ---
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

      // --- Define Dark Theme ---
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

      // Use the initial route determined in the main() function.
      initialRoute: initialRoute,

      // Define all possible navigation routes for the app.
      routes: {
        // Authentication Flow
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

        // Core App Screens
        '/dashboard':
            (
              context,
            ) => const HomeDashboardScreen(),
        '/profile':
            (
              context,
            ) => const ProfileScreen(),

        // You can add all other routes here as your app grows
        // '/appointments': (context) => const AppointmentsScreen(),
        // '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
