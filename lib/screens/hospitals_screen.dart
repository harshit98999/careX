// lib/screens/hospitals_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_drawer.dart';
import 'core/custom_app_bar.dart';
import '../models/hospital_data.dart';
import 'hospitals/hospital_details_screen.dart';

class HospitalsScreen
    extends
        StatefulWidget {
  const HospitalsScreen({
    super.key,
  });

  @override
  State<
    HospitalsScreen
  >
  createState() => _HospitalsScreenState();
}

class _HospitalsScreenState
    extends
        State<
          HospitalsScreen
        > {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "All";

  final List<
    HospitalData
  >
  allHospitals = [
    const HospitalData(
      name: "City General Hospital",
      address: "123 Main St, Metropolis",
      distance: 2.5,
      rating: 4.8,
      imagePath: 'assets/images/hospital_1.jpg',
      services: [
        "Emergency",
        "Cardiology",
        "Neurology",
      ],
      hours: {
        "Mon-Fri": "24 Hours",
        "Sat-Sun": "24 Hours",
      },
      phone: "555-1234",
      website: "citygeneral.com",
    ),
    const HospitalData(
      name: "Oak Valley Clinic",
      address: "456 Oak Ave, Suburbia",
      distance: 5.1,
      rating: 4.6,
      imagePath: 'assets/images/hospital_2.jpg',
      services: [
        "General Practice",
        "Pediatrics",
      ],
      hours: {
        "Mon-Fri": "9 AM - 6 PM",
        "Sat-Sun": "Closed",
      },
      phone: "555-5678",
      website: "oakvalleyclinic.com",
    ),
    const HospitalData(
      name: "St. Jude's Medical Center",
      address: "789 Pine Ln, Downtown",
      distance: 1.2,
      rating: 4.9,
      imagePath: 'assets/images/hospital_1.jpg',
      services: [
        "Oncology",
        "Radiology",
        "Emergency",
      ],
      hours: {
        "Mon-Fri": "24 Hours",
        "Sat-Sun": "24 Hours",
      },
      phone: "555-9012",
      website: "stjudes.com",
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
    HospitalData
  >
  get _filteredHospitals {
    List<
      HospitalData
    >
    hospitals = List.from(
      allHospitals,
    );

    if (_selectedFilter ==
        "Nearest") {
      hospitals.sort(
        (
          a,
          b,
        ) => a.distance.compareTo(
          b.distance,
        ),
      );
    } else if (_selectedFilter ==
        "Top Rated") {
      hospitals.sort(
        (
          a,
          b,
        ) => b.rating.compareTo(
          a.rating,
        ),
      );
    }

    if (_searchQuery.isNotEmpty) {
      hospitals = hospitals
          .where(
            (
              h,
            ) => h.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    return hospitals;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: const CustomAppBar(
        isScrolled: false,
        title: "Hospitals & Clinics",
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
            child: _filteredHospitals.isEmpty
                ? const Center(
                    child: Text(
                      "No hospitals found.",
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    itemCount: _filteredHospitals.length,
                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                          final hospital = _filteredHospitals[index];
                          return HospitalCard(
                            hospital: hospital,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (
                                        context,
                                      ) => HospitalDetailsScreen(
                                        hospital: hospital,
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
        hintText: "Search by hospital name...",
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
      "Nearest",
      "Top Rated",
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
                        // Added curly braces for good practice
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
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class HospitalCard
    extends
        StatelessWidget {
  final HospitalData hospital;
  final VoidCallback onTap;

  const HospitalCard({
    super.key,
    required this.hospital,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                child: Image.asset(
                  hospital.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
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
                      hospital.name,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      hospital.address,
                      style: GoogleFonts.lato(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${hospital.distance} km away",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              hospital.rating.toString(),
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
