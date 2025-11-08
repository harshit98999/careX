// lib/screens/core/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer
    extends
        StatelessWidget {
  const AppDrawer({
    super.key,
  });

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
          ),
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
            onTap: () {
              // This correctly clears the navigation stack and returns to the splash screen.
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
  ) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        "Mad Ull",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      accountEmail: Text(
        "mad.ull@example.com",
        style: GoogleFonts.lato(),
      ),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage(
          'assets/images/doctor_1.jpg',
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).primaryColor,
      ),
    );
  }

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
