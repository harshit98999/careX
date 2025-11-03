// lib/screens/core/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar
    extends
        StatelessWidget
    implements
        PreferredSizeWidget {
  // A boolean to determine the style of the AppBar based on scroll position.
  final bool isScrolled;

  const CustomAppBar({
    super.key,
    required this.isScrolled,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Define colors based on the scroll state.
    final Color backgroundColor = isScrolled
        ? Theme.of(
            context,
          ).primaryColor
        : Colors.white;
    final Color foregroundColor = isScrolled
        ? Colors.white
        : Theme.of(
            context,
          ).primaryColor;

    return AppBar(
      // Set the background color dynamically.
      backgroundColor: backgroundColor,
      elevation: isScrolled
          ? 4.0
          : 0.0, // Add shadow when scrolled.
      // Use a leading IconButton to open the drawer.
      leading: IconButton(
        icon: Icon(
          Icons.sort, // A common icon for opening a menu/drawer.
          color: foregroundColor,
          size: 28,
        ),
        onPressed: () {
          Scaffold.of(
            context,
          ).openDrawer();
        },
      ),
      // The title is the app name, "CareX".
      title: Text(
        "CareX",
        style: GoogleFonts.lato(
          // Set the text color dynamically.
          color: foregroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Notification Icon
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            // Set the icon color dynamically.
            color: foregroundColor,
            size: 28,
          ),
          onPressed: () {
            // TODO: Implement notification functionality
          },
        ),
        // User Profile Picture
        const Padding(
          padding: EdgeInsets.only(
            right: 16.0,
            left: 8.0,
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              'assets/images/doctor_1.jpg',
            ),
          ),
        ),
      ],
    );
  }

  // Defines the standard height for the AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight,
  );
}
