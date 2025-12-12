import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/squad.dart';

/// Squad Card - Displays squad summary with stacked member avatars
class SquadCard extends StatelessWidget {
  final Squad squad;
  final VoidCallback onTap;

  const SquadCard({
    super.key,
    required this.squad,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorder.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Squad icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      squad.name.isNotEmpty ? squad.name[0].toUpperCase() : 'S',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        squad.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (squad.description != null && squad.description!.isNotEmpty)
                        Text(
                          squad.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryDark.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Footer: member count + avatars
            Row(
              children: [
                // Stacked avatars placeholder
                _buildStackedAvatars(),
                const Spacer(),
                // Member count badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: AppTheme.primaryPurple.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${squad.memberCount}/${squad.maxMembers}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStackedAvatars() {
    final count = squad.memberCount.clamp(0, 4);
    if (count == 0) return const SizedBox.shrink();

    return SizedBox(
      width: 20.0 + (count - 1) * 16.0,
      height: 28,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(
            left: index * 16.0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAvatarColor(index),
                border: Border.all(color: AppTheme.darkCard, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppTheme.primaryPurple,
      AppTheme.accentCyan,
      AppTheme.success,
      AppTheme.warning,
    ];
    return colors[index % colors.length];
  }
}
