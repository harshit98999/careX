import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen
    extends
        StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<
    SplashScreen
  >
  createState() => _SplashScreenState();
}

class _SplashScreenState
    extends
        State<
          SplashScreen
        >
    with
        TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _backgroundController;

  late Animation<
    double
  >
  _fadeAnimation;
  late Animation<
    double
  >
  _scaleAnimation;
  late Animation<
    Offset
  >
  _slideAnimationTitle;
  late Animation<
    Offset
  >
  _slideAnimationTagline;
  late Animation<
    Offset
  >
  _slideAnimationButton;

  @override
  void initState() {
    super.initState();

    // Controller for the main content animations
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 1200,
      ),
      vsync: this,
    );

    // Controller for the background image animation
    _backgroundController = AnimationController(
      duration: const Duration(
        seconds: 15,
      ),
      vsync: this,
    );

    // General fade animation
    _fadeAnimation =
        Tween<
              double
            >(
              begin: 0.0,
              end: 1.0,
            )
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.easeIn,
              ),
            );

    // Background scale animation
    _scaleAnimation =
        Tween<
              double
            >(
              begin: 1.0,
              end: 1.15,
            )
            .animate(
              CurvedAnimation(
                parent: _backgroundController,
                curve: Curves.easeInOut,
              ),
            );

    // Staggered slide animations
    _slideAnimationTitle = _createSlideAnimation(
      begin: 0.0,
      end: 0.6,
    );
    _slideAnimationTagline = _createSlideAnimation(
      begin: 0.2,
      end: 0.8,
    );
    _slideAnimationButton = _createSlideAnimation(
      begin: 0.4,
      end: 1.0,
    );

    // Start the animations
    _controller.forward();
    _backgroundController.forward();
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
              curve: Curves.easeOutCubic,
            ),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    // Reverse the animations and navigate after they complete
    _controller.reverse().then(
      (
        _,
      ) {
        Navigator.of(
          context,
        ).pushNamed(
          '/login',
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated Background Image
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/doctor.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(
                0.3,
              ),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(
                    0.9,
                  ),
                  Colors.black.withOpacity(
                    0.4,
                  ),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [
                  0.0,
                  0.5,
                  1.0,
                ],
              ),
            ),
          ),

          // Animated Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimationTitle,
                      child: Text(
                        'CareX',
                        style: GoogleFonts.poppins(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Tagline
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimationTagline,
                      child: Text(
                        'Exceptional Care,\nClose to You.',
                        style: GoogleFonts.lato(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(
                            0.95,
                          ),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),

                  // "Get Started" Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimationButton,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onGetStarted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF6A49E2,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                            ),
                            elevation: 8,
                            shadowColor: Colors.black.withOpacity(
                              0.4,
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
