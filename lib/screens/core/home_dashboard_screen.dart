// lib/screens/core/home_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your custom AppBar and the AppDrawer
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
  // Controller to detect scroll position.
  late final ScrollController _scrollController;
  // State to track if the user has scrolled.
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Add a listener to the scroll controller.
    _scrollController.addListener(
      _onScroll,
    );
  }

  // Listener function to update the _isScrolled state.
  void _onScroll() {
    // We set the state only if the scroll position changes the condition.
    // A threshold of 10 pixels is used to trigger the change.
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
    // Always dispose of controllers to prevent memory leaks.
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
      // Use the custom AppBar, passing the scroll state.
      // When _isScrolled is false: white background, purple text.
      // When _isScrolled is true: purple background, white text.
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
      ),

      // The drawer is still available and will be opened by the CustomAppBar.
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        // Attach the scroll controller to the scrollable view.
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(
                height: 24,
              ),
              _buildSectionHeader(
                "Categories",
              ),
              const SizedBox(
                height: 16,
              ),
              _buildCategoryGrid(),
              const SizedBox(
                height: 24,
              ),
              _buildSectionHeader(
                "Upcoming Appointment",
              ),
              const SizedBox(
                height: 16,
              ),
              const AppointmentCard(),
              const SizedBox(
                height: 24,
              ),
              _buildSectionHeader(
                "Health Metrics",
              ),
              const SizedBox(
                height: 16,
              ),
              const HealthMetricsGrid(),
              const SizedBox(
                height: 24,
              ),
              _buildSectionHeader(
                "Recent Activity",
              ),
              const SizedBox(
                height: 16,
              ),
              const RecentActivityCard(
                icon: Icons.science_outlined,
                title: "Lab Result Update",
                subtitle: "Your blood test results are in.",
                time: "1h ago",
              ),
              const RecentActivityCard(
                icon: Icons.receipt_long_outlined,
                title: "New Prescription",
                subtitle: "Dr. Reed has prescribed a new medication.",
                time: "3h ago",
              ),
              const SizedBox(
                height: 24,
              ),
              _buildSectionHeader(
                "Medication Reminders",
              ),
              const SizedBox(
                height: 16,
              ),
              const MedicationReminderCard(
                medication: "Metformin",
                dosage: "500mg",
                time: "8:00 AM",
              ),
              const SizedBox(
                height: 24,
              ),
              _buildSectionHeader(
                "Top Doctors",
              ),
              const SizedBox(
                height: 16,
              ),
              const DoctorCard(
                name: "Dr. Evelyn Reed",
                specialty: "Cardiologist",
                rating: 4.9,
                imagePath: 'assets/images/doctor_1.jpg',
              ),
              const DoctorCard(
                name: "Dr. Marcus Chen",
                specialty: "Dermatologist",
                rating: 4.8,
                imagePath: 'assets/images/doctor_2.jpg',
              ),
              const DoctorCard(
                name: "Dr. Lena Petrova",
                specialty: "Pediatrician",
                rating: 4.9,
                imagePath: 'assets/images/doctor_3.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
  ) {
    return Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for doctors, labs...",
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

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      children: const [
        CategoryCard(
          icon: Icons.medical_services_outlined,
          label: "Doctors",
        ),
        CategoryCard(
          icon: Icons.local_hospital_outlined,
          label: "Hospitals",
        ),
        CategoryCard(
          icon: Icons.local_pharmacy_outlined,
          label: "Pharmacy",
        ),
        CategoryCard(
          icon: Icons.science_outlined,
          label: "Labs",
        ),
      ],
    );
  }
}

// All other card widgets (CategoryCard, AppointmentCard, etc.)
// remain unchanged as provided in the initial code.
// --- PASTE THE REST OF THE WIDGETS HERE ---
class CategoryCard
    extends
        StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.1,
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
    );
  }
}

class AppointmentCard
    extends
        StatelessWidget {
  const AppointmentCard({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
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
    );
  }
}

class DoctorCard
    extends
        StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String imagePath;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imagePath,
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
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.08,
            ),
            spreadRadius: 1,
            blurRadius: 10,
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
                    color: Colors.grey[600],
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
      childAspectRatio: 0.7,
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
  final String label;
  final String value;
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
  final String title;
  final String subtitle;
  final String time;

  const RecentActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.08,
            ),
            spreadRadius: 1,
            blurRadius: 10,
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
                    color: Colors.grey[600],
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
    );
  }
}

class MedicationReminderCard
    extends
        StatelessWidget {
  final String medication;
  final String dosage;
  final String time;

  const MedicationReminderCard({
    super.key,
    required this.medication,
    required this.dosage,
    required this.time,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
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
    );
  }
}
