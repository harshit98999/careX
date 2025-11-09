// lib/screens/auth/otp_verification_screen.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import provider
import '../../providers/user_provider.dart'; // Import UserProvider
import '../../services/api_service.dart';
import '../../services/secure_storage_service.dart';

enum VerificationType {
  registration,
  login,
}

class OtpVerificationScreen
    extends
        StatefulWidget {
  final String email;
  final VerificationType verificationType;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.verificationType,
  });

  @override
  State<
    OtpVerificationScreen
  >
  createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends
        State<
          OtpVerificationScreen
        >
    with
        SingleTickerProviderStateMixin {
  // ... (all state variables and animations remain the same)
  final _formKey =
      GlobalKey<
        FormState
      >();
  // FIX: Renamed to match usage in initState/dispose
  final List<
    TextEditingController
  >
  _otpControllers = List.generate(
    6,
    (
      _,
    ) => TextEditingController(),
  );
  final List<
    FocusNode
  >
  _focusNodes = List.generate(
    6,
    (
      _,
    ) => FocusNode(),
  );

  bool _isVerifying = false;
  bool _isResending = false;

  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();

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
  late Animation<
    Offset
  >
  _slideAnimationButton;
  late Animation<
    Offset
  >
  _slideAnimationFooter;
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
                  0.7,
                  curve: Curves.easeInOutCubic,
                ),
              ),
            );
    _slideAnimationButton =
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
                  0.3,
                  0.8,
                  curve: Curves.easeInOutCubic,
                ),
              ),
            );
    _slideAnimationFooter =
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
                  0.4,
                  0.9,
                  curve: Curves.easeInOutCubic,
                ),
              ),
            );

    // Set up listeners to auto-focus next field
    for (
      int i = 0;
      i <
          5;
      i++
    ) {
      // FIX: Using the corrected variable name _otpControllers and _focusNodes
      _otpControllers[i].addListener(
        () {
          if (_otpControllers[i].text.length ==
                  1 &&
              i <
                  5) {
            FocusScope.of(
              context,
            ).requestFocus(
              _focusNodes[i +
                  1],
            );
          }
        },
      );
    }
    _controller.forward();
  }

  @override
  void dispose() {
    // FIX: Using the corrected variable name _otpControllers and _focusNodes
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  // --- HEAVILY UPDATED METHOD ---
  Future<
    void
  >
  _verifyOtp() async {
    final isFormValid = _otpControllers.every(
      (
        c,
      ) => c.text.isNotEmpty,
    );
    if (!isFormValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all OTP fields.',
          ),
        ),
      );
      return;
    }

    setState(
      () => _isVerifying = true,
    );
    final otp = _otpControllers
        .map(
          (
            c,
          ) => c.text,
        )
        .join();

    try {
      if (widget.verificationType ==
          VerificationType.login) {
        // Step 1: Verify OTP and get tokens
        final response = await _apiService.verifyLoginOtp(
          email: widget.email,
          otp: otp,
        );
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];

        // Step 2: Save tokens
        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        // --- NEW: Step 3: Fetch and set user data using the provider ---
        if (mounted) {
          await Provider.of<
                UserProvider
              >(
                context,
                listen: false,
              )
              .fetchAndSetUser();
        }

        // Step 4: Navigate to dashboard
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(
            '/dashboard',
            (
              route,
            ) => false,
          );
        }
      } else {
        // Registration flow remains the same
        await _apiService.verifyRegistrationOtp(
          email: widget.email,
          otp: otp,
        );
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Account activated successfully! Please log in.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(
            '/login',
            (
              route,
            ) => false,
          );
        }
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
          () => _isVerifying = false,
        );
      }
    }
  }

  // ... (_resendOtp and build methods remain the same)
  Future<
    void
  >
  _resendOtp() async {
    setState(
      () => _isResending = true,
    );
    try {
      if (widget.verificationType ==
          VerificationType.login) {
        await _apiService.resendLoginOtp(
          email: widget.email,
        );
      } else {
        await _apiService.resendRegistrationOtp(
          email: widget.email,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'A new code has been sent to ${widget.email}',
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
          () => _isResending = false,
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // FIX: Reconstructed the full build method
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(
            context,
          ).pop(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationHeader,
                child: Column(
                  children: [
                    Text(
                      'Verify Code',
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Please enter the 6-digit code sent to your email at:\n${widget.email}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationForm,
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (
                        index,
                      ) => SizedBox(
                        width: 50,
                        height: 60,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).primaryColor,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
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
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationButton,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying
                        ? null
                        : _verifyOtp,
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
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            'Verify & Proceed',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationFooter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: GoogleFonts.lato(
                        color: Colors.grey[600],
                      ),
                    ),
                    _isResending
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: _resendOtp,
                            child: Text(
                              'Resend',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
