// lib/models/lab_result_data.dart

import 'package:flutter/material.dart';

// A model for an individual biomarker within a lab report.
class BiomarkerData {
  final String name;
  final String value;
  final String range;
  final bool isNormal;

  const BiomarkerData({
    required this.name,
    required this.value,
    required this.range,
    required this.isNormal,
  });
}

// A model for the entire lab result report.
class LabResultData {
  final String title;
  final String date;
  final String status;
  final IconData icon;
  final String doctor;
  final List<
    BiomarkerData
  >
  biomarkers;
  final String comments;

  const LabResultData({
    required this.title,
    required this.date,
    required this.status,
    required this.icon,
    required this.doctor,
    required this.biomarkers,
    required this.comments,
  });
}
