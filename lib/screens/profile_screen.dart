// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import supporting files
import 'core/app_drawer.dart';

// Import the new screens
import 'settings/notifications_screen.dart';
import 'settings/change_password_screen.dart';
import 'settings/language_screen.dart';
import 'support/help_support_screen.dart';
import 'support/about_screen.dart';

class ProfileScreen
    extends
        StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(
              context,
            ),
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                children: [
                  _buildSectionHeader(
                    "Personal Information",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const InfoCard(
                    details: {
                      "Full Name": "Mad Ull",
                      "Email": "mad.ull@example.com",
                      "Phone": "+1 (555) 123-4567",
                      "Date of Birth": "January 15, 1985",
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildSectionHeader(
                    "Account Settings",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SettingsItem(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (
                                context,
                              ) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.lock_outline,
                    title: "Change Password",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (
                                context,
                              ) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.language_outlined,
                    title: "Language",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (
                                context,
                              ) => const LanguageScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildSectionHeader(
                    "Support",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SettingsItem(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (
                                context,
                              ) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.info_outline,
                    title: "About CareX",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (
                                context,
                              ) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(
            30,
          ),
          bottomRight: Radius.circular(
            30,
          ),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              'assets/images/doctor_1.jpg',
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Mad Ull",
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "mad.ull@example.com",
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.white.withOpacity(
                0.8,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
            ),
            label: const Text(
              "Edit Profile",
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(
                0.2,
              ),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class InfoCard
    extends
        StatelessWidget {
  final Map<
    String,
    String
  >
  details;
  const InfoCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(
        0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          children: details.entries.map(
            (
              entry,
            ) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        entry.key,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class SettingsItem
    extends
        StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(
        0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: Theme.of(
            context,
          ).primaryColor,
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
    );
  }
}
