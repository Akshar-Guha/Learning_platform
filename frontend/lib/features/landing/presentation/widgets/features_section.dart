import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/feature_data.dart';
import 'feature_card.dart';

/// Features Section - Showcases all app features in a grid
class FeaturesSection extends StatelessWidget {
  final List<FeatureData>? features;
  
  const FeaturesSection({
    super.key,
    this.features,
  });

  // Default features if none provided - showcases ALL app capabilities
  List<FeatureData> get _features => features ?? [
    const FeatureData(
      icon: Iconsax.people,
      title: 'Squad Up',
      description: 'Form accountability squads of 4. Small enough to care, big enough to motivate. See who\'s focusing in real-time.',
      gradient: LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
      ),
      iconColor: AppTheme.primaryPurple,
    ),
    const FeatureData(
      icon: Iconsax.timer_1,
      title: 'Body Doubling',
      description: 'Study alongside others without video calls. Just presence—like a silent library, digitally. Link sessions to goals.',
      gradient: LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF0EA5E9)],
      ),
      iconColor: AppTheme.accentCyan,
    ),
    const FeatureData(
      icon: Iconsax.calendar_tick,
      title: 'AI Study Planner',
      description: 'Set goals with deadlines. Our AI generates optimized daily schedules with 45-52 min focus blocks. Max 4 productive hours/day.',
      gradient: LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
      ),
      iconColor: AppTheme.success,
    ),
    const FeatureData(
      icon: Iconsax.message_programming,
      title: 'AI Focus Coach',
      description: 'Get data-driven insights after each session. Pattern analysis, progress tracking, actionable suggestions—no fluff.',
      gradient: LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
      ),
      iconColor: AppTheme.accentPink,
    ),
    const FeatureData(
      icon: Iconsax.flash_1,
      title: 'Streak Engine',
      description: 'Build consistency with social stakes. Your streak is shared—break it, and your squad knows. That\'s the magic.',
      gradient: LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      ),
      iconColor: AppTheme.warning,
    ),
    const FeatureData(
      icon: Iconsax.chart_21,
      title: 'Focus Dashboard',
      description: 'Track weekly focus hours, session counts, avg duration, and peak focus times. Squad leaderboards show who\'s rising.',
      gradient: LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      ),
      iconColor: AppTheme.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.darkBg,
      ),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(isDesktop),
          
          const SizedBox(height: 60),
          
          // Features grid
          _buildFeaturesGrid(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDesktop) {
    return Column(
      children: [
        // Section label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.primaryPurple.withOpacity(0.1),
          ),
          child: const Text(
            'FEATURES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryPurple,
              letterSpacing: 1.5,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 20),
        
        // Main title
        Text(
          'Everything You Need to',
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
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            'Actually Finish',
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
        
        const SizedBox(height: 16),
        
        // Subtitle
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 500 : double.infinity),
          child: Text(
            '90% of online learners quit. We built the tools to make sure you don\'t.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppTheme.textSecondaryDark,
              height: 1.5,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildFeaturesGrid(bool isDesktop, bool isTablet) {
    // Determine grid columns
    final int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
    final double childAspectRatio = isDesktop ? 0.85 : (isTablet ? 0.95 : 1.1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _features.length,
      itemBuilder: (context, index) {
        return FeatureCard(
          feature: _features[index],
          index: index,
        );
      },
    );
  }
}
