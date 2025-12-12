import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/models/streak_models.dart';

class StreakCard extends StatelessWidget {
  final StreakData streakData;
  final VoidCallback? onCheckIn;
  final bool isCheckingIn;

  const StreakCard({
    super.key,
    required this.streakData,
    this.onCheckIn,
    this.isCheckingIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCheckedInToday = streakData.lastActiveDate != null &&
        _isSameDay(streakData.lastActiveDate!, DateTime.now());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: isCheckedInToday ? 1.0 : 0.7, // Visual distinctness
                    strokeWidth: 12,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCheckedInToday ? Colors.orange : theme.colorScheme.primary,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🔥',
                      style: TextStyle(fontSize: 32),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1.seconds),
                    Text(
                      '${streakData.currentStreak}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Current Streak',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (!isCheckedInToday)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isCheckingIn ? null : onCheckIn,
                  icon: isCheckingIn
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.tick_circle),
                  label: Text(isCheckingIn ? 'Checking In...' : 'Check In Today'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.verify, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Streak Kept!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class ConsistencyBadge extends StatelessWidget {
  final int score;

  const ConsistencyBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    if (score >= 90) {
      color = Colors.green;
      label = 'Elite';
    } else if (score >= 70) {
      color = Colors.blue;
      label = 'Consistent';
    } else if (score >= 40) {
      color = Colors.orange;
      label = 'Building';
    } else {
      color = Colors.grey;
      label = 'Newbie';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.chart_1, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '$score% $label',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class StreakCalendar extends StatelessWidget {
  final List<ActivityDay> history;

  const StreakCalendar({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    // Show last 30 days
    final displayHistory = history.length > 30 
        ? history.sublist(0, 30) 
        : history;
    
    // Ensure we fill up 30 slots if less? Or just show what we have.
    // Use Wrap for heatmap style around 7 columns
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity History (Last 30 Days)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(30, (index) {
            // Mapping index to history is tricky if history is sparse or ordered by date desc.
            // Assumption: history is ordered DESC (latest first).
            // Visual Calendar usually goes Left->Right, Top->Bottom (Oldest->Newest).
            // Let's assume passed history is DATE DESC.
            // We want to display DATE ASC.
            
            // If history is empty, show empty boxes.
            if (index >= history.length) {
               return _buildDayBox(context, false);
            }
            
            // Sort history by date ASC to fill calendar properly?
            // Actually prompt says "Heatmap". usually specific grid.
            // Let's simplified version: Just show boxes color coded.
            
            // Using reverse index if list is DESC
             final day = displayHistory.length > index ? displayHistory[index] : null;

             return _buildDayBox(context, day?.isActive ?? false);
          }),
        ),
      ],
    );
  }

  Widget _buildDayBox(BuildContext context, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardTile({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentUser ? theme.colorScheme.primaryContainer.withOpacity(0.3) : null,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: theme.colorScheme.primary.withOpacity(0.5)) : null,
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#${entry.rank}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getRankColor(entry.rank),
              ),
            ),
            const SizedBox(width: 12),
             CircleAvatar(
              backgroundImage: entry.avatarUrl != null ? NetworkImage(entry.avatarUrl!) : null,
              child: entry.avatarUrl == null ? Text(entry.displayName[0].toUpperCase()) : null,
            ),
          ],
        ),
        title: Text(
          entry.displayName,
          style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal),
        ),
        subtitle: Text('Consistency: ${entry.consistencyScore}%'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${entry.currentStreak}',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text('🔥'),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFFFFD700); // Gold
      case 2: return const Color(0xFFC0C0C0); // Silver
      case 3: return const Color(0xFFCD7F32); // Bronze
      default: return Colors.grey;
    }
  }
}
