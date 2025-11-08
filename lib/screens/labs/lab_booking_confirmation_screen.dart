// lib/screens/labs/lab_booking_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lab_test_data.dart';

class LabBookingConfirmationScreen extends StatefulWidget {
  final LabTestData labTest;

  const LabBookingConfirmationScreen({super.key, required this.labTest});

  @override
  State<LabBookingConfirmationScreen> createState() => _LabBookingConfirmationScreenState();
}

class _LabBookingConfirmationScreenState extends State<LabBookingConfirmationScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final List<String> _timeSlots = ["8:00 AM", "9:30 AM", "11:00 AM", "2:00 PM", "4:30 PM"];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null; // Reset time selection when date changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Booking", style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTestSummaryCard(),
            const SizedBox(height: 24),
            _buildSectionHeader("Select Date"),
            const SizedBox(height: 12),
            _buildDateSelector(),
            const SizedBox(height: 24),
            _buildSectionHeader("Select Time Slot"),
            const SizedBox(height: 12),
            _buildTimeGrid(),
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildTestSummaryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.labTest.name, style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.labTest.description, style: GoogleFonts.lato(color: Colors.black54, height: 1.4)),
            const Divider(height: 24),
            Text("Preparation: ${widget.labTest.preparation}", style: GoogleFonts.lato(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) => Text(title, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold));
  
  Widget _buildDateSelector() {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.calendar_today_outlined, color: Theme.of(context).primaryColor),
        title: Text("${_selectedDate.toLocal()}".split(' ')[0], style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16)),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: _selectDate,
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final time = _timeSlots[index];
        final isSelected = _selectedTime == time;
        return GestureDetector(
          onTap: () => setState(() => _selectedTime = time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!),
            ),
            child: Center(child: Text(time, style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87))),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    final bool isEnabled = _selectedTime != null;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle_outline),
        label: const Text("Confirm Booking"),
        onPressed: isEnabled
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.labTest.name} booked for $_selectedTime!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey[300],
        ),
      ),
    );
  }
}