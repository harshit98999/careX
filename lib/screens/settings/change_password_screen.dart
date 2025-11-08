// lib/screens/settings/change_password_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen
    extends
        StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<
    ChangePasswordScreen
  >
  createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends
        State<
          ChangePasswordScreen
        > {
  final _formKey =
      GlobalKey<
        FormState
      >();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                controller: _currentPasswordController,
                labelText: "Current Password",
              ),
              const SizedBox(
                height: 16,
              ),
              _buildPasswordField(
                controller: _newPasswordController,
                labelText: "New Password",
              ),
              const SizedBox(
                height: 16,
              ),
              _buildPasswordField(
                controller: _confirmPasswordController,
                labelText: "Confirm New Password",
                validator:
                    (
                      value,
                    ) {
                      if (value !=
                          _newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle password change logic here
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Password updated successfully!",
                          ),
                        ),
                      );
                      Navigator.pop(
                        context,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: Text(
                    "Update Password",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    String? Function(
      String?,
    )?
    validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
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
      validator:
          validator ??
          (
            value,
          ) {
            if (value ==
                    null ||
                value.isEmpty) {
              return "This field cannot be empty";
            }
            if (value.length <
                8) {
              return "Password must be at least 8 characters long";
            }
            return null;
          },
    );
  }
}
