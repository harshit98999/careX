import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_screen.dart'; // Verified import path

class LoginScreen
    extends
        StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<
    LoginScreen
  >
  createState() => _LoginScreenState();
}

class _LoginScreenState
    extends
        State<
          LoginScreen
        >
    with
        SingleTickerProviderStateMixin {
  final _formKey =
      GlobalKey<
        FormState
      >();
  final TextEditingController _emailController = TextEditingController();

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

    _slideAnimationHeader = _createSlideAnimation(
      begin: 0.0,
      end: 0.6,
    );
    _slideAnimationForm = _createSlideAnimation(
      begin: 0.2,
      end: 0.8,
    );

    _controller.forward();
  }

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
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      debugPrint(
        'Email submitted: $email',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (
                context,
              ) => OtpVerificationScreen(
                email: email,
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
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This line removes the back button
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            // Animated Header
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationHeader,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's Your Email?",
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
                      'We need it to find your account or to create a new one.',
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
              height: 80,
            ),

            // Animated Form
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimationForm,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: GoogleFonts.lato(
                            color: Colors.grey[600],
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
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
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
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
                          child: Text(
                            'Send Verification Code',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
}
