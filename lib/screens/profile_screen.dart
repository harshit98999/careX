// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

// Import supporting files and screens
import 'core/app_drawer.dart';
import 'edit_profile_screen.dart'; // Import the new edit screen
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
    // Use a Consumer to listen for changes in the UserProvider
    return Consumer<
      UserProvider
    >(
      builder:
          (
            context,
            userProvider,
            child,
          ) {
            final User? user = userProvider.user;

            // Show a loading screen if user data is not yet available
            if (user ==
                null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Profile",
                  ),
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Once user data is available, build the full profile screen
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
                      user,
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
                          InfoCard(
                            details: {
                              "Full Name": user.fullName,
                              "Email": user.email,
                              "Phone":
                                  user.phoneNumber ??
                                  "Not provided",
                              "Date of Birth":
                                  user.dateOfBirth ??
                                  "Not provided",
                              "Bio":
                                  user.bio ??
                                  "Not provided",
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
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (
                                      _,
                                    ) => const NotificationsScreen(),
                              ),
                            ),
                          ),
                          SettingsItem(
                            icon: Icons.lock_outline,
                            title: "Change Password",
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (
                                      _,
                                    ) => const ChangePasswordScreen(),
                              ),
                            ),
                          ),
                          SettingsItem(
                            icon: Icons.language_outlined,
                            title: "Language",
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (
                                      _,
                                    ) => const LanguageScreen(),
                              ),
                            ),
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
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (
                                      _,
                                    ) => const HelpSupportScreen(),
                              ),
                            ),
                          ),
                          SettingsItem(
                            icon: Icons.info_outline,
                            title: "About CareX",
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (
                                      _,
                                    ) => const AboutScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    User user,
  ) {
    final imageProvider =
        (user.profilePicture !=
                null &&
            user.profilePicture!.isNotEmpty)
        ? NetworkImage(
            user.profilePicture!,
          )
        : const AssetImage(
                'assets/images/default_avatar.png',
              )
              as ImageProvider;

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
          CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider,
            onBackgroundImageError:
                (
                  _,
                  __,
                ) {},
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            user.fullName,
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
            user.email,
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
            onPressed: () {
              // Navigate to the edit screen, passing the current user data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (
                        context,
                      ) => EditProfileScreen(
                        user: user,
                      ),
                ),
              );
            },
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

// --- SUPPORTING WIDGETS FOR PROFILE SCREEN ---

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
