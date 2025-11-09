// lib/screens/edit_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class EditProfileScreen
    extends
        StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<
    EditProfileScreen
  >
  createState() => _EditProfileScreenState();
}

class _EditProfileScreenState
    extends
        State<
          EditProfileScreen
        > {
  final _formKey =
      GlobalKey<
        FormState
      >();
  final ApiService _apiService = ApiService();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _dobController;

  DateTime? _selectedDate;
  File? _profileImageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.user.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.user.lastName,
    );
    _phoneController = TextEditingController(
      text: widget.user.phoneNumber,
    );
    _bioController = TextEditingController(
      text: widget.user.bio,
    );
    _dobController = TextEditingController(
      text: widget.user.dateOfBirth,
    );
    if (widget.user.dateOfBirth !=
        null) {
      _selectedDate = DateTime.tryParse(
        widget.user.dateOfBirth!,
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<
    void
  >
  _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile !=
        null) {
      setState(
        () {
          _profileImageFile = File(
            pickedFile.path,
          );
        },
      );
    }
  }

  Future<
    void
  >
  _selectDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now(),
      firstDate: DateTime(
        1900,
      ),
      lastDate: DateTime.now(),
    );
    if (picked !=
            null &&
        picked !=
            _selectedDate) {
      setState(
        () {
          _selectedDate = picked;
          _dobController.text = picked
              .toIso8601String()
              .split(
                'T',
              )
              .first;
        },
      );
    }
  }

  Future<
    void
  >
  _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(
      () => _isLoading = true,
    );

    try {
      // Call the API service to update the profile
      await _apiService.updateUserProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneController.text,
        bio: _bioController.text,
        dateOfBirth: _dobController.text,
        imagePath: _profileImageFile?.path,
      );

      // Refresh the user data globally using the provider
      if (mounted) {
        await Provider.of<
              UserProvider
            >(
              context,
              listen: false,
            )
            .fetchAndSetUser();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile updated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(
          context,
        ).pop();
      }
    } catch (
      e
    ) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile: $e',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(
          () => _isLoading = false,
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          24.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatar(),
              const SizedBox(
                height: 32,
              ),
              _buildTextField(
                _firstNameController,
                "First Name",
              ),
              const SizedBox(
                height: 16,
              ),
              _buildTextField(
                _lastNameController,
                "Last Name",
              ),
              const SizedBox(
                height: 16,
              ),
              _buildTextField(
                _phoneController,
                "Phone Number",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 16,
              ),
              _buildDateField(),
              const SizedBox(
                height: 16,
              ),
              _buildTextField(
                _bioController,
                "Bio (optional)",
                maxLines: 3,
              ),
              const SizedBox(
                height: 40,
              ),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    ImageProvider imageProvider;
    if (_profileImageFile !=
        null) {
      imageProvider = FileImage(
        _profileImageFile!,
      );
    } else if (widget.user.profilePicture !=
            null &&
        widget.user.profilePicture!.isNotEmpty) {
      imageProvider = NetworkImage(
        widget.user.profilePicture!,
      );
    } else {
      imageProvider = const AssetImage(
        'assets/images/default_avatar.png',
      );
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: imageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
      validator:
          (
            value,
          ) {
            if (label.contains(
              "optional",
            )) {
              return null;
            }
            if (value ==
                    null ||
                value.isEmpty) {
              return 'Please enter your $label';
            }
            return null;
          },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: "Date of Birth",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        suffixIcon: const Icon(
          Icons.calendar_today,
        ),
      ),
      readOnly: true,
      onTap: () => _selectDate(
        context,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(
            context,
          ).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                'Save Changes',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
