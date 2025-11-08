// lib/screens/reschedule_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A mock class to hold appointment data. In a real app, this would be a proper model.
class AppointmentData {
  final String doctorName;
  final String specialty;
  final String imagePath;
  final String date;
  final String time;

  const AppointmentData({
    required this.doctorName,
    required this.specialty,
    required this.imagePath,
    required this.date,
    required this.time,
  });
}

class RescheduleScreen
    extends
        StatefulWidget {
  final AppointmentData appointment;

  const RescheduleScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<
    RescheduleScreen
  >
  createState() => _RescheduleScreenState();
}

class _RescheduleScreenState
    extends
        State<
          RescheduleScreen
        > {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  // Mock time slots. In a real app, this would be fetched from a server.
  final List<
    String
  >
  _timeSlots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "11:30 AM",
    "2:00 PM",
    "3:30 PM",
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(
      const Duration(
        days: 1,
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(
          days: 90,
        ),
      ),
    );
    if (picked !=
            null &&
        picked !=
            _selectedDate) {
      setState(
        () {
          _selectedDate = picked;
          _selectedTime = null; // Reset time when date changes
        },
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reschedule",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorInfo(),
            const SizedBox(
              height: 24,
            ),
            _buildSectionHeader(
              "Select New Date",
            ),
            const SizedBox(
              height: 12,
            ),
            _buildDateSelector(),
            const SizedBox(
              height: 24,
            ),
            _buildSectionHeader(
              "Select New Time",
            ),
            const SizedBox(
              height: 12,
            ),
            _buildTimeGrid(),
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildDoctorInfo() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                widget.appointment.imagePath,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appointment.doctorName,
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.appointment.specialty,
                  style: GoogleFonts.lato(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.calendar_today_outlined,
          color: Theme.of(
            context,
          ).primaryColor,
        ),
        title: Text(
          "${_selectedDate.toLocal()}".split(
            ' ',
          )[0], // Format to YYYY-MM-DD
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_drop_down,
        ),
        onTap: _selectDate,
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: _timeSlots.length,
      itemBuilder:
          (
            context,
            index,
          ) {
            final time = _timeSlots[index];
            final isSelected =
                _selectedTime ==
                time;
            return GestureDetector(
              onTap: () {
                setState(
                  () {
                    _selectedTime = time;
                  },
                );
              },
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).primaryColor
                        : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }

  Widget _buildConfirmButton() {
    // Disable the button if a time isn't selected
    final bool isEnabled =
        _selectedTime !=
        null;

    return Padding(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Appointment rescheduled for $_selectedTime on ${_selectedDate.toLocal().toString().split(' ')[0]}",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(
                  context,
                ).pop();
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          backgroundColor: Theme.of(
            context,
          ).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: const Text(
          "Confirm Reschedule",
        ),
      ),
    );
  }
}
