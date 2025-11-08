// lib/screens/history/lab_result_details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/history_item_data.dart';

// Similar structure to VisitDetailsScreen, but for lab results.
class LabResultDetailsScreen
    extends
        StatelessWidget {
  final HistoryItemData labData;
  const LabResultDetailsScreen({
    super.key,
    required this.labData,
  });
  // ... build method and helpers ...
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lab Result",
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
          "Details for ${labData.title}",
          style: GoogleFonts.lato(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
