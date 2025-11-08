// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Import supporting files and new screens
import 'core/custom_app_bar.dart';
import 'core/app_drawer.dart';
import '../providers/theme_provider.dart';
import 'settings/language_settings_screen.dart';
import 'settings/change_password_screen.dart';
import 'settings/privacy_policy_screen.dart';

class SettingsScreen
    extends
        StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<
    SettingsScreen
  >
  createState() => _SettingsScreenState();
}

class _SettingsScreenState
    extends
        State<
          SettingsScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      _onScroll,
    );
  }

  void _onScroll() {
    if (_scrollController.offset >
            10 &&
        !_isScrolled) {
      setState(
        () => _isScrolled = true,
      );
    } else if (_scrollController.offset <=
            10 &&
        _isScrolled) {
      setState(
        () => _isScrolled = false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // Access the ThemeProvider
    final themeProvider =
        Provider.of<
          ThemeProvider
        >(
          context,
        );

    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "Settings",
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              "Account",
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSettingsCard(
              children: [
                _buildNavigationItem(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profile",
                  onTap: () =>
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(
                        '/profile',
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildSectionHeader(
              "Notifications",
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSettingsCard(
              children: [
                _buildToggleItem(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: "Push Notifications",
                  value: _notificationsEnabled,
                  onChanged:
                      (
                        value,
                      ) {
                        setState(
                          () => _notificationsEnabled = value,
                        );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? "Notifications Enabled"
                                  : "Notifications Disabled",
                            ),
                          ),
                        );
                      },
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildSectionHeader(
              "Appearance",
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSettingsCard(
              children: [
                _buildToggleItem(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  value: themeProvider.isDarkMode,
                  onChanged:
                      (
                        value,
                      ) {
                        final provider =
                            Provider.of<
                              ThemeProvider
                            >(
                              context,
                              listen: false,
                            );
                        provider.setThemeMode(
                          value
                              ? ThemeMode.dark
                              : ThemeMode.light,
                        );
                      },
                ),
                _buildNavigationItem(
                  context,
                  icon: Icons.language_outlined,
                  title: "Language",
                  subtitle: "English",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (
                            _,
                          ) => const LanguageSettingsScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildSectionHeader(
              "Security & Privacy",
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSettingsCard(
              children: [
                _buildNavigationItem(
                  context,
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
                _buildNavigationItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (
                            _,
                          ) => const PrivacyPolicyScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget
  _buildSectionHeader(
    String title,
  ) => Text(
    title,
    style: GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  Widget _buildSettingsCard({
    required List<
      Widget
    >
    children,
  }) {
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
      margin: EdgeInsets.zero,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
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
      subtitle:
          subtitle !=
              null
          ? Text(
              subtitle,
              style: GoogleFonts.lato(),
            )
          : null,
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
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<
      bool
    >
    onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(
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
      activeThumbColor: Theme.of(
        context,
      ).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
    );
  }
}
