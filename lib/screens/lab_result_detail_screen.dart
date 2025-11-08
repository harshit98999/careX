// lib/screens/lab_result_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/lab_result_data.dart'; // <-- IMPORT THE NEW MODEL

class LabResultDetailScreen
    extends
        StatelessWidget {
  // UPDATED: Accepts the strongly-typed LabResultData model.
  final LabResultData resultData;

  const LabResultDetailScreen({
    super.key,
    required this.resultData,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        // UPDATED: AppBar style for consistency
        title: Text(
          resultData.title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              "Report Details",
            ),
            const SizedBox(
              height: 8,
            ),
            _buildDetailRow(
              "Date:",
              resultData.date,
            ),
            _buildDetailRow(
              "Ordering Physician:",
              resultData.doctor,
            ),
            const SizedBox(
              height: 24,
            ),
            _buildHeader(
              "Key Biomarkers",
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
                side: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Column(
                  // Now iterating over a list of BiomarkerData objects
                  children: resultData.biomarkers.map(
                    (
                      biomarker,
                    ) {
                      return _buildBiomarkerRow(
                        label: biomarker.name,
                        value: biomarker.value,
                        range: biomarker.range,
                        isNormal: biomarker.isNormal,
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            _buildHeader(
              "Physician's Comments",
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                16,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(
                  0.05,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Text(
                resultData.comments,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton.icon(
              // IMPLEMENTED: Download functionality
              onPressed: () {
                // In a real app, you would use a package like `pdf` or `printing`
                // to generate and save a PDF file.
                // For this example, we'll show a confirmation message.
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Downloading report...",
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              icon: const Icon(
                Icons.download_outlined,
              ),
              label: const Text(
                "Download Full Report (PDF)",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  50,
                ),
                backgroundColor: Theme.of(
                  context,
                ).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 20,
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
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiomarkerRow({
    required String label,
    required String value,
    required String range,
    required bool isNormal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isNormal
                      ? Colors.black87
                      : Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Ref. Range: $range",
            style: GoogleFonts.lato(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
