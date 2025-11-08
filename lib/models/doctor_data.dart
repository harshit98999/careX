// lib/models/doctor_data.dart

class DoctorData {
  final String name;
  final String specialty;
  final double rating;
  final String imagePath;
  final bool isAvailable;
  // Add more detailed fields for the profile screen
  final String about;
  final Map<
    String,
    String
  >
  workingHours;

  const DoctorData({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imagePath,
    required this.isAvailable,
    this.about = "A dedicated and experienced professional committed to providing the best patient care.",
    this.workingHours = const {
      "Mon - Fri": "9:00 AM - 5:00 PM",
      "Saturday": "10:00 AM - 2:00 PM",
      "Sunday": "Closed",
    },
  });
}
