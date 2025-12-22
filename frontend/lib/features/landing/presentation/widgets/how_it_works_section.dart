import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/feature_data.dart';

/// How It Works Section - Step-by-step visual guide
class HowItWorksSection extends StatelessWidget {
  final List<HowItWorksStep>? steps;
  
  const HowItWorksSection({
    super.key,
    this.steps,
  });

  List<HowItWorksStep> get _steps => steps ?? [
    const HowItWorksStep(
      stepNumber: 1,
      icon: Iconsax.user_add,
      title: 'Sign Up & Join Squad',
      description: 'Create account in 30 seconds. Join or create a squad of 4.',
    ),
    const HowItWorksStep(
      stepNumber: 2,
      icon: Iconsax.calendar_tick,
      title: 'Set Study Goals',
      description: 'Define up to 5 goals with deadlines. Get AI-generated schedules.',
    ),
    const HowItWorksStep(
      stepNumber: 3,
      icon: Iconsax.timer_start,
      title: 'Focus Together',
      description: 'Start sessions linked to goals. Your squad sees you\'re working.',
    ),
    const HowItWorksStep(
      stepNumber: 4,
      icon: Iconsax.chart_21,
      title: 'Track & Improve',
      description: 'View focus stats, AI insights, and build streaks together.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.darkBg,
            AppTheme.darkSurface,
          ],
        ),
      ),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(isDesktop),
          
          const SizedBox(height: 60),
          
          // Steps
          isDesktop ? _buildDesktopSteps() : _buildMobileSteps(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDesktop) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.accentCyan.withOpacity(0.1),
          ),
          child: const Text(
            'HOW IT WORKS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.accentCyan,
              letterSpacing: 1.5,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 20),
        
        Text(
          'Get Started in',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 42 : 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryDark,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.3, end: 0),
        
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.accentCyan, Color(0xFF0EA5E9)],
          ).createShader(bounds),
          child: Text(
            '4 Simple Steps',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 42 : 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildDesktopSteps() {
    return Row(
      children: _steps.asMap().entries.expand((entry) {
        final index = entry.key;
        final step = entry.value;
        
        return [
          Expanded(child: _buildStepCard(step, index)),
          if (index < _steps.length - 1) _buildConnector(index),
        ];
      }).toList(),
    );
  }

  Widget _buildMobileSteps() {
    return Column(
      children: _steps.asMap().entries.expand((entry) {
        final index = entry.key;
        final step = entry.value;
        
        return [
          _buildStepCard(step, index),
          if (index < _steps.length - 1) 
            _buildVerticalConnector(index),
        ];
      }).toList(),
    );
  }

  Widget _buildStepCard(HowItWorksStep step, int index) {
    return Column(
      children: [
        // Step number circle
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${step.stepNumber}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 200 * index),
            )
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 600.ms,
              delay: Duration(milliseconds: 200 * index),
              curve: Curves.elasticOut,
            ),
        
        const SizedBox(height: 20),
        
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.darkCard,
            border: Border.all(
              color: AppTheme.darkBorder,
            ),
          ),
          child: Icon(
            step.icon,
            size: 36,
            color: AppTheme.primaryPurple,
          ),
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 300 + 200 * index),
            )
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 20),
        
        // Title
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryDark,
          ),
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 400 + 200 * index),
            ),
        
        const SizedBox(height: 8),
        
        // Description
        Text(
          step.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryDark.withOpacity(0.9),
            height: 1.4,
          ),
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: Duration(milliseconds: 500 + 200 * index),
            ),
      ],
    );
  }

  Widget _buildConnector(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: SizedBox(
        width: 60,
        child: Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: Duration(milliseconds: 600 + 200 * index + 100 * i),
                  )
                  .scaleX(
                    begin: 0,
                    end: 1,
                    duration: 400.ms,
                    delay: Duration(milliseconds: 600 + 200 * index + 100 * i),
                  ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildVerticalConnector(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: List.generate(3, (i) {
          return Container(
            width: 3,
            height: 12,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppTheme.primaryPurple.withOpacity(0.3),
            ),
          )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: Duration(milliseconds: 600 + 200 * index + 100 * i),
              )
              .scaleY(
                begin: 0,
                end: 1,
                duration: 400.ms,
                delay: Duration(milliseconds: 600 + 200 * index + 100 * i),
              );
        }),
      ),
    );
  }
}
