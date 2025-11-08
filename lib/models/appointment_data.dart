// lib/models/appointment_data.dart

// A data class to hold appointment information.

class AppointmentData {
  final String doctorName;
  final String specialty;
  final String imagePath;
  final String date;
  final String time;
  final String location;
  final bool isUpcoming;

  const AppointmentData({
    required this.doctorName,
    required this.specialty,
    required this.imagePath,
    required this.date,
    required this.time,
    required this.location,
    required this.isUpcoming,
  });
}
