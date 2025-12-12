import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/squad_providers.dart';
import '../widgets/invite_code_widget.dart';
import '../widgets/member_tile.dart';

/// Squad Detail Screen - Shows squad info, members, and actions
class SquadDetailScreen extends ConsumerWidget {
  final String squadId;

  const SquadDetailScreen({super.key, required this.squadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(squadDetailProvider(squadId));
    final currentUser = ref.watch(currentUserProvider);
    final currentUserId = currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: AppTheme.textPrimaryDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F1A), AppTheme.darkBg],
            stops: [0.0, 0.3],
          ),
        ),
        child: detailAsync.when(
          data: (squad) {
            final isOwner = squad.ownerId == currentUserId;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Squad header
                  _buildHeader(squad).animate().fadeIn(),
                  const SizedBox(height: 24),

                  // Invite code (visible to all members)
                  InviteCodeWidget(
                    inviteCode: squad.inviteCode,
                    isOwner: isOwner,
                    onRegenerate: isOwner
                        ? () => _regenerateCode(ref, context)
                        : null,
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 24),

                  // Members section
                  Row(
                    children: [
                      const Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${squad.memberCount}/${squad.maxMembers}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),

                  // Members list
                  ...squad.members.asMap().entries.map((entry) {
                    final index = entry.key;
                    final member = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: MemberTile(
                        member: member,
                        isCurrentUserOwner: isOwner,
                        currentUserId: currentUserId,
                        onKick: () => _kickMember(ref, context, squad.id, member.userId, member.displayName),
                      ).animate().fadeIn(delay: (250 + index * 50).ms),
                    );
                  }),

                  const SizedBox(height: 32),

                  // Actions
                  if (!isOwner)
                    _buildLeaveButton(ref, context, squad.id, currentUserId)
                        .animate().fadeIn(delay: 400.ms)
                  else
                    _buildDeleteButton(ref, context, squad.id)
                        .animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryPurple),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
                const SizedBox(height: 16),
                Text('Error: $e'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(squad) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              squad.name.isNotEmpty ? squad.name[0].toUpperCase() : 'S',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                squad.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryDark,
                ),
              ),
              if (squad.description != null && squad.description!.isNotEmpty)
                Text(
                  squad.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryDark.withOpacity(0.8),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveButton(WidgetRef ref, BuildContext context, String squadId, String userId) {
    return GestureDetector(
      onTap: () => _leaveSquad(ref, context, squadId, userId),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, size: 18, color: AppTheme.error),
            SizedBox(width: 8),
            Text(
              'Leave Squad',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(WidgetRef ref, BuildContext context, String squadId) {
    return GestureDetector(
      onTap: () => _deleteSquad(ref, context, squadId),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.trash, size: 18, color: AppTheme.error),
            SizedBox(width: 8),
            Text(
              'Delete Squad',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _regenerateCode(WidgetRef ref, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Regenerate Code?'),
        content: const Text('The current invite code will stop working.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Regenerate', style: TextStyle(color: AppTheme.warning)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(squadNotifierProvider.notifier).regenerateCode(squadId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New invite code generated!'), backgroundColor: AppTheme.success),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
          );
        }
      }
    }
  }

  void _kickMember(WidgetRef ref, BuildContext context, String squadId, String userId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Remove Member?'),
        content: Text('Are you sure you want to remove $name from the squad?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(squadNotifierProvider.notifier).kickMember(squadId, userId);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
          );
        }
      }
    }
  }

  void _leaveSquad(WidgetRef ref, BuildContext context, String squadId, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Leave Squad?'),
        content: const Text('Are you sure you want to leave this squad?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Leave', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(squadNotifierProvider.notifier).leaveSquad(squadId, userId);
        if (context.mounted) context.pop();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
          );
        }
      }
    }
  }

  void _deleteSquad(WidgetRef ref, BuildContext context, String squadId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Delete Squad?'),
        content: const Text('This action cannot be undone. All members will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(squadNotifierProvider.notifier).deleteSquad(squadId);
        if (context.mounted) context.pop();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.error),
          );
        }
      }
    }
  }
}
