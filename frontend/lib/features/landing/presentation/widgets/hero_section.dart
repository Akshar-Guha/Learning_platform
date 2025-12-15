import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/gradient_button.dart';

/// Hero Section - The first thing users see
/// Features animated gradient background, floating particles, and CTA buttons
class HeroSection extends StatelessWidget {
  final VoidCallback? onLearnMore;
  
  const HeroSection({
    super.key,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: size.height * 0.95,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0F),
            Color(0xFF0F0F1A),
            Color(0xFF1A1025),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated gradient orbs
          ..._buildGradientOrbs(size),
          
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 24,
                vertical: 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  
                  // Badge
                  _buildBadge(),
                  
                  const SizedBox(height: 32),
                  
                  // Main headline
                  _buildHeadline(isDesktop),
                  
                  const SizedBox(height: 24),
                  
                  // Subheadline
                  _buildSubheadline(isDesktop),
                  
                  const SizedBox(height: 48),
                  
                  // CTA Buttons
                  _buildCTAButtons(context, isDesktop),
                  
                  const SizedBox(height: 64),
                  
                  // Stats row
                  _buildQuickStats(isDesktop),
                  
                  const SizedBox(height: 48),
                  
                  // Scroll indicator
                  _buildScrollIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.primaryPurple.withOpacity(0.4),
        ),
        color: AppTheme.primaryPurple.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.success,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.3, 1.3),
                duration: 1000.ms,
              ),
          const SizedBox(width: 10),
          const Text(
            '🚀 Built for Gen-Z Learners',
            style: TextStyle(
              color: AppTheme.textSecondaryDark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0);
  }

  Widget _buildHeadline(bool isDesktop) {
    return Column(
      children: [
        Text(
          'Stop Learning',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 64 : 40,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimaryDark,
            height: 1.1,
            letterSpacing: -1,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.3, end: 0),
        
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            'Alone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 64 : 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0)
            .then()
            .shimmer(
              duration: 2000.ms,
              color: Colors.white.withOpacity(0.3),
            ),
      ],
    );
  }

  Widget _buildSubheadline(bool isDesktop) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
      child: Text(
        'Join Squads of 4. Build streaks together. Get verified discipline metrics that recruiters actually trust.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isDesktop ? 20 : 16,
          color: AppTheme.textSecondaryDark,
          height: 1.6,
          fontWeight: FontWeight.w400,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 300.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildCTAButtons(BuildContext context, bool isDesktop) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        // Primary CTA
        SizedBox(
          width: isDesktop ? 220 : double.infinity,
          child: GradientButton(
            text: 'Get Started Free',
            onPressed: () => context.go(AppRoutes.signup),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideY(begin: 0.3, end: 0),
        
        // Secondary CTA
        SizedBox(
          width: isDesktop ? 180 : double.infinity,
          child: OutlinedButton(
            onPressed: onLearnMore,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              side: BorderSide(
                color: AppTheme.darkBorder.withOpacity(0.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'See Features',
                  style: TextStyle(
                    color: AppTheme.textPrimaryDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 18,
                  color: AppTheme.textSecondaryDark,
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildQuickStats(bool isDesktop) {
    final stats = [
      {'value': '90%', 'label': 'Completion Rate'},
      {'value': '4', 'label': 'Squad Size'},
      {'value': '24/7', 'label': 'AI Coaching'},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isDesktop ? 48 : 24,
      runSpacing: 16,
      children: stats.asMap().entries.map((entry) {
        return Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => 
                  AppTheme.primaryGradient.createShader(bounds),
              child: Text(
                entry.value['value']!,
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.value['label']!,
              style: TextStyle(
                fontSize: isDesktop ? 14 : 12,
                color: AppTheme.textSecondaryDark,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 600 + entry.key * 100),
            )
            .slideY(begin: 0.3, end: 0);
      }).toList(),
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        Text(
          'Scroll to explore',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryDark.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppTheme.textSecondaryDark.withOpacity(0.6),
        )
            .animate(onPlay: (c) => c.repeat())
            .slideY(
              begin: 0,
              end: 0.3,
              duration: 1000.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .slideY(
              begin: 0.3,
              end: 0,
              duration: 1000.ms,
              curve: Curves.easeInOut,
            ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 900.ms);
  }

  List<Widget> _buildGradientOrbs(Size size) {
    return [
      // Purple orb top right (static, no animation for performance)
      Positioned(
        top: -100,
        right: -100,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryPurple.withOpacity(0.3),
                AppTheme.primaryPurple.withOpacity(0),
              ],
            ),
          ),
        ),
      ),
      
      // Cyan orb bottom left (static, no animation for performance)
      Positioned(
        bottom: -50,
        left: -100,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.accentCyan.withOpacity(0.2),
                AppTheme.accentCyan.withOpacity(0),
              ],
            ),
          ),
        ),
      ),
      
      // Reduced floating particles (5 instead of 15) with simpler animations
      ...List.generate(5, (index) {
        final random = math.Random(index);
        return Positioned(
          left: random.nextDouble() * size.width,
          top: random.nextDouble() * size.height * 0.6,
          child: Container(
            width: 5 + random.nextDouble() * 3,
            height: 5 + random.nextDouble() * 3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (index % 2 == 0 ? AppTheme.primaryPurple : AppTheme.accentCyan)
                  .withOpacity(0.5),
            ),
          ),
        );
      }),
    ];
  }
}
