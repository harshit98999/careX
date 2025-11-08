// lib/screens/lab_results_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import supporting files and the new models
import './core/custom_app_bar.dart';
import './core/app_drawer.dart';
import './lab_result_detail_screen.dart';
import '../models/lab_result_data.dart'; // <-- IMPORT THE NEW MODEL

class LabResultsScreen
    extends
        StatefulWidget {
  const LabResultsScreen({
    super.key,
  });

  @override
  State<
    LabResultsScreen
  >
  createState() => _LabResultsScreenState();
}

class _LabResultsScreenState
    extends
        State<
          LabResultsScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

  // UPDATED: Mock data now uses the new, strongly-typed models.
  final List<
    LabResultData
  >
  labResults = [
    const LabResultData(
      title: "Complete Blood Count (CBC)",
      date: "October 25, 2025",
      status: "Results Available",
      icon: Icons.bloodtype_outlined,
      doctor: "Dr. Evelyn Reed",
      biomarkers: [
        BiomarkerData(
          name: "Hemoglobin",
          value: "14.5 g/dL",
          range: "13.5-17.5",
          isNormal: true,
        ),
        BiomarkerData(
          name: "White Blood Cells",
          value: "11.5 x 10^9/L",
          range: "4.5-11.0",
          isNormal: false,
        ),
        BiomarkerData(
          name: "Platelets",
          value: "250 x 10^9/L",
          range: "150-450",
          isNormal: true,
        ),
      ],
      comments: "Slight elevation in white blood cells, possibly due to a minor infection. Recommend monitoring. All other values are within the normal range.",
    ),
    const LabResultData(
      title: "Lipid Panel",
      date: "September 12, 2025",
      status: "Results Available",
      icon: Icons.favorite_border,
      doctor: "Dr. Evelyn Reed",
      biomarkers: [
        BiomarkerData(
          name: "Total Cholesterol",
          value: "210 mg/dL",
          range: "< 200",
          isNormal: false,
        ),
        BiomarkerData(
          name: "HDL Cholesterol",
          value: "55 mg/dL",
          range: "> 40",
          isNormal: true,
        ),
        BiomarkerData(
          name: "LDL Cholesterol",
          value: "130 mg/dL",
          range: "< 100",
          isNormal: false,
        ),
      ],
      comments: "Cholesterol levels are elevated. Recommend dietary changes and a follow-up test in 3 months.",
    ),
  ];

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
        () => _isScrolled = true,
      );
    } else if (_scrollController.offset <=
            10 &&
        _isScrolled) {
      setState(
        () => _isScrolled = false,
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "Lab Results",
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(
          16.0,
        ),
        itemCount: labResults.length,
        itemBuilder:
            (
              context,
              index,
            ) {
              final result = labResults[index];
              // Pass the strongly-typed object to the card and detail screen
              return LabResultSummaryCard(
                result: result,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (
                            context,
                          ) => LabResultDetailScreen(
                            resultData: result,
                          ),
                    ),
                  );
                },
              );
            },
      ),
    );
  }
}

class LabResultSummaryCard
    extends
        StatelessWidget {
  // UPDATED: The card now accepts a single LabResultData object.
  final LabResultData result;
  final VoidCallback onTap;

  const LabResultSummaryCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(
        0.1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    Theme.of(
                      context,
                    ).primaryColor.withOpacity(
                      0.1,
                    ),
                child: Icon(
                  result.icon,
                  color: Theme.of(
                    context,
                  ).primaryColor,
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
                      result.title,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      result.date,
                      style: GoogleFonts.lato(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      result.status,
                      style: GoogleFonts.lato(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
