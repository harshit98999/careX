// lib/screens/settings/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen
    extends
        StatelessWidget {
  const PrivacyPolicyScreen({
    super.key,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Text(
          "Your privacy policy text goes here...",
        ),
      ),
    );
  }
}
