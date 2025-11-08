// lib/screens/appointments/components/appointment_detail_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the model and other necessary screens/dialogs
import '../../../models/appointment_data.dart';
import '../reschedule_screen.dart';
import '../../../shared/dialogs/leave_review_dialog.dart';

class AppointmentDetailCard
    extends
        StatelessWidget {
  final String location;
  final bool isUpcoming;
  final AppointmentData appointmentData;

  const AppointmentDetailCard({
    super.key,
    required this.location,
    required this.isUpcoming,
    required this.appointmentData,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDoctorInfo(),
          const Divider(
            height: 32,
            thickness: 0.5,
          ),
          _buildDetailRow(
            Icons.calendar_today_outlined,
            appointmentData.date,
          ),
          const SizedBox(
            height: 8,
          ),
          _buildDetailRow(
            Icons.access_time_outlined,
            appointmentData.time,
          ),
          const SizedBox(
            height: 8,
          ),
          _buildDetailRow(
            Icons.location_on_outlined,
            location,
          ),
          const SizedBox(
            height: 20,
          ),
          _buildActionButtons(
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
            appointmentData.imagePath,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointmentData.doctorName,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              appointmentData.specialty,
              style: GoogleFonts.lato(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[500],
          size: 18,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          text,
          style: GoogleFonts.lato(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
  ) {
    if (isUpcoming) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showCancelConfirmation(
                context,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                side: BorderSide(
                  color: Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              child: const Text(
                "Cancel",
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (
                          context,
                        ) => RescheduleScreen(
                          appointment: appointmentData,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                backgroundColor: Theme.of(
                  context,
                ).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              child: const Text(
                "Reschedule",
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showReviewDialog(
                context,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              child: const Text(
                "Leave a Review",
              ),
            ),
          ),
        ],
      );
    }
  }

  void _showCancelConfirmation(
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
                "Cancel Appointment",
              ),
              content: const Text(
                "Are you sure you want to cancel this appointment?",
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "No",
                  ),
                  onPressed: () => Navigator.of(
                    dialogContext,
                  ).pop(),
                ),
                TextButton(
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                    ).pop();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Appointment Canceled",
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                ),
              ],
            );
          },
    );
  }

  void _showReviewDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder:
          (
            BuildContext dialogContext,
          ) {
            return const LeaveReviewDialog();
          },
    );
  }
}
