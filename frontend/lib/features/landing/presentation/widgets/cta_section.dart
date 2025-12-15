import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/gradient_button.dart';

/// CTA Section - Final call to action before footer
class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 100,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F1A),
            Color(0xFF1A1025),
            Color(0xFF0F0F1A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background gradient orbs
          ..._buildBackgroundOrbs(size),
          
          // Content
          Center(
            child: Column(
              children: [
                // Main headline
                Text(
                  'Ready to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 48 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryDark,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.primaryGradient.createShader(bounds),
                  child: Text(
                    'Rise Together?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 48 : 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.3, end: 0)
                    .then()
                    .shimmer(
                      duration: 2000.ms,
                      color: Colors.white.withOpacity(0.3),
                    ),
                
                const SizedBox(height: 24),
                
                // Subtitle
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 500 : double.infinity),
                  child: Text(
                    'Join thousands of students who\'ve transformed their learning habits with the power of accountability.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 15,
                      color: AppTheme.textSecondaryDark,
                      height: 1.6,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 48),
                
                // CTA Button
                SizedBox(
                  width: isDesktop ? 280 : double.infinity,
                  child: GradientButton(
                    text: 'Create Free Account',
                    height: 60,
                    onPressed: () => context.go(AppRoutes.signup),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 24),
                
                // Secondary option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: AppTheme.textSecondaryDark.withOpacity(0.8),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.primaryGradient.createShader(bounds),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),
                
                const SizedBox(height: 48),
                
                // Trust badges
                _buildTrustBadges(isDesktop),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadges(bool isDesktop) {
    final badges = [
      '🔒 Bank-Level Security',
      '⚡ No Credit Card Required',
      '🎯 Cancel Anytime',
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isDesktop ? 32 : 16,
      runSpacing: 12,
      children: badges.asMap().entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppTheme.darkCard.withOpacity(0.6),
            border: Border.all(
              color: AppTheme.darkBorder.withOpacity(0.5),
            ),
          ),
          child: Text(
            entry.value,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondaryDark.withOpacity(0.9),
            ),
          ),
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 500 + entry.key * 100),
            )
            .slideY(begin: 0.3, end: 0);
      }).toList(),
    );
  }

  List<Widget> _buildBackgroundOrbs(Size size) {
    return [
      // Static orbs for better performance
      Positioned(
        top: -50,
        right: -50,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryPurple.withOpacity(0.2),
                AppTheme.primaryPurple.withOpacity(0),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -30,
        left: -30,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.accentCyan.withOpacity(0.15),
                AppTheme.accentCyan.withOpacity(0),
              ],
            ),
          ),
        ),
      ),
      // Static particles (no animations)
      ...List.generate(4, (index) {
        final random = math.Random(index + 100);
        return Positioned(
          left: random.nextDouble() * size.width,
          top: random.nextDouble() * 250,
          child: Container(
            width: 4 + random.nextDouble() * 3,
            height: 4 + random.nextDouble() * 3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (index % 2 == 0 ? AppTheme.primaryPurple : AppTheme.accentCyan)
                  .withOpacity(0.4),
            ),
          ),
        );
      }),
    ];
  }
}
