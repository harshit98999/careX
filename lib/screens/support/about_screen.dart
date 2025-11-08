// lib/screens/support/about_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen
    extends
        StatelessWidget {
  const AboutScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About CareX",
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
      body: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          children: [
            const FlutterLogo(
              size: 80,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "CareX",
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Your Health, Connected.",
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            Card(
              elevation: 1.5,
              shadowColor: Colors.black.withOpacity(
                0.08,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Column(
                children: [
                  _buildAboutTile(
                    "Version",
                    "1.0.0",
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildAboutTile(
                    "Terms of Service",
                    "",
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildAboutTile(
                    "Privacy Policy",
                    "",
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              "© 2025 CareX. All Rights Reserved.",
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTile(
    String title,
    String subtitle,
  ) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: GoogleFonts.lato(
                color: Colors.black54,
              ),
            )
          : const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
      onTap: () {},
    );
  }
}
