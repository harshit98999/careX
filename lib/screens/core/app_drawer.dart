// lib/screens/core/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/secure_storage_service.dart'; // To clear tokens on logout
// To access navigatorKey

class AppDrawer
    extends
        StatelessWidget {
  const AppDrawer({
    super.key,
  });

  // --- NEW: Logout Handler ---
  void _logout(
    BuildContext context,
  ) async {
    // Clear user data from the provider
    Provider.of<
          UserProvider
        >(
          context,
          listen: false,
        )
        .logout();

    // Clear stored tokens
    await SecureStorageService().deleteTokens();

    // Navigate to splash/login screen and clear the navigation stack
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(
      '/splash',
      (
        Route<
          dynamic
        >
        route,
      ) => false,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(
            context,
          ), // This will now be dynamic
          _buildDrawerItem(
            context: context,
            icon: Icons.home_outlined,
            text: 'Home',
            routeName: '/dashboard',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.person_outline,
            text: 'Profile',
            routeName: '/profile',
          ),
          // ... other drawer items
          _buildDrawerItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            text: 'Appointments',
            routeName: '/appointments',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.history_outlined,
            text: 'History',
            routeName: '/history',
          ),
          const Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.receipt_long_outlined,
            text: 'Prescriptions',
            routeName: '/prescriptions',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.science_outlined,
            text: 'Lab Results',
            routeName: '/lab-results',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.payment_outlined,
            text: 'Billing & Payments',
            routeName: '/billing',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.person_search_outlined,
            text: 'Find a Doctor',
            routeName: '/find_a_doctor',
          ),
          const Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.settings_outlined,
            text: 'Settings',
            routeName: '/settings',
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.lato(
                fontSize: 16,
              ),
            ),
            onTap: () => _logout(
              context,
            ), // Use the new handler
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
  ) {
    // Consume the UserProvider to get user data
    return Consumer<
      UserProvider
    >(
      builder:
          (
            context,
            userProvider,
            child,
          ) {
            final user = userProvider.user;

            // Use a placeholder if the profile picture URL is null or empty
            final imageProvider =
                (user?.profilePicture !=
                        null &&
                    user!.profilePicture!.isNotEmpty)
                ? NetworkImage(
                    user.profilePicture!,
                  )
                : const AssetImage(
                        'assets/images/default_avatar.png',
                      )
                      as ImageProvider;

            return UserAccountsDrawerHeader(
              accountName: Text(
                user?.fullName ??
                    "Guest User", // Display full name
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                user?.email ??
                    "no-email@example.com", // Display email
                style: GoogleFonts.lato(),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: imageProvider,
                onBackgroundImageError:
                    (
                      _,
                      __,
                    ) {},
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
            );
          },
    );
  }

  // ... (_buildDrawerItem method remains unchanged)
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required String routeName,
  }) {
    final String? currentRoute = ModalRoute.of(
      context,
    )?.settings.name;
    final bool isSelected =
        currentRoute ==
        routeName;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(
                context,
              ).primaryColor
            : null,
      ),
      title: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: isSelected
              ? FontWeight.bold
              : FontWeight.normal,
          color: isSelected
              ? Theme.of(
                  context,
                ).primaryColor
              : null,
        ),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).pop(); // Always close the drawer first
        if (!isSelected) {
          // This replaces the current screen, preventing a back button to the previous one.
          Navigator.of(
            context,
          ).pushReplacementNamed(
            routeName,
          );
        }
      },
    );
  }
}
