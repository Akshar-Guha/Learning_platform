/// Focus Stats Card Widget
/// 
/// Displays aggregated focus statistics on the dashboard

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/focus_stats.dart';
import '../providers/goals_providers.dart';

class FocusStatsCard extends ConsumerWidget {
  const FocusStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(myFocusStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildCard(stats),
      loading: () => _buildLoadingCard(),
      error: (_, __) => _buildEmptyCard(),
    );
  }

  Widget _buildCard(FocusStats stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple.withOpacity(0.15),
            AppTheme.primaryIndigo.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.chart_21,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: stats.hoursThisWeekFormatted,
                  label: 'Focus Time',
                  icon: Iconsax.timer_1,
                  color: AppTheme.success,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppTheme.textSecondaryDark.withOpacity(0.2),
              ),
              Expanded(
                child: _StatItem(
                  value: '${stats.sessionsThisWeek}',
                  label: 'Sessions',
                  icon: Iconsax.activity,
                  color: AppTheme.accentCyan,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppTheme.textSecondaryDark.withOpacity(0.2),
              ),
              Expanded(
                child: _StatItem(
                  value: stats.avgSessionFormatted,
                  label: 'Avg Session',
                  icon: Iconsax.clock,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          if (stats.bestFocusTime.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.sun_1,
                    size: 16,
                    color: AppTheme.success.withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Peak focus: ${stats.bestFocusTime}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.success.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.textSecondaryDark.withOpacity(0.1),
        ),
      ),
      child: const Column(
        children: [
          Icon(Iconsax.chart, size: 32, color: AppTheme.textSecondaryDark),
          SizedBox(height: 8),
          Text(
            'No focus data yet',
            style: TextStyle(color: AppTheme.textSecondaryDark),
          ),
          Text(
            'Start your first session!',
            style: TextStyle(color: AppTheme.textSecondaryDark, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondaryDark.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
