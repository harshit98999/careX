// lib/screens/book_lab_test_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import supporting files
import 'core/custom_app_bar.dart';
import 'core/app_drawer.dart';
import '../models/lab_test_data.dart';
import 'labs/lab_booking_confirmation_screen.dart';

class BookLabTestScreen
    extends
        StatefulWidget {
  const BookLabTestScreen({
    super.key,
  });

  @override
  State<
    BookLabTestScreen
  >
  createState() => _BookLabTestScreenState();
}

class _BookLabTestScreenState
    extends
        State<
          BookLabTestScreen
        > {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "All";

  // Mock data for available lab tests
  final List<
    LabTestData
  >
  allLabTests = [
    const LabTestData(
      id: 'cbc',
      name: 'Complete Blood Count (CBC)',
      category: 'Blood Test',
      description: 'Measures different components of your blood.',
      price: 25.00,
      preparation: 'None',
    ),
    const LabTestData(
      id: 'lp',
      name: 'Lipid Panel',
      category: 'Blood Test',
      description: 'Measures fats and fatty substances in the blood.',
      price: 40.00,
      preparation: 'Fasting required for 8-12 hours.',
    ),
    const LabTestData(
      id: 'ua',
      name: 'Urinalysis',
      category: 'Urine Test',
      description: 'Checks for a variety of disorders.',
      price: 20.00,
      preparation: 'None',
    ),
    const LabTestData(
      id: 'xray',
      name: 'Chest X-Ray',
      category: 'Imaging',
      description: 'Produces images of the heart, lungs, and bones.',
      price: 75.00,
      preparation: 'None',
    ),
    const LabTestData(
      id: 'mri',
      name: 'Brain MRI',
      category: 'Imaging',
      description: 'Detailed images of the brain and brain stem.',
      price: 350.00,
      preparation: 'Remove all metal objects.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () {
        setState(
          () => _searchQuery = _searchController.text,
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<
    LabTestData
  >
  get _filteredLabTests {
    List<
      LabTestData
    >
    tests = allLabTests;
    if (_selectedFilter !=
        "All") {
      tests = tests
          .where(
            (
              test,
            ) =>
                test.category ==
                _selectedFilter,
          )
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      tests = tests
          .where(
            (
              test,
            ) => test.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    return tests;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: const CustomAppBar(
        isScrolled: false,
        title: "Book a Lab Test",
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(
                  height: 16,
                ),
                _buildFilterChips(),
              ],
            ),
          ),
          Expanded(
            child: _filteredLabTests.isEmpty
                ? const Center(
                    child: Text(
                      "No tests found.",
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    itemCount: _filteredLabTests.length,
                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                          final labTest = _filteredLabTests[index];
                          return LabTestCard(
                            labTest: labTest,
                            onBookNow: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (
                                        context,
                                      ) => LabBookingConfirmationScreen(
                                        labTest: labTest,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Search for a test...",
        prefixIcon: const Icon(
          Icons.search,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      "All",
      "Blood Test",
      "Urine Test",
      "Imaging",
    ];
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters.map(
          (
            filter,
          ) {
            final isSelected =
                _selectedFilter ==
                filter;
            return Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
              ),
              child: ChoiceChip(
                label: Text(
                  filter,
                ),
                selected: isSelected,
                onSelected:
                    (
                      selected,
                    ) {
                      if (selected) {
                        setState(
                          () => _selectedFilter = filter,
                        );
                      }
                    },
                selectedColor:
                    Theme.of(
                      context,
                    ).primaryColor.withOpacity(
                      0.1,
                    ),
                labelStyle: GoogleFonts.lato(
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).primaryColor
                      : Colors.black87,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).primaryColor
                        : Colors.grey[300]!,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

// A dedicated card widget for displaying a single lab test
class LabTestCard
    extends
        StatelessWidget {
  final LabTestData labTest;
  final VoidCallback onBookNow;

  const LabTestCard({
    super.key,
    required this.labTest,
    required this.onBookNow,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labTest.name,
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              labTest.description,
              style: GoogleFonts.lato(
                color: Colors.grey[600],
              ),
            ),
            const Divider(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${labTest.price.toStringAsFixed(2)}",
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Select",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
