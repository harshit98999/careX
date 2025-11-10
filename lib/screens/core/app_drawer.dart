// lib/screens/core/app_drawer.dart

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for PlatformException
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/secure_storage_service.dart'; // To clear tokens on logout

class AppDrawer
    extends
        StatefulWidget {
  const AppDrawer({
    super.key,
  });

  @override
  State<
    AppDrawer
  >
  createState() => _AppDrawerState();
}

class _AppDrawerState
    extends
        State<
          AppDrawer
        > {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  // --- MODIFIED: Added error handling for the plugin ---
  Future<
    void
  >
  _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(
          () {
            _appVersion = packageInfo.version;
          },
        );
      }
    } on PlatformException {
      // This will catch the MissingPluginException and others.
      debugPrint(
        "Failed to get app version, plugin not found.",
      );
      if (mounted) {
        setState(
          () {
            _appVersion = 'N/A'; // Show a fallback value
          },
        );
      }
    }
  }

  void _logout(
    BuildContext context,
  ) async {
    Provider.of<
          UserProvider
        >(
          context,
          listen: false,
        )
        .logout();
    await SecureStorageService().deleteTokens();
    if (mounted) {
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
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      child: Column(
        children: [
          // The main content of the drawer
          Expanded(
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
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Divider(),
                ),
                _buildDrawerSectionTitle(
                  "Health Records",
                ),
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
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Divider(),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_search_outlined,
                  text: 'Find a Doctor',
                  routeName: '/find_a_doctor',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  text: 'Settings',
                  routeName: '/settings',
                ),
              ],
            ),
          ),
          // This container holds the logout button and app version at the bottom
          Container(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              0,
              16.0,
              24.0,
            ),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _logout(
                    context,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Version $_appVersion',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
  ) {
    final user =
        Provider.of<
              UserProvider
            >(
              context,
              listen: false,
            )
            .user;
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

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        60,
        20,
        30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(
              context,
            ).primaryColor,
            Theme.of(
              context,
            ).primaryColor.withOpacity(
              0.8,
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: imageProvider,
            onBackgroundImageError:
                (
                  _,
                  __,
                ) {},
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            user?.fullName ??
                "Guest User",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user?.email ??
                "no-email@example.com",
            style: GoogleFonts.lato(
              color: Colors.white.withOpacity(
                0.9,
              ),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        16.0,
        16.0,
        8.0,
      ),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required String routeName,
  }) {
    final currentRoute = ModalRoute.of(
      context,
    )?.settings.name;
    final isSelected =
        currentRoute ==
        routeName;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Material(
        color: isSelected
            ? Theme.of(
                context,
              ).primaryColor.withOpacity(
                0.1,
              )
            : Colors.transparent,
        borderRadius: BorderRadius.circular(
          10,
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(
              context,
            ).pop();
            if (!isSelected) {
              Navigator.of(
                context,
              ).pushReplacementNamed(
                routeName,
              );
            }
          },
          borderRadius: BorderRadius.circular(
            10,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).primaryColor
                      : Theme.of(
                          context,
                        ).textTheme.bodyLarge?.color,
                ),
                const SizedBox(
                  width: 24,
                ),
                Text(
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
                        : Theme.of(
                            context,
                          ).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
