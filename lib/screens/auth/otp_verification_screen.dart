// lib/screens/otp_verification_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Add SingleTickerProviderStateMixin for animations
class OtpVerificationScreen
    extends
        StatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
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
  final _formKey =
      GlobalKey<
        FormState
      >();
  final List<
    TextEditingController
  >
  _otpControllers = List.generate(
    6,
    (
      index,
    ) => TextEditingController(),
  );
  final List<
    FocusNode
  >
  _focusNodes = List.generate(
    6,
    (
      index,
    ) => FocusNode(),
  );

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

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 1500,
      ),
      vsync: this,
    );

    // General fade animation
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Staggered slide animations
    _slideAnimationHeader = _createSlideAnimation(
      begin: 0.0,
      end: 0.6,
    );
    _slideAnimationForm = _createSlideAnimation(
      begin: 0.2,
      end: 0.7,
    );
    _slideAnimationButton = _createSlideAnimation(
      begin: 0.3,
      end: 0.8,
    );
    _slideAnimationFooter = _createSlideAnimation(
      begin: 0.4,
      end: 0.9,
    );

    // Logic to auto-focus the next OTP box
    for (
      int i = 0;
      i <
          5;
      i++
    ) {
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

    // Start the animations
    _controller.forward();
  }

  // Helper for creating slide animations
  Animation<
    Offset
  >
  _createSlideAnimation({
    required double begin,
    required double end,
  }) {
    return Tween<
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
            curve: Interval(
              begin,
              end,
              curve: Curves.easeInOutCubic,
            ),
          ),
        );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final isFormValid = _otpControllers.every(
      (
        controller,
      ) => controller.text.isNotEmpty,
    );
    if (isFormValid) {
      final otp = _otpControllers
          .map(
            (
              controller,
            ) => controller.text,
          )
          .join();
      debugPrint(
        'Entered OTP: $otp',
      );

      // Navigate to dashboard and clear the auth screen history
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(
        '/dashboard',
        (
          Route<
            dynamic
          >
          route,
        ) => false,
      );
    } else {
      debugPrint(
        'OTP is incomplete.',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all OTP fields.',
            style: GoogleFonts.lato(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        // This is the added part to control the status bar appearance
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
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
            // --- Animated Header ---
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

            // --- Animated Form (OTP boxes) ---
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

            // --- Animated Button ---
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationButton,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
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
                    child: Text(
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

            // --- Animated Footer ---
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
                    TextButton(
                      onPressed: () {
                        debugPrint(
                          'Resend OTP to ${widget.email}',
                        );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              'A new code has been sent to ${widget.email}',
                            ),
                          ),
                        );
                      },
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
