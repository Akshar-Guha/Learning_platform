import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/feature_data.dart';

/// Individual feature card with hover animations
class FeatureCard extends StatefulWidget {
  final FeatureData feature;
  final int index;

  const FeatureCard({
    super.key,
    required this.feature,
    this.index = 0,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.03 : 1.0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppTheme.darkCard,
          border: Border.all(
            color: _isHovered
                ? (widget.feature.iconColor ?? AppTheme.primaryPurple).withOpacity(0.6)
                : AppTheme.darkBorder,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? (widget.feature.iconColor ?? AppTheme.primaryPurple).withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              blurRadius: _isHovered ? 30 : 15,
              spreadRadius: _isHovered ? 2 : 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with gradient background
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: widget.feature.gradient ?? AppTheme.primaryGradient,
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: (widget.feature.iconColor ?? AppTheme.primaryPurple)
                              .withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: _isHovered ? 0.05 : 0,
                child: Icon(
                  widget.feature.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              widget.feature.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryDark,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Description
            Text(
              widget.feature.description,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryDark.withOpacity(0.9),
                height: 1.5,
              ),
            ),
            
            const Spacer(),
            
            // Learn more link
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 1.0 : 0.0,
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.primaryGradient.createShader(bounds),
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppTheme.primaryPurple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 600.ms,
          delay: Duration(milliseconds: 100 * widget.index),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          delay: Duration(milliseconds: 100 * widget.index),
          curve: Curves.easeOutCubic,
        );
  }
}
