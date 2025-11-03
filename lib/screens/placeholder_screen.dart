import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// This is a reusable screen to show that navigation is working.
// You can replace this with your actual screens later.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[50],
      ),
      body: Center(
        child: Text(
          '$title Screen',
          style: GoogleFonts.lato(fontSize: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
