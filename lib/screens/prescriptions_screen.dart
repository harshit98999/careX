// lib/screens/prescriptions_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import supporting files
import 'core/custom_app_bar.dart';
import 'core/app_drawer.dart';
import '../models/prescription_data.dart';
import './prescriptions/prescription_details_screen.dart'; // Import detail screen

class PrescriptionsScreen
    extends
        StatefulWidget {
  const PrescriptionsScreen({
    super.key,
  });

  @override
  State<
    PrescriptionsScreen
  >
  createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState
    extends
        State<
          PrescriptionsScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

  // UPDATED: Mock data now uses the PrescriptionData model
  final List<
    PrescriptionData
  >
  prescriptions = [
    const PrescriptionData(
      name: "Lisinopril",
      dosage: "10 mg",
      instructions: "Take one tablet daily in the morning.",
      doctor: "Dr. Evelyn Reed",
      date: "October 15, 2025",
      refills: 2,
      status: PrescriptionStatus.Active,
      pharmacy: "CareX Pharmacy Central",
    ),
    const PrescriptionData(
      name: "Metformin",
      dosage: "500 mg",
      instructions: "Take one tablet twice a day with meals.",
      doctor: "Dr. Evelyn Reed",
      date: "August 22, 2025",
      refills: 1,
      status: PrescriptionStatus.Active,
      pharmacy: "CareX Pharmacy Central",
    ),
    const PrescriptionData(
      name: "Amoxicillin",
      dosage: "250 mg",
      instructions: "Take one capsule every 8 hours for 7 days.",
      doctor: "Dr. Marcus Chen",
      date: "June 05, 2025",
      refills: 0,
      status: PrescriptionStatus.Expired,
    ),
    const PrescriptionData(
      name: "Atorvastatin",
      dosage: "20 mg",
      instructions: "Take one tablet daily at bedtime.",
      doctor: "Dr. Evelyn Reed",
      date: "July 30, 2025",
      refills: 0,
      status: PrescriptionStatus.Active,
      pharmacy: "CareX Pharmacy Downtown",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      _onScroll,
    );
  }

  void _onScroll() {
    if (_scrollController.offset >
            10 &&
        !_isScrolled) {
      setState(
        () => _isScrolled = true,
      );
    } else if (_scrollController.offset <=
            10 &&
        _isScrolled) {
      setState(
        () => _isScrolled = false,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "Prescriptions",
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          80,
        ), // Added bottom padding
        itemCount: prescriptions.length,
        itemBuilder:
            (
              context,
              index,
            ) {
              final prescription = prescriptions[index];
              // The card is now wrapped in a GestureDetector for navigation
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (
                            context,
                          ) => PrescriptionDetailsScreen(
                            prescription: prescription,
                          ),
                    ),
                  );
                },
                child: PrescriptionCard(
                  prescription: prescription,
                ),
              );
            },
      ),
    );
  }
}

class PrescriptionCard
    extends
        StatelessWidget {
  // UPDATED: Card now takes a single data object
  final PrescriptionData prescription;

  const PrescriptionCard({
    super.key,
    required this.prescription,
  });

  // NEW: Method to show the refill confirmation dialog
  void _showRefillConfirmation(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder:
          (
            BuildContext dialogContext,
          ) {
            return AlertDialog(
              title: const Text(
                "Confirm Refill Request",
              ),
              content: Text(
                "Request a refill for ${prescription.name}?",
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Cancel",
                  ),
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop(),
                ),
                ElevatedButton(
                  child: const Text(
                    "Confirm",
                  ),
                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                    ).pop();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Refill requested for ${prescription.name}.",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            );
          },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isActive =
        prescription.status ==
        PrescriptionStatus.Active;
    final String statusText = isActive
        ? "Active"
        : "Expired";

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(
        0.1,
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "${prescription.name} (${prescription.dosage})",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
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
                      6,
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.lato(
                      color: isActive
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              prescription.instructions,
              style: GoogleFonts.lato(
                color: Colors.grey[700],
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const Divider(
              height: 24,
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
            const SizedBox(
              height: 16,
            ),
            if (isActive &&
                prescription.refills >
                    0)
              ElevatedButton.icon(
                onPressed: () => _showRefillConfirmation(
                  context,
                ), // Implemented functionality
                icon: const Icon(
                  Icons.refresh_outlined,
                ),
                label: const Text(
                  "Request Refill",
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    44,
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                ),
              ),
          ],
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
        vertical: 3.0,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
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
              style: GoogleFonts.lato(),
            ),
          ),
        ],
      ),
    );
  }
}
