import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/squad.dart';

/// Member Tile - Displays squad member with role badge and kick button
class MemberTile extends StatelessWidget {
  final SquadMember member;
  final bool isCurrentUserOwner;
  final String currentUserId;
  final VoidCallback? onKick;

  const MemberTile({
    super.key,
    required this.member,
    required this.isCurrentUserOwner,
    required this.currentUserId,
    this.onKick,
  });

  bool get isCurrentUser => member.userId == currentUserId;
  bool get canKick => isCurrentUserOwner && !member.isOwner && !isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: member.isOwner
              ? AppTheme.primaryPurple.withOpacity(0.3)
              : AppTheme.darkBorder.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: member.isOwner ? AppTheme.primaryGradient : null,
              color: member.isOwner ? null : AppTheme.darkBorder,
            ),
            child: member.avatarUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      member.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                    ),
                  )
                : _buildAvatarPlaceholder(),
          ),
          const SizedBox(width: 12),

          // Name and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.displayName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryDark,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Text(
                        '(You)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryDark.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                _buildRoleBadge(),
              ],
            ),
          ),

          // Kick button (owner only, can't kick self or other owner)
          if (canKick)
            IconButton(
              onPressed: onKick,
              icon: const Icon(Iconsax.user_remove, size: 20),
              color: AppTheme.error.withOpacity(0.8),
              tooltip: 'Remove member',
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Center(
      child: Text(
        member.displayName.isNotEmpty ? member.displayName[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRoleBadge() {
    if (member.isOwner) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.crown1, size: 10, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'Owner',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      'Member',
      style: TextStyle(
        fontSize: 12,
        color: AppTheme.textSecondaryDark.withOpacity(0.6),
      ),
    );
  }
}
