// lib/models/hospital_data.dart

class HospitalData {
  final String name;
  final String address;
  final double distance; // in km
  final double rating;
  final String imagePath;
  final List<
    String
  >
  services;
  final Map<
    String,
    String
  >
  hours;
  final String phone;
  final String website;

  const HospitalData({
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.imagePath,
    required this.services,
    required this.hours,
    required this.phone,
    required this.website,
  });
}
