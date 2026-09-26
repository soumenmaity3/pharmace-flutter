import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';

/// A short branded launch screen that hands control to the sign-in flow.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _markScale;
  late final Animation<double> _contentOpacity;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
    _markScale = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _contentOpacity = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.35, 1, curve: Curves.easeOut),
    );
    _timer = Timer(const Duration(milliseconds: 2100), widget.onFinished);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            const _SplashDecorations(),
            Center(
              child: FadeTransition(
                opacity: _contentOpacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(scale: _markScale, child: const _BrandMark()),
                    const SizedBox(height: 24),
                    const Text(
                      'Pharmase',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your pharmacy, simplified.',
                      style: TextStyle(
                        color: AppColors.whiteText65,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
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

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_pharmacy_rounded,
        color: AppColors.primary,
        size: 43,
      ),
    );
  }
}

class _SplashDecorations extends StatelessWidget {
  const _SplashDecorations();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -125,
            right: -105,
            child: _Glow(size: 290, opacity: 0.10),
          ),
          Positioned(
            bottom: -110,
            left: -85,
            child: _Glow(size: 260, opacity: 0.08),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
