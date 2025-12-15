import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/feature_data.dart';

/// Stats Section - Animated counters showing platform metrics
class StatsSection extends StatelessWidget {
  final List<StatData>? stats;
  
  const StatsSection({
    super.key,
    this.stats,
  });

  List<StatData> get _stats => stats ?? [
    const StatData(
      value: '90',
      suffix: '%',
      label: 'Higher Completion Rate',
      icon: Iconsax.chart_success,
    ),
    const StatData(
      value: '4',
      suffix: '',
      label: 'Members Per Squad',
      icon: Iconsax.people,
    ),
    const StatData(
      value: '10',
      suffix: 'x',
      label: 'More Accountability',
      icon: Iconsax.flash_1,
    ),
    const StatData(
      value: '24',
      suffix: '/7',
      label: 'AI Coaching',
      icon: Iconsax.cpu,
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
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppTheme.darkBorder.withOpacity(0.5),
          ),
        ),
      ),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(isDesktop),
          
          const SizedBox(height: 60),
          
          // Stats grid
          _buildStatsGrid(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDesktop) {
    return Column(
      children: [
        Text(
          'The Numbers Don\'t Lie',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 36 : 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryDark,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 12),
        
        Text(
          'Our users are 90% more likely to complete their learning goals.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            color: AppTheme.textSecondaryDark,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop, bool isTablet) {
    final int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isDesktop ? 1.2 : 1.1,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        return _buildStatCard(_stats[index], index);
      },
    );
  }

  Widget _buildStatCard(StatData stat, int index) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.darkSurface,
        border: Border.all(
          color: AppTheme.darkBorder.withOpacity(0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          if (stat.icon != null)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryPurple.withOpacity(0.1),
              ),
              child: Icon(
                stat.icon,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
            )
                .animate()
                .fadeIn(
                  duration: 600.ms,
                  delay: Duration(milliseconds: 100 * index),
                )
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  delay: Duration(milliseconds: 100 * index),
                ),
          
          const SizedBox(height: 16),
          
          // Value with animated counter effect
          _AnimatedCounter(
            value: stat.value,
            suffix: stat.suffix ?? '',
            delay: Duration(milliseconds: 200 + 100 * index),
          ),
          
          const SizedBox(height: 8),
          
          // Label
          Text(
            stat.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryDark,
            ),
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: Duration(milliseconds: 400 + 100 * index),
              ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: 100 * index),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: 100 * index),
        );
  }
}

/// Animated counter widget for stat values
class _AnimatedCounter extends StatefulWidget {
  final String value;
  final String suffix;
  final Duration delay;

  const _AnimatedCounter({
    required this.value,
    required this.suffix,
    required this.delay,
  });

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numericValue = int.tryParse(widget.value) ?? 0;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final displayValue = (numericValue * _animation.value).round();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.primaryGradient.createShader(bounds),
              child: Text(
                numericValue > 0 ? '$displayValue' : widget.value,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.primaryGradient.createShader(bounds),
              child: Text(
                widget.suffix,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
