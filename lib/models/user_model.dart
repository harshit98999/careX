// lib/models/user_model.dart

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? profilePicture;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.dateOfBirth,
    this.phoneNumber,
    this.profilePicture,
  });

  // A computed property to get the full name
  String get fullName => '$firstName $lastName';

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(
    Map<
      String,
      dynamic
    >
    json,
  ) {
    return User(
      email:
          json['email'] ??
          '',
      firstName:
          json['first_name'] ??
          '',
      lastName:
          json['last_name'] ??
          '',
      bio: json['bio'],
      dateOfBirth: json['date_of_birth'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
    );
  }
}
