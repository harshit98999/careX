// lib/models/prescription_data.dart

// Use an enum for status to prevent typos and improve code clarity.
enum PrescriptionStatus {
  Active,
  Expired,
}

class PrescriptionData {
  final String name;
  final String dosage;
  final String instructions;
  final String doctor;
  final String date;
  final int refills;
  final PrescriptionStatus status;
  // Add more fields if needed, e.g., pharmacy
  final String? pharmacy;

  const PrescriptionData({
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.doctor,
    required this.date,
    required this.refills,
    required this.status,
    this.pharmacy,
  });
}
