// lib/screens/history/visit_details_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/history_item_data.dart';

class VisitDetailsScreen
    extends
        StatelessWidget {
  final HistoryItemData visitData;

  const VisitDetailsScreen({
    super.key,
    required this.visitData,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Visit Details",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  "Doctor:",
                  visitData.detailedContent?['Doctor'] ??
                      'N/A',
                ),
                _buildDetailRow(
                  "Specialty:",
                  visitData.detailedContent?['Specialty'] ??
                      'N/A',
                ),
                _buildDetailRow(
                  "Date:",
                  visitData.date,
                ),
                const Divider(
                  height: 32,
                ),
                _buildSectionHeader(
                  "Reason for Visit",
                ),
                Text(
                  visitData.detailedContent?['Reason'] ??
                      'No details provided.',
                  style: GoogleFonts.lato(
                    height: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSectionHeader(
                  "Doctor's Notes",
                ),
                Text(
                  visitData.detailedContent?['Notes'] ??
                      'No notes available.',
                  style: GoogleFonts.lato(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
