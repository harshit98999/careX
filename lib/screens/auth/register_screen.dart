// lib/screens/auth/register_screen.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import 'otp_verification_screen.dart';

class RegisterScreen
    extends
        StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<
    RegisterScreen
  >
  createState() => _RegisterScreenState();
}

class _RegisterScreenState
    extends
        State<
          RegisterScreen
        >
    with
        SingleTickerProviderStateMixin {
  final _formKey =
      GlobalKey<
        FormState
      >();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'CLIENT'; // --- ADDED: Default role is CLIENT

  late AnimationController _controller;
  late Animation<
    double
  >
  _fadeAnimation;
  late Animation<
    Offset
  >
  _slideAnimationHeader;
  late Animation<
    Offset
  >
  _slideAnimationForm;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 1500,
      ),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _slideAnimationHeader =
        Tween<
              Offset
            >(
              begin: const Offset(
                0,
                0.8,
              ),
              end: Offset.zero,
            )
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: const Interval(
                  0.0,
                  0.6,
                  curve: Curves.easeInOutCubic,
                ),
              ),
            );
    _slideAnimationForm =
        Tween<
              Offset
            >(
              begin: const Offset(
                0,
                0.8,
              ),
              end: Offset.zero,
            )
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: const Interval(
                  0.2,
                  0.8,
                  curve: Curves.easeInOutCubic,
                ),
              ),
            );
    _controller.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<
    void
  >
  _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(
        () => _isLoading = true,
      );
      final apiService = ApiService();

      try {
        // --- MODIFIED: Pass the selected role to the API service ---
        await apiService.register(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _selectedRole,
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (
                    context,
                  ) => OtpVerificationScreen(
                    email: _emailController.text,
                    verificationType: VerificationType.registration,
                  ),
            ),
          );
        }
      } on DioException catch (
        e
      ) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                ApiService.getErrorMessage(
                  e,
                ),
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
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationHeader,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Join us by filling out the form below.',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationForm,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // --- ADDED: Role Selector UI ---
                      _buildRoleSelector(),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildTextFormField(
                        controller: _firstNameController,
                        labelText: 'First Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildTextFormField(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildTextFormField(
                        controller: _emailController,
                        labelText: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (
                              value,
                            ) {
                              if (value ==
                                      null ||
                                  value.trim().isEmpty) {
                                return 'Please enter your email address.';
                              }
                              if (!RegExp(
                                r'\S+@\S+\.\S+',
                              ).hasMatch(
                                value,
                              )) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildTextFormField(
                        controller: _passwordController,
                        labelText: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator:
                            (
                              value,
                            ) {
                              if (value ==
                                      null ||
                                  value.isEmpty) {
                                return 'Please enter a password.';
                              }
                              if (value.length <
                                  8) {
                                return 'Password must be at least 8 characters long.';
                              }
                              return null;
                            },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildTextFormField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator:
                            (
                              value,
                            ) {
                              if (value ==
                                      null ||
                                  value.isEmpty) {
                                return 'Please confirm your password.';
                              }
                              if (value !=
                                  _passwordController.text) {
                                return 'Passwords do not match.';
                              }
                              return null;
                            },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF6A49E2,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(
                              0.3,
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
                                  'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.lato(
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(
                              context,
                            ).pop(),
                            child: Text(
                              'Log In',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ADDED: Helper widget for the role selector ---
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I am a...",
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: _buildRoleOption(
                label: 'Client',
                icon: Icons.person_search_outlined,
                value: 'CLIENT',
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: _buildRoleOption(
                label: 'Doctor',
                icon: Icons.medical_services_outlined,
                value: 'DOCTOR',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- ADDED: Helper widget for individual role option card ---
  Widget _buildRoleOption({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final bool isSelected =
        _selectedRole ==
        value;
    final Color color = isSelected
        ? Theme.of(
            context,
          ).primaryColor
        : Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(
          () {
            _selectedRole = value;
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(
                  0.1,
                )
              : Colors.grey.withOpacity(
                  0.1,
                ),
          borderRadius: BorderRadius.circular(
            12,
          ),
          border: Border.all(
            color: isSelected
                ? color
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(
      String?,
    )?
    validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.lato(
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.lato(
          color: Colors.grey[600],
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(
          0.1,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).primaryColor,
            width: 2,
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
                value.trim().isEmpty) {
              return 'This field cannot be empty.';
            }
            return null;
          },
    );
  }
}
