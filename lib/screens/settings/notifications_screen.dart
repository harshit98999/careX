// lib/screens/settings/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen
    extends
        StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<
    NotificationsScreen
  >
  createState() => _NotificationsScreenState();
}

class _NotificationsScreenState
    extends
        State<
          NotificationsScreen
        > {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _appointmentReminders = true;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
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
          _buildNotificationSwitch(
            title: "Push Notifications",
            subtitle: "Receive updates and alerts on your device.",
            value: _pushNotifications,
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      _pushNotifications = value;
                    },
                  );
                },
          ),
          _buildNotificationSwitch(
            title: "Email Notifications",
            subtitle: "Get summaries and important news in your inbox.",
            value: _emailNotifications,
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      _emailNotifications = value;
                    },
                  );
                },
          ),
          _buildNotificationSwitch(
            title: "Appointment Reminders",
            subtitle: "Reminders for your upcoming appointments.",
            value: _appointmentReminders,
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      _appointmentReminders = value;
                    },
                  );
                },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<
      bool
    >
    onChanged,
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
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.lato(
            color: Colors.black54,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: Theme.of(
          context,
        ).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
    );
  }
}
