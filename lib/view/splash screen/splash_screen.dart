import 'dart:async';

import 'package:activity_tracker/res/app_colors.dart';
import 'package:activity_tracker/res/app_sizes.dart';
import 'package:activity_tracker/view/login%20screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
    _startSplashAndNavigate();
  }

  Future<void> _startSplashAndNavigate() async {
    // Yahan pe normally auth check hota, abhi dummy time delay rakha
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Example: har baar LogInScreen jayega, tujhe app logic ke hisaab se change karna hoga
    _navigateTo(LoginScreen());
    // Ya: _navigateTo(const EditActivityScreen());
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context).extension<AppColors>()!;
    final typography = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -80,
              bottom: -80,
              child: Opacity(
                opacity: 0.05,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSizes.spaceL),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: AppSizes.shadowMedium(Colors.black),
                            ),
                            child: Icon(
                              Icons.bolt_rounded,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ),
                          AppSizes.spaceXL.vSpace,
                          Text(
                            "Activation Tracker",
                            style: typography.headlineLarge?.copyWith(
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  blurRadius: 10,
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          AppSizes.spaceS.vSpace,
                          Text(
                            "The Ultimate Experience",
                            style: typography.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 2.0,
                            ),
                          ),
                          AppSizes.spaceXXXL.vSpace,
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.5),
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
