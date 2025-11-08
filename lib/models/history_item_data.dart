// lib/models/history_item_data.dart

import 'package:flutter/material.dart';

// An enum to clearly define the type of history record.
enum HistoryType {
  visit,
  lab,
  prescription,
}

class HistoryItemData {
  final String id;
  final HistoryType type;
  final String title;
  final String details;
  final String date;
  final IconData icon;

  // A map to hold the rich content for the detail screens.
  final Map<
    String,
    String
  >?
  detailedContent;

  const HistoryItemData({
    required this.id,
    required this.type,
    required this.title,
    required this.details,
    required this.date,
    required this.icon,
    this.detailedContent,
  });
}
