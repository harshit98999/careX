// lib/screens/core/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/secure_storage_service.dart';

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
    // Navigate and clear the stack
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(
      '/splash',
      (
        route,
      ) => false,
    );
  }

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

    // Consume the provider to get user data for the avatar
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
          onPressed: () {},
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
                offset: const Offset(
                  0,
                  50,
                ),
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
                          _logout(
                            context,
                          );
                          break;
                      }
                    },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: imageProvider, // Use dynamic image
                  onBackgroundImageError:
                      (
                        _,
                        __,
                      ) {},
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
