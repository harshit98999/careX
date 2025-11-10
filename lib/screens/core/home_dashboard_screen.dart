// lib/screens/core/home_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import './custom_app_bar.dart';
import './app_drawer.dart';

class HomeDashboardScreen
    extends
        StatefulWidget {
  const HomeDashboardScreen({
    super.key,
  });
  @override
  State<
    HomeDashboardScreen
  >
  createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState
    extends
        State<
          HomeDashboardScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

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

  void _showLabsOptionsDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder:
          (
            BuildContext dialogContext,
          ) {
            return AlertDialog(
              title: const Text(
                "Lab Services",
              ),
              content: const Text(
                "What would you like to do?",
              ),
              actions:
                  <
                    Widget
                  >[
                    TextButton(
                      child: const Text(
                        "View Results",
                      ),
                      onPressed: () {
                        Navigator.of(
                          dialogContext,
                        ).pop();
                        Navigator.pushNamed(
                          context,
                          '/lab-results',
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text(
                        "Book a Test",
                      ),
                      onPressed: () {
                        Navigator.of(
                          dialogContext,
                        ).pop();
                        Navigator.pushNamed(
                          context,
                          '/book_lab_test',
                        );
                      },
                    ),
                  ],
            );
          },
    );
  }

  Future<
    bool
  >
  _onWillPop() async {
    final shouldPop =
        await showDialog<
          bool
        >(
          context: context,
          builder:
              (
                context,
              ) {
                return AlertDialog(
                  title: const Text(
                    'Exit Application',
                  ),
                  content: const Text(
                    'Are you sure you want to close the app?',
                  ),
                  actions:
                      <
                        Widget
                      >[
                        TextButton(
                          child: const Text(
                            'No',
                          ),
                          onPressed: () =>
                              Navigator.of(
                                context,
                              ).pop(
                                false,
                              ),
                        ),
                        TextButton(
                          child: const Text(
                            'Yes',
                          ),
                          onPressed: () =>
                              Navigator.of(
                                context,
                              ).pop(
                                true,
                              ),
                        ),
                      ],
                );
              },
        );
    return shouldPop ??
        false;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userName =
        Provider.of<
              UserProvider
            >(
              context,
            )
            .user
            ?.fullName ??
        'User';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          isScrolled: _isScrolled,
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic welcome header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    24,
                  ),
                  child: Text(
                    'Hello, $userName!',
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSearchBar(),
                ),
                const SizedBox(
                  height: 24,
                ),

                // Categories
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSectionHeader(
                    "Categories",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildCategoryGrid(),
                ),
                const SizedBox(
                  height: 24,
                ),

                // Upcoming Appointment
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSectionHeader(
                    "Upcoming Appointment",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: AppointmentCard(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/appointments',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),

                // Health Metrics
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSectionHeader(
                    "Health Metrics",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: HealthMetricsGrid(),
                ),
                const SizedBox(
                  height: 24,
                ),

                // Recent Activity
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSectionHeader(
                    "Recent Activity",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      RecentActivityCard(
                        icon: Icons.science_outlined,
                        title: "Lab Result Update",
                        subtitle: "Your blood test results are in.",
                        time: "1h ago",
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/lab-results',
                        ),
                      ),
                      RecentActivityCard(
                        icon: Icons.receipt_long_outlined,
                        title: "New Prescription",
                        subtitle: "Dr. Reed has prescribed a new medication.",
                        time: "3h ago",
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/prescriptions',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),

                // Medication Reminders
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSectionHeader(
                    "Medication Reminders",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: MedicationReminderCard(
                    medication: "Metformin",
                    dosage: "500mg",
                    time: "8:00 AM",
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/prescriptions',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),

                // Top Doctors
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: _buildSectionHeader(
                    "Top Doctors",
                    showViewAll: true,
                    onViewAllTap: () => Navigator.pushNamed(
                      context,
                      '/find_a_doctor',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      DoctorCard(
                        name: "Dr. Evelyn Reed",
                        specialty: "Cardiologist",
                        rating: 4.9,
                        imagePath: 'assets/images/doctor_1.jpg',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/find_a_doctor',
                        ),
                      ),
                      DoctorCard(
                        name: "Dr. Marcus Chen",
                        specialty: "Dermatologist",
                        rating: 4.8,
                        imagePath: 'assets/images/doctor_2.jpg',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/find_a_doctor',
                        ),
                      ),
                      DoctorCard(
                        name: "Dr. Lena Petrova",
                        specialty: "Pediatrician",
                        rating: 4.9,
                        imagePath: 'assets/images/doctor_3.jpg',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/find_a_doctor',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---
  Widget _buildSectionHeader(
    String title, {
    bool showViewAll = false,
    VoidCallback? onViewAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(
                      context,
                    ).brightness ==
                    Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        if (showViewAll)
          TextButton(
            onPressed: onViewAllTap,
            child: const Text(
              "View All",
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onTap: () => Navigator.pushNamed(
        context,
        '/find_a_doctor',
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Search for doctors, labs...",
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        filled: true,
        fillColor:
            Theme.of(
                  context,
                ).brightness ==
                Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: [
        CategoryCard(
          icon: Icons.medical_services_outlined,
          label: "Doctors",
          onTap: () => Navigator.pushNamed(
            context,
            '/find_a_doctor',
          ),
        ),
        CategoryCard(
          icon: Icons.local_hospital_outlined,
          label: "Hospitals",
          onTap: () => Navigator.pushNamed(
            context,
            '/hospitals',
          ),
        ),
        CategoryCard(
          icon: Icons.local_pharmacy_outlined,
          label: "Pharmacy",
          onTap: () => Navigator.pushNamed(
            context,
            '/pharmacy',
          ),
        ),
        CategoryCard(
          icon: Icons.science_outlined,
          label: "Labs",
          onTap: () => _showLabsOptionsDialog(
            context,
          ),
        ),
      ],
    );
  }
}

// --- ALL OTHER WIDGETS ---
class CategoryCard
    extends
        StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    bool isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        12,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(
            12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark
                    ? 0.1
                    : 0.05,
              ),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(
                context,
              ).primaryColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard
    extends
        StatelessWidget {
  final VoidCallback onTap;
  const AppointmentCard({
    super.key,
    required this.onTap,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        16,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).primaryColor,
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(
                'assets/images/doctor_2.jpg',
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
                    "Dr. Marcus Chen",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Dermatologist",
                    style: GoogleFonts.lato(
                      color: Colors.white.withOpacity(
                        0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Text(
                "10:30 AM",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard
    extends
        StatelessWidget {
  final String name, specialty, imagePath;
  final double rating;
  final VoidCallback onTap;
  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imagePath,
    required this.onTap,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    bool isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        12,
      ),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        padding: const EdgeInsets.all(
          12,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(
            12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark
                    ? 0.1
                    : 0.05,
              ),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                imagePath,
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
                    name,
                    style: GoogleFonts.lato(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    specialty,
                    style: GoogleFonts.lato(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
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
                  rating.toString(),
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

class HealthMetricsGrid
    extends
        StatelessWidget {
  const HealthMetricsGrid({
    super.key,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      childAspectRatio: 0.75,
      children: const [
        HealthMetricCard(
          icon: Icons.favorite_border,
          label: "Heart Rate",
          value: "78 bpm",
          color: Colors.red,
        ),
        HealthMetricCard(
          icon: Icons.bloodtype_outlined,
          label: "Blood Pressure",
          value: "120/80",
          color: Colors.blue,
        ),
        HealthMetricCard(
          icon: Icons.water_drop_outlined,
          label: "Blood Sugar",
          value: "98 mg/dL",
          color: Colors.green,
        ),
      ],
    );
  }
}

class HealthMetricCard
    extends
        StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const HealthMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(
          0.1,
        ),
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RecentActivityCard
    extends
        StatelessWidget {
  final IconData icon;
  final String title, subtitle, time;
  final VoidCallback onTap;
  const RecentActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    bool isDark =
        Theme.of(
          context,
        ).brightness ==
        Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        12,
      ),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.all(
          12,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(
            12,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isDark
                    ? 0.1
                    : 0.05,
              ),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Theme.of(
                    context,
                  ).primaryColor.withOpacity(
                    0.1,
                  ),
              child: Icon(
                icon,
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
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: GoogleFonts.lato(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationReminderCard
    extends
        StatelessWidget {
  final String medication, dosage, time;
  final VoidCallback onTap;
  const MedicationReminderCard({
    super.key,
    required this.medication,
    required this.dosage,
    required this.time,
    required this.onTap,
  });
  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        16,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(
            0.1,
          ),
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.medication_outlined,
              size: 32,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Dosage: $dosage",
                    style: GoogleFonts.lato(
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Text(
                time,
                style: GoogleFonts.lato(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
