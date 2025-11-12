// lib/models/user_model.dart

import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String role; // <-- This is the critical field
  final String? bio;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? profilePicture;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.bio,
    this.dateOfBirth,
    this.phoneNumber,
    this.profilePicture,
  });

  // A computed property to get the full name
  String get fullName => '$firstName $lastName';

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    // --- DEBUGGING STEP 1 ---
    // This prints the raw JSON that this parser is receiving.
    // Compare this with the output from ApiService. They should match.
    debugPrint("User.fromJson: Parsing the following JSON: $json");

    // --- PARSING LOGIC ---
    // This is our robust attempt to find the 'role'.
    // It checks the top-level of the JSON for a 'role' key.
    // If your server sends the role nested inside another object (e.g., json['user']['role']),
    // you will need to adjust this line based on the debug output.
    final String parsedRole =
        json['role'] ?? 'CLIENT'; // Default to 'CLIENT' if 'role' is not found

    // --- DEBUGGING STEP 2 ---
    // This confirms what role was actually extracted from the JSON.
    // If this says 'CLIENT' when you logged in as a 'DOCTOR', it means the line above
    // could not find the 'role' key in the JSON structure.
    debugPrint("User.fromJson: Successfully parsed the role as: '$parsedRole'");

    // --- DATA MAPPING ---
    // This part maps the rest of the JSON data to the User object fields.
    return User(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: parsedRole, // Use the role we just parsed
      bio: json['bio'],
      dateOfBirth: json['date_of_birth'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
    );
  }
}
