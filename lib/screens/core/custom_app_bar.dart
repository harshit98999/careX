// lib/screens/core/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar
    extends
        StatelessWidget
    implements
        PreferredSizeWidget {
  final bool isScrolled;
  final String? title;

  const CustomAppBar({
    super.key,
    required this.isScrolled,
    this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
      backgroundColor: backgroundColor,
      elevation: isScrolled
          ? 4.0
          : 0.0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.sort,
          color: foregroundColor,
          size: 28,
        ),
        onPressed: () => Scaffold.of(
          context,
        ).openDrawer(),
      ),
      title: Text(
        title ??
            "CareX",
        style: GoogleFonts.lato(
          color: foregroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: foregroundColor,
            size: 28,
          ),
          onPressed: () {
            // Notification functionality can be added here
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 8.0,
          ),
          child:
              PopupMenuButton<
                String
              >(
                // --- NEW: Add an offset to position the menu below the avatar ---
                offset: const Offset(
                  0,
                  50,
                ),
                // -----------------------------------------------------------------
                onSelected:
                    (
                      String value,
                    ) {
                      switch (value) {
                        case 'profile':
                          if (ModalRoute.of(
                                context,
                              )?.settings.name !=
                              '/profile') {
                            Navigator.pushNamed(
                              context,
                              '/profile',
                            );
                          }
                          break;
                        case 'logout':
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil(
                            '/splash',
                            (
                              route,
                            ) => false,
                          );
                          break;
                      }
                    },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    'assets/images/doctor_1.jpg',
                  ),
                ),
                itemBuilder:
                    (
                      BuildContext context,
                    ) =>
                        <
                          PopupMenuEntry<
                            String
                          >
                        >[
                          PopupMenuItem<
                            String
                          >(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Theme.of(
                                    context,
                                  ).primaryColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  'View Profile',
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<
                            String
                          >(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Theme.of(
                                    context,
                                  ).primaryColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  'Logout',
                                ),
                              ],
                            ),
                          ),
                        ],
              ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight,
  );
}
