// lib/screens/core/doctor_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'app_drawer.dart'; // Re-use the existing drawer
import 'custom_app_bar.dart'; // Re-use the existing app bar

class DoctorDashboardScreen
    extends
        StatelessWidget {
  const DoctorDashboardScreen({
    super.key,
  });

  Future<
    bool
  >
  _onWillPop(
    BuildContext context,
  ) async {
    final shouldPop =
        await showDialog<
          bool
        >(
          context: context,
          builder:
              (
                context,
              ) {
                return AlertDialog(
                  title: const Text(
                    'Exit Application',
                  ),
                  content: const Text(
                    'Are you sure you want to close the app?',
                  ),
                  actions:
                      <
                        Widget
                      >[
                        TextButton(
                          child: const Text(
                            'No',
                          ),
                          onPressed: () =>
                              Navigator.of(
                                context,
                              ).pop(
                                false,
                              ),
                        ),
                        TextButton(
                          child: const Text(
                            'Yes',
                          ),
                          onPressed: () =>
                              Navigator.of(
                                context,
                              ).pop(
                                true,
                              ),
                        ),
                      ],
                );
              },
        );
    return shouldPop ??
        false;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // You can still get the user's name for a personalized welcome
    final userName =
        Provider.of<
              UserProvider
            >(
              context,
            )
            .user
            ?.fullName ??
        'Doctor';

    return WillPopScope(
      onWillPop: () => _onWillPop(
        context,
      ),
      child: Scaffold(
        // You can reuse the CustomAppBar and AppDrawer for a consistent UI
        appBar: const CustomAppBar(
          isScrolled: false, // Or manage scroll state if needed
          title: 'Doctor Dashboard',
        ),
        drawer: const AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 80,
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Welcome, $userName!',
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'This is the Doctor Dashboard.',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
