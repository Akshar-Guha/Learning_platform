import 'package:flutter/material.dart';

/// Model for feature showcase cards on the landing page
/// Scalable - add more features by creating new FeatureData instances
class FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Gradient? gradient;
  final Color? iconColor;

  const FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    this.gradient,
    this.iconColor,
  });
}

/// Model for "How It Works" steps
class HowItWorksStep {
  final int stepNumber;
  final IconData icon;
  final String title;
  final String description;

  const HowItWorksStep({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Model for stats/metrics display
class StatData {
  final String value;
  final String label;
  final String? suffix;
  final IconData? icon;

  const StatData({
    required this.value,
    required this.label,
    this.suffix,
    this.icon,
  });
}
