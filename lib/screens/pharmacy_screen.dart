// lib/screens/pharmacy_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_drawer.dart';
import 'core/custom_app_bar.dart';
import '../models/prescription_data.dart';
import 'pharmacy/upload_prescription_screen.dart';
import 'pharmacy/find_pharmacy_screen.dart';

class PharmacyScreen
    extends
        StatefulWidget {
  const PharmacyScreen({
    super.key,
  });

  @override
  State<
    PharmacyScreen
  >
  createState() => _PharmacyScreenState();
}

class _PharmacyScreenState
    extends
        State<
          PharmacyScreen
        > {
  // Mock data for demonstration
  final List<
    PrescriptionData
  >
  activePrescriptions = [
    const PrescriptionData(
      name: "Lisinopril",
      dosage: "10 mg",
      status: PrescriptionStatus.Active,
      refills: 2,
      doctor: "Dr. Reed",
      date: "Oct 15, 2025",
      instructions: "",
    ),
    const PrescriptionData(
      name: "Metformin",
      dosage: "500 mg",
      status: PrescriptionStatus.Active,
      refills: 1,
      doctor: "Dr. Reed",
      date: "Aug 22, 2025",
      instructions: "",
    ),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: const CustomAppBar(
        isScrolled: false,
        title: "Pharmacy",
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pharmacy Services",
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // Primary Action Cards
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.upload_file_outlined,
                    title: "Upload\nPrescription",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (
                              context,
                            ) => const UploadPrescriptionScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.refresh_outlined,
                    title: "Request\na Refill",
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/prescriptions',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            // Active Prescriptions Section
            _buildSectionHeader(
              "Your Active Prescriptions",
              () => Navigator.pushNamed(
                context,
                '/prescriptions',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: Column(
                children: activePrescriptions
                    .map(
                      (
                        rx,
                      ) => _PrescriptionListItem(
                        prescription: rx,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            // More Services Section
            _buildSectionHeader(
              "More Services",
              null,
            ),
            const SizedBox(
              height: 12,
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                ),
                title: Text(
                  "Find a Pharmacy",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (
                          context,
                        ) => const FindPharmacyScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    VoidCallback? onViewAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onViewAll !=
            null)
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              "View All",
            ),
          ),
      ],
    );
  }
}

// A reusable widget for the main action cards
class _ActionCard
    extends
        StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        12,
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
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A compact list item for displaying prescriptions on the hub
class _PrescriptionListItem
    extends
        StatelessWidget {
  final PrescriptionData prescription;
  const _PrescriptionListItem({
    required this.prescription,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.medication_outlined,
        color: Colors.blue,
      ),
      title: Text(
        "${prescription.name} (${prescription.dosage})",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${prescription.refills} refills left",
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () => Navigator.pushNamed(
        context,
        '/prescriptions',
      ),
    );
  }
}
