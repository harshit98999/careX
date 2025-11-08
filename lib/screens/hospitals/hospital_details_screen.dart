// lib/screens/hospitals/hospital_details_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the package
import '../../models/hospital_data.dart';

class HospitalDetailsScreen
    extends
        StatelessWidget {
  final HospitalData hospital;

  const HospitalDetailsScreen({
    super.key,
    required this.hospital,
  });

  // Helper function to launch URLs
  Future<
    void
  >
  _launchURL(
    Uri url,
  ) async {
    if (!await launchUrl(
      url,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hospital.name,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              hospital.imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospital.name,
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    hospital.address,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${hospital.rating} Rating",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 32,
                  ),
                  _buildActionButtons(),
                  const Divider(
                    height: 32,
                  ),
                  _buildSectionHeader(
                    "Services Offered",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: hospital.services
                        .map(
                          (
                            service,
                          ) => Chip(
                            label: Text(
                              service,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildSectionHeader(
                    "Operating Hours",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildHoursTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.directions,
            ),
            label: const Text(
              "Directions",
            ),
            onPressed: () {
              final Uri mapsUrl = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(hospital.address)}",
              );
              _launchURL(
                mapsUrl,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(
              Icons.call,
            ),
            label: const Text(
              "Call Now",
            ),
            onPressed: () {
              final Uri phoneUrl = Uri(
                scheme: 'tel',
                path: hospital.phone,
              );
              _launchURL(
                phoneUrl,
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
  ) {
    return Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHoursTable() {
    return Column(
      children: hospital.hours.entries.map(
        (
          entry,
        ) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  entry.value,
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
