// lib/screens/support/help_support_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen
    extends
        StatelessWidget {
  const HelpSupportScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help & Support",
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
      body: ListView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        children: [
          _buildSectionHeader(
            "Frequently Asked Questions",
          ),
          const SizedBox(
            height: 12,
          ),
          _buildFAQItem(
            "How do I book an appointment?",
            "You can book an appointment by navigating to the 'Find a Doctor' section, selecting a doctor, and choosing an available time slot.",
          ),
          _buildFAQItem(
            "Where can I see my lab results?",
            "Your lab results are available in the 'Lab Results' section, accessible from the home screen or the app drawer.",
          ),
          _buildFAQItem(
            "How do I update my personal information?",
            "You can edit your personal details by going to the 'Profile' screen and tapping the 'Edit Profile' button.",
          ),
          const Divider(
            height: 48,
          ),
          _buildSectionHeader(
            "Contact Us",
          ),
          const SizedBox(
            height: 12,
          ),
          _buildContactItem(
            icon: Icons.email_outlined,
            title: "Email Support",
            subtitle: "support@carex.com",
          ),
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: "Phone Support",
            subtitle: "+1 (800) 555-CARE",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
  ) {
    return Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFAQItem(
    String question,
    String answer,
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
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16,
            ),
            child: Text(
              answer,
              style: GoogleFonts.lato(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
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
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.lato(),
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
