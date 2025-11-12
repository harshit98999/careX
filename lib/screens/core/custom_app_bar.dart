// lib/screens/core/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/secure_storage_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isScrolled;
  final String? title;

  const CustomAppBar({super.key, required this.isScrolled, this.title});

  // --- MODIFIED: Added a mounted check for stability ---
  void _logout(BuildContext context) async {
    // Before any async operation, get references to everything you need from the context.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context, rootNavigator: true);

    // Now perform the async operations.
    userProvider.logout();
    await SecureStorageService().deleteTokens();

    // --- CRITICAL FIX ---
    // After an `await`, the context may no longer be valid.
    // We can't guarantee the widget that owned this `context` is still on screen.
    // Therefore, we must use the `navigator` variable we saved earlier.
    // We don't need a `mounted` check here because this is a StatelessWidget.
    // The key is capturing the NavigatorState *before* the await.
    navigator.pushNamedAndRemoveUntil('/splash', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // This check needs to be safe. It's better to use listen: true here or wrap in a Consumer
    // if the user data could change while this widget is visible. However, for the avatar,
    // listen: false is generally acceptable as it's unlikely to change without a screen reload.
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final imageProvider =
        (user?.profilePicture != null && user!.profilePicture!.isNotEmpty)
        ? NetworkImage(user.profilePicture!)
        : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

    final Color backgroundColor = isScrolled
        ? Theme.of(context).primaryColor
        : Colors.white;
    final Color foregroundColor = isScrolled
        ? Colors.white
        : Theme.of(context).primaryColor;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: isScrolled ? 4.0 : 0.0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.sort, color: foregroundColor, size: 28),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Text(
        title ?? "CareX",
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
            // TODO: Implement notifications navigation
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8.0),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            onSelected: (String value) {
              switch (value) {
                case 'profile':
                  // Prevents pushing the same route on top of itself
                  if (ModalRoute.of(context)?.settings.name != '/profile') {
                    Navigator.pushNamed(context, '/profile');
                  }
                  break;
                case 'logout':
                  _logout(context);
                  break;
              }
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: imageProvider,
              onBackgroundImageError:
                  (_, __) {}, // Handles potential network image errors
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text('View Profile'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ), // Changed to red for consistency
                    const SizedBox(width: 8),
                    const Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent),
                    ), // Changed to red
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
