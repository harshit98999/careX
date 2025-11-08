// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your custom widgets and the new model/screens
import './core/custom_app_bar.dart';
import './core/app_drawer.dart';
import '../models/history_item_data.dart';
import './history/visit_details_screen.dart';
import './history/lab_result_details_screen.dart';
import './history/prescription_details_screen.dart';

class HistoryScreen
    extends
        StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<
    HistoryScreen
  >
  createState() => _HistoryScreenState();
}

class _HistoryScreenState
    extends
        State<
          HistoryScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      _onScroll,
    );
  }

  void _onScroll() {
    if (_scrollController.offset >
            10 &&
        !_isScrolled) {
      setState(
        () {
          _isScrolled = true;
        },
      );
    } else if (_scrollController.offset <=
            10 &&
        _isScrolled) {
      setState(
        () {
          _isScrolled = false;
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );
    _scrollController.dispose();
    super.dispose();
  }

  // FIXED: Navigation logic is now cleaner and safer.
  void _navigateToDetails(
    BuildContext context,
    HistoryItemData item,
  ) {
    // Determine the destination widget based on the item type.
    Widget destination;
    switch (item.type) {
      case HistoryType.visit:
        destination = VisitDetailsScreen(
          visitData: item,
        );
        break;
      case HistoryType.lab:
        destination = LabResultDetailsScreen(
          labData: item,
        );
        break;
      case HistoryType.prescription:
        destination = PrescriptionDetailsScreen(
          prescriptionData: item,
        );
        break;
    }

    // Navigate to the determined screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (
              context,
            ) => destination,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "Medical History",
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChips(),
              const SizedBox(
                height: 24,
              ),
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = [
      'All',
      'Visits',
      'Labs',
      'Prescriptions',
    ];
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters
            .map(
              (
                label,
              ) => _buildChip(
                label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChip(
    String label,
  ) {
    final bool isSelected =
        _selectedFilter ==
        label;
    return Padding(
      padding: const EdgeInsets.only(
        right: 8.0,
      ),
      child: ChoiceChip(
        label: Text(
          label,
        ),
        selected: isSelected,
        onSelected:
            (
              selected,
            ) {
              // FIXED: Added curly braces
              if (selected) {
                setState(
                  () {
                    _selectedFilter = label;
                  },
                );
              }
            },
        selectedColor: Theme.of(
          context,
        ).primaryColor,
        labelStyle: GoogleFonts.lato(
          color: isSelected
              ? Colors.white
              : Colors.black,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
          side: BorderSide(
            color: isSelected
                ? Theme.of(
                    context,
                  ).primaryColor
                : Colors.grey[300]!,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final List<
      HistoryItemData
    >
    historyData = [
      const HistoryItemData(
        id: 'v1',
        type: HistoryType.visit,
        title: 'Consultation with Dr. Reed',
        details: 'Cardiology follow-up',
        date: 'Oct 28, 2025',
        icon: Icons.medical_services_outlined,
        detailedContent: {
          'Doctor': 'Dr. Evelyn Reed',
          'Specialty': 'Cardiology',
          'Reason': 'Routine follow-up after stress test.',
          'Notes': 'Patient is responding well to medication. Blood pressure is stable. Recommend continuing current treatment plan and re-evaluating in 6 months.',
        },
      ),
      const HistoryItemData(
        id: 'l1',
        type: HistoryType.lab,
        title: 'Blood Test Results',
        details: 'Full metabolic panel',
        date: 'Oct 25, 2025',
        icon: Icons.science_outlined,
      ),
      const HistoryItemData(
        id: 'p1',
        type: HistoryType.prescription,
        title: 'New Prescription Issued',
        details: 'Metformin - 500mg',
        date: 'Oct 22, 2025',
        icon: Icons.receipt_long_outlined,
      ),
      const HistoryItemData(
        id: 'v2',
        type: HistoryType.visit,
        title: 'Check-up with Dr. Chen',
        details: 'Dermatology annual check',
        date: 'Sep 15, 2025',
        icon: Icons.medical_services_outlined,
        detailedContent: {
          'Doctor': 'Dr. Marcus Chen',
          'Specialty': 'Dermatology',
          'Reason': 'Annual skin check.',
          'Notes': 'No issues found.',
        },
      ),
    ];

    final filteredList = historyData.where(
      (
        item,
      ) {
        // FIXED: Added curly braces to all if statements
        if (_selectedFilter ==
            'All') {
          return true;
        }
        if (_selectedFilter ==
                'Visits' &&
            item.type ==
                HistoryType.visit) {
          return true;
        }
        if (_selectedFilter ==
                'Labs' &&
            item.type ==
                HistoryType.lab) {
          return true;
        }
        if (_selectedFilter ==
                'Prescriptions' &&
            item.type ==
                HistoryType.prescription) {
          return true;
        }
        return false;
      },
    ).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 48.0,
          ),
          child: Text(
            'No records found for this category.',
          ),
        ),
      );
    }

    return Column(
      children: filteredList.map(
        (
          item,
        ) {
          return InkWell(
            onTap: () => _navigateToDetails(
              context,
              item,
            ),
            borderRadius: BorderRadius.circular(
              12,
            ),
            child: HistoryItemCard(
              item: item,
            ),
          );
        },
      ).toList(),
    );
  }
}

class HistoryItemCard
    extends
        StatelessWidget {
  final HistoryItemData item;

  const HistoryItemCard({
    super.key,
    required this.item,
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
          12,
        ),
        boxShadow: [
          BoxShadow(
            // FIXED: Replaced deprecated withOpacity
            color:
                Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(
                  0.05,
                ),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            // FIXED: Replaced deprecated withOpacity
            backgroundColor:
                Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(
                  0.1,
                ),
            radius: 24,
            child: Icon(
              item.icon,
              color: Theme.of(
                context,
              ).primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  item.details,
                  style: GoogleFonts.lato(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  item.date,
                  style: GoogleFonts.lato(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
