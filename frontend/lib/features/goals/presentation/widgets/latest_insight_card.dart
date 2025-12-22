/// Latest Insight Card Widget
/// 
/// Displays the most recent AI-generated insight on the dashboard

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/focus_stats.dart';
import '../providers/goals_providers.dart';

class LatestInsightCard extends ConsumerWidget {
  const LatestInsightCard({super.key});

  IconData _getInsightIcon(InsightType type) {
    switch (type) {
      case InsightType.pattern:
        return Iconsax.chart_21;
      case InsightType.comparison:
        return Iconsax.arrow_swap_horizontal;
      case InsightType.milestone:
        return Iconsax.medal_star;
      case InsightType.recommendation:
        return Iconsax.lamp_on;
    }
  }

  Color _getInsightColor(InsightType type) {
    switch (type) {
      case InsightType.pattern:
        return AppTheme.accentCyan;
      case InsightType.comparison:
        return AppTheme.primaryPurple;
      case InsightType.milestone:
        return AppTheme.success;
      case InsightType.recommendation:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(recentInsightsProvider);

    return insightsAsync.when(
      data: (insights) {
        if (insights.isEmpty) return const SizedBox.shrink();
        return _buildCard(insights.first);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(SessionInsight insight) {
    final iconColor = _getInsightColor(insight.insightType);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withOpacity(0.08),
            iconColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getInsightIcon(insight.insightType),
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'AI Insight',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  insight.insightText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimaryDark,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }
}
