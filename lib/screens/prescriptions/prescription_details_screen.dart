// lib/screens/prescriptions/prescription_details_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/prescription_data.dart';

class PrescriptionDetailsScreen
    extends
        StatelessWidget {
  final PrescriptionData prescription;

  const PrescriptionDetailsScreen({
    super.key,
    required this.prescription,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isActive =
        prescription.status ==
        PrescriptionStatus.Active;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          prescription.name,
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
                _buildHeader(
                  context,
                  isActive,
                ),
                const SizedBox(
                  height: 16,
                ),
                _buildSectionHeader(
                  "Instructions",
                ),
                Text(
                  prescription.instructions,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const Divider(
                  height: 32,
                ),
                _buildSectionHeader(
                  "Details",
                ),
                _buildDetailRow(
                  "Dosage:",
                  prescription.dosage,
                ),
                _buildDetailRow(
                  "Prescribed by:",
                  prescription.doctor,
                ),
                _buildDetailRow(
                  "Date Issued:",
                  prescription.date,
                ),
                _buildDetailRow(
                  "Refills Left:",
                  prescription.refills.toString(),
                ),
                _buildDetailRow(
                  "Pharmacy:",
                  prescription.pharmacy ??
                      "Not specified",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isActive,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "${prescription.name} (${prescription.dosage})",
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color:
                (isActive
                        ? Colors.green
                        : Colors.grey)
                    .withOpacity(
                      0.1,
                    ),
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          child: Text(
            isActive
                ? "Active"
                : "Expired",
            style: GoogleFonts.lato(
              color: isActive
                  ? Colors.green.shade700
                  : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
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
          color: Colors.black87,
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
            width: 120,
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
