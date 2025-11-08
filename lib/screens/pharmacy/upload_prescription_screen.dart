// lib/screens/pharmacy/upload_prescription_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadPrescriptionScreen
    extends
        StatelessWidget {
  const UploadPrescriptionScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Prescription",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
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
            Text(
              "Upload a photo of your paper prescription. Please ensure the image is clear and all details are readable.",
              style: GoogleFonts.lato(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // Placeholder for the image upload
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  12,
                ),
                border: Border.all(
                  color: Colors.grey[400]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                  ),
                  label: const Text(
                    "Add Photo",
                  ),
                  onPressed: () {
                    // In a real app, you would use a package like image_picker
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Opening camera...",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: "Add any notes for the pharmacist (optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              const SnackBar(
                content: Text(
                  "Prescription submitted for review.",
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(
              context,
            ).pop();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(
              double.infinity,
              50,
            ),
            backgroundColor: Theme.of(
              context,
            ).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            "Submit for Review",
          ),
        ),
      ),
    );
  }
}
