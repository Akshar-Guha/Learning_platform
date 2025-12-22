/// Active Goal Card Widget
/// 
/// Displays a study goal with progress on the dashboard

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/study_goal.dart';

class ActiveGoalCard extends StatelessWidget {
  final StudyGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onGenerateSchedule;

  const ActiveGoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onGenerateSchedule,
  });

  Color get _priorityColor {
    switch (goal.priority) {
      case GoalPriority.high:
        return AppTheme.error;
      case GoalPriority.medium:
        return AppTheme.warning;
      case GoalPriority.low:
        return AppTheme.success;
    }
  }

  String get _priorityLabel {
    switch (goal.priority) {
      case GoalPriority.high:
        return 'High';
      case GoalPriority.medium:
        return 'Medium';
      case GoalPriority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: goal.isOnTrack 
                ? AppTheme.success.withOpacity(0.3)
                : AppTheme.warning.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _priorityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _priorityLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _priorityColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: goal.progressPercent,
                backgroundColor: AppTheme.textSecondaryDark.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.isOnTrack ? AppTheme.success : AppTheme.warning,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),

            // Stats row
            Row(
              children: [
                Icon(
                  Iconsax.timer_1,
                  size: 14,
                  color: AppTheme.textSecondaryDark.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  '${goal.completedHours}/${goal.targetHours}h',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryDark.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Iconsax.calendar,
                  size: 14,
                  color: AppTheme.textSecondaryDark.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  '${goal.daysRemaining}d left',
                  style: TextStyle(
                    fontSize: 12,
                    color: goal.daysRemaining <= 2 
                        ? AppTheme.error 
                        : AppTheme.textSecondaryDark.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (!goal.aiScheduleGenerated && onGenerateSchedule != null)
                  GestureDetector(
                    onTap: onGenerateSchedule,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryPurple, AppTheme.primaryIndigo],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.magic_star, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'AI Plan',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0);
  }
}

/// Compact goal card for small spaces
class CompactGoalCard extends StatelessWidget {
  final StudyGoal goal;
  final VoidCallback? onTap;

  const CompactGoalCard({
    super.key,
    required this.goal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.darkCard.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.textSecondaryDark.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // Progress circle
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                value: goal.progressPercent,
                strokeWidth: 3,
                backgroundColor: AppTheme.textSecondaryDark.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.isOnTrack ? AppTheme.success : AppTheme.warning,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${goal.completedHours}/${goal.targetHours}h • ${goal.daysRemaining}d left',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondaryDark.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: AppTheme.textSecondaryDark.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
