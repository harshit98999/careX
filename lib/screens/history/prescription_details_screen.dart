// lib/screens/history/prescription_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/history_item_data.dart';

// Similar structure, but for prescriptions.
class PrescriptionDetailsScreen
    extends
        StatelessWidget {
  final HistoryItemData prescriptionData;
  const PrescriptionDetailsScreen({
    super.key,
    required this.prescriptionData,
  });
  // ... build method and helpers ...
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prescription",
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
      body: Center(
        child: Text(
          "Details for ${prescriptionData.title}",
          style: GoogleFonts.lato(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
