// lib/shared/dialogs/leave_review_dialog.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveReviewDialog
    extends
        StatefulWidget {
  const LeaveReviewDialog({
    super.key,
  });

  @override
  State<
    LeaveReviewDialog
  >
  createState() => _LeaveReviewDialogState();
}

class _LeaveReviewDialogState
    extends
        State<
          LeaveReviewDialog
        > {
  int _rating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      title: Text(
        "Leave a Review",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How was your experience?",
              style: GoogleFonts.lato(),
            ),
            const SizedBox(
              height: 12,
            ),
            // --- FIX: Using a Row again, but with compact IconButtons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Keep stars centered
              children: List.generate(
                5,
                (
                  index,
                ) {
                  return IconButton(
                    // 1. Remove default padding
                    padding: EdgeInsets.zero,
                    // 2. Remove the default 48x48 minimum tap area constraint
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(
                        () {
                          _rating =
                              index +
                              1;
                        },
                      );
                    },
                    icon: Icon(
                      index <
                              _rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
            // -----------------------------------------------------------
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Additional comments...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(),
          child: const Text(
            "Cancel",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle review submission
            Navigator.of(
              context,
            ).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              const SnackBar(
                content: Text(
                  "Thank you for your feedback!",
                ),
                backgroundColor: Colors.green,
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
                10,
              ),
            ),
          ),
          child: const Text(
            "Submit",
          ),
        ),
      ],
    );
  }
}
