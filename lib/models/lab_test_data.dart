// lib/models/lab_test_data.dart

class LabTestData {
  final String id;
  final String name;
  final String category; // For filtering (e.g., "Blood Test", "Imaging")
  final String description;
  final double price;
  final String preparation; // e.g., "Fasting required for 8 hours"

  const LabTestData({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.preparation,
  });
}
