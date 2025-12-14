import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Splash Screen - Premium animated loading screen with timeout
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timeout: Navigate to login after 3 seconds if still loading
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final authState = ref.read(authNotifierProvider);
        if (authState.status == AuthStatus.initial ||
            authState.status == AuthStatus.loading) {
          // Still loading after 3s, go to login
          context.go(AppRoutes.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state and navigate accordingly
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
      } else if (next.status == AuthStatus.unauthenticated ||
                 next.status == AuthStatus.error) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBg,
              Color(0xFF0F0F1A),
              Color(0xFF1A1025),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background animated particles
            ..._buildParticles(),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow effect
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(
                        duration: 2000.ms,
                        color: Colors.white.withOpacity(0.3),
                      )
                      .animate()
                      .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 32),

                  // App name
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.primaryGradient.createShader(bounds),
                    child: const Text(
                      'ULP',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: Colors.white,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'Rise Together',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      color: AppTheme.textSecondaryDark.withOpacity(0.8),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 64),

                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryPurple.withOpacity(0.8),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 600.ms)
                      .scale(duration: 400.ms, curve: Curves.easeOutCubic),

                  // DEBUG INFO
                  const SizedBox(height: 32),
                  Consumer(builder: (context, ref, _) {
                     final authState = ref.watch(authNotifierProvider);
                     return Text(
                       'DEBUG: Status=${authState.status}\nError=${authState.errorMessage}',
                       textAlign: TextAlign.center,
                       style: const TextStyle(color: Colors.red, fontSize: 12),
                     );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    return List.generate(20, (index) {
      return Positioned(
        left: (index % 5) * 80.0 + 20,
        top: (index ~/ 5) * 150.0 + 50,
        child: Container(
          width: 4 + (index % 3) * 2.0,
          height: 4 + (index % 3) * 2.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (index % 2 == 0 ? AppTheme.primaryPurple : AppTheme.accentCyan)
                .withOpacity(0.3),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: (1000 + index * 100).ms)
            .then()
            .fadeOut(duration: (1000 + index * 100).ms)
            .moveY(
              begin: 0,
              end: -20,
              duration: (2000 + index * 200).ms,
              curve: Curves.easeInOut,
            ),
      );
    });
  }
}

