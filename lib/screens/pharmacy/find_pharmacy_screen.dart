// lib/screens/pharmacy/find_pharmacy_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/custom_app_bar.dart';

class FindPharmacyScreen
    extends
        StatelessWidget {
  const FindPharmacyScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: const CustomAppBar(
        isScrolled: false,
        title: "Find a Pharmacy",
      ),
      body: Center(
        child: Text(
          "Pharmacy Locator Feature",
          style: GoogleFonts.lato(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
