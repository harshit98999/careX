// lib/screens/find_a_doctor_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import supporting files
import 'core/custom_app_bar.dart';
import 'core/app_drawer.dart';
import '../models/doctor_data.dart';
import './find_a_doctor/doctor_profile_screen.dart';

class FindADoctorScreen
    extends
        StatefulWidget {
  const FindADoctorScreen({
    super.key,
  });

  @override
  State<
    FindADoctorScreen
  >
  createState() => _FindADoctorScreenState();
}

class _FindADoctorScreenState
    extends
        State<
          FindADoctorScreen
        > {
  late final ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  bool _isScrolled = false;

  // State for search and filter
  String _searchQuery = "";
  String _selectedFilter = "All";

  // Using the new DoctorData model
  final List<
    DoctorData
  >
  allDoctors = [
    const DoctorData(
      name: "Dr. Evelyn Reed",
      specialty: "Cardiologist",
      rating: 4.9,
      imagePath: 'assets/images/doctor_1.jpg',
      isAvailable: true,
    ),
    const DoctorData(
      name: "Dr. Marcus Chen",
      specialty: "Dermatologist",
      rating: 4.8,
      imagePath: 'assets/images/doctor_2.jpg',
      isAvailable: false,
    ),
    const DoctorData(
      name: "Dr. Lena Petrova",
      specialty: "Pediatrician",
      rating: 4.9,
      imagePath: 'assets/images/doctor_3.jpg',
      isAvailable: true,
    ),
    const DoctorData(
      name: "Dr. Ben Carter",
      specialty: "Neurologist",
      rating: 4.7,
      imagePath: 'assets/images/doctor_1.jpg',
      isAvailable: true,
    ),
    const DoctorData(
      name: "Dr. Sofia Reyes",
      specialty: "Cardiologist",
      rating: 4.8,
      imagePath: 'assets/images/doctor_2.jpg',
      isAvailable: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      _onScroll,
    );
    _searchController.addListener(
      () {
        setState(
          () => _searchQuery = _searchController.text,
        );
      },
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
    _searchController.dispose();
    super.dispose();
  }

  // Live filtering logic
  List<
    DoctorData
  >
  get _filteredDoctors {
    List<
      DoctorData
    >
    doctors = allDoctors;

    // Filter by specialty
    if (_selectedFilter !=
        "All") {
      doctors = doctors
          .where(
            (
              doctor,
            ) =>
                doctor.specialty ==
                _selectedFilter,
          )
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      doctors = doctors.where(
        (
          doctor,
        ) {
          final name = doctor.name.toLowerCase();
          final specialty = doctor.specialty.toLowerCase();
          final query = _searchQuery.toLowerCase();
          return name.contains(
                query,
              ) ||
              specialty.contains(
                query,
              );
        },
      ).toList();
    }

    return doctors;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "Find a Doctor",
      ),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildFilterChips(),
                ],
              ),
            ),
          ),
          if (_filteredDoctors.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 48.0,
                  ),
                  child: Text(
                    "No doctors found.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (
                  context,
                  index,
                ) {
                  final doctor = _filteredDoctors[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: DoctorResultCard(
                      doctor: doctor,
                    ),
                  );
                },
                childCount: _filteredDoctors.length,
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
        hintText: "Search by name, specialty...",
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      "All",
      "Cardiologist",
      "Dermatologist",
      "Pediatrician",
      "Neurologist",
    ];
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters
            .map(
              (
                filter,
              ) => _buildChip(
                filter,
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
              if (selected) {
                setState(
                  () => _selectedFilter = label,
                );
              }
            },
        backgroundColor: Colors.white,
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
          fontWeight: FontWeight.w600,
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
  }
}

class DoctorResultCard
    extends
        StatelessWidget {
  final DoctorData doctor;

  const DoctorResultCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (
                    context,
                  ) => DoctorProfileScreen(
                    doctor: doctor,
                  ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(
          12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage(
                      doctor.imagePath,
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
                          doctor.name,
                          style: GoogleFonts.lato(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          doctor.specialty,
                          style: GoogleFonts.lato(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              doctor.rating.toString(),
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: doctor.isAvailable
                            ? Colors.green
                            : Colors.grey,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        doctor.isAvailable
                            ? "Available Today"
                            : "Unavailable",
                        style: GoogleFonts.lato(
                          color: doctor.isAvailable
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (
                                context,
                              ) => DoctorProfileScreen(
                                doctor: doctor,
                              ),
                        ),
                      );
                    },
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
                      "Book Now",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
