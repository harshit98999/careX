// lib/screens/find_a_doctor/doctor_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/doctor_data.dart';
import './booking_screen.dart'; // The next screen in the flow

class DoctorProfileScreen
    extends
        StatelessWidget {
  final DoctorData doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Profile",
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
          children: [
            _buildProfileHeader(
              context,
            ),
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    "About",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    doctor.about,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const Divider(
                    height: 32,
                  ),
                  _buildSectionHeader(
                    "Working Hours",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildWorkingHours(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookButton(
        context,
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      width: double.infinity,
      color: Colors.grey[100],
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              doctor.imagePath,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            doctor.name,
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            doctor.specialty,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                doctor.rating.toString(),
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildWorkingHours() {
    return Column(
      children: doctor.workingHours.entries.map(
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
                  style: GoogleFonts.lato(),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildBookButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: ElevatedButton(
        onPressed: doctor.isAvailable
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (
                          context,
                        ) => BookingScreen(
                          doctor: doctor,
                        ),
                  ),
                );
              }
            : null,
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
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text(
          doctor.isAvailable
              ? "Book Appointment"
              : "Currently Unavailable",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
