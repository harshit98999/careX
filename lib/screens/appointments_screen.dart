// lib/screens/appointments_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your custom AppBar, AppDrawer, and the AppointmentData model
import './core/custom_app_bar.dart';
import './core/app_drawer.dart';
import '../models/appointment_data.dart';

// --- CORE FIX ---
// Import the correct AppointmentDetailCard from its dedicated file.
import './appointments/components/appointment_detail_card.dart';

class AppointmentsScreen
    extends
        StatefulWidget {
  const AppointmentsScreen({
    super.key,
  });

  @override
  State<
    AppointmentsScreen
  >
  createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState
    extends
        State<
          AppointmentsScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;
  int _selectedTabIndex = 0;

  // Data is well-managed using your AppointmentData model.
  final List<
    AppointmentData
  >
  _upcomingAppointments = [
    const AppointmentData(
      doctorName: "Dr. Evelyn Reed",
      specialty: "Cardiologist",
      date: "Nov 10, 2025",
      time: "9:00 AM",
      location: "CardioCare Clinic, Suite 201",
      imagePath: 'assets/images/doctor_1.jpg',
      isUpcoming: true,
    ),
    const AppointmentData(
      doctorName: "Dr. Marcus Chen",
      specialty: "Dermatologist",
      date: "Nov 12, 2025",
      time: "2:30 PM",
      location: "SkinHealth Center",
      imagePath: 'assets/images/doctor_2.jpg',
      isUpcoming: true,
    ),
  ];

  final List<
    AppointmentData
  >
  _completedAppointments = [
    const AppointmentData(
      doctorName: "Dr. Lena Petrova",
      specialty: "Pediatrician",
      date: "Oct 22, 2025",
      time: "11:00 AM",
      location: "General Hospital",
      imagePath: 'assets/images/doctor_3.jpg',
      isUpcoming: false,
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "My Appointments",
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
              _buildTabs(),
              const SizedBox(
                height: 24,
              ),
              // Display the list of appointments based on the selected tab.
              _selectedTabIndex ==
                      0
                  ? _buildAppointmentsList(
                      _upcomingAppointments,
                    )
                  : _buildAppointmentsList(
                      _completedAppointments,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(
        4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              0,
              "Upcoming",
            ),
          ),
          Expanded(
            child: _buildTabItem(
              1,
              "Completed",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    int index,
    String title,
  ) {
    final bool isSelected =
        _selectedTabIndex ==
        index;
    return GestureDetector(
      onTap: () {
        setState(
          () {
            _selectedTabIndex = index;
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(
                  context,
                ).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : Colors.black54,
          ),
        ),
      ),
    );
  }

  // This method now correctly uses the imported AppointmentDetailCard.
  Widget _buildAppointmentsList(
    List<
      AppointmentData
    >
    appointments,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder:
          (
            context,
            index,
          ) {
            final appointment = appointments[index];
            // --- CORE FIX ---
            // Pass the entire 'appointment' object to the 'appointmentData' parameter.
            // This ensures the card has all the data it needs for navigation and dialogs.
            return AppointmentDetailCard(
              appointmentData: appointment,
              location: appointment.location,
              isUpcoming: appointment.isUpcoming,
            );
          },
    );
  }
}

// --- CORE FIX ---
// The old, duplicate AppointmentDetailCard widget that was here has been REMOVED.
// This is critical because it was causing the conflict.
