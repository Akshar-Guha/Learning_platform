import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_edit_sheet.dart';
import '../widgets/profile_stat_card.dart';
import '../../../streaks/presentation/providers/streak_providers.dart';
import '../../../streaks/presentation/widgets/streak_widgets.dart';
import '../../../goals/presentation/providers/goals_providers.dart';
import '../../../goals/presentation/widgets/active_goal_card.dart'; // For CompactGoalCard
import '../../../goals/presentation/widgets/create_goal_form.dart';

/// Profile Screen - View and edit own profile
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F1A), AppTheme.darkBg],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: profileAsync.when(
            data: (profile) => profile == null
                ? const Center(child: Text('No profile found'))
                : _buildContent(context, ref, profile),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryPurple),
            ),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
                  const SizedBox(height: 16),
                  Text('Error: $e', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(profileNotifierProvider.notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Header
          Row(
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryDark,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showEditSheet(context, ref),
                icon: const Icon(Iconsax.edit, color: AppTheme.primaryPurple),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 32),

          // Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    profile.displayName.isNotEmpty
                        ? profile.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (profile.isEduVerified)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.darkBg, width: 3),
                    ),
                    child: const Icon(Icons.verified, size: 16, color: Colors.white),
                  ),
                ),
            ],
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          // Name & Email
          Text(
            profile.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryDark,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.email,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryDark.withOpacity(0.8),
                ),
              ),
              if (profile.isEduVerified) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '.edu verified',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ),
              ],
            ],
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 32),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  icon: Iconsax.chart_21,
                  label: 'Score',
                  value: '${profile.consistencyScore}',
                  gradient: AppTheme.primaryGradient,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatCard(
                  icon: Iconsax.flash_1,
                  label: 'Streak',
                  value: '${profile.currentStreak}',
                  gradient: AppTheme.streakGradient,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatCard(
                  icon: Iconsax.crown,
                  label: 'Best',
                  value: '${profile.longestStreak}',
                  gradient: AppTheme.accentGradient,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 32),

          // My Goals Section
          _buildGoalsSection(context, ref),

          const SizedBox(height: 32),

          // Streak Calendar
          ref.watch(currentUserStreakProvider).when(
                data: (streak) => StreakCalendar(history: streak.history)
                    .animate()
                    .fadeIn(delay: 250.ms),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

          const SizedBox(height: 32),

          // Settings Section
          _buildSettingsSection(context, ref),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryDark,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsTile(
          icon: Iconsax.moon,
          title: 'Appearance',
          subtitle: 'Dark mode',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Iconsax.notification,
          title: 'Notifications',
          subtitle: 'Manage alerts',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Iconsax.logout,
          title: 'Sign Out',
          subtitle: 'See you soon!',
          isDestructive: true,
          onTap: () => _handleSignOut(context, ref),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildGoalsSection(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(userGoalsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryDark,
              ),
            ),
            GestureDetector(
              onTap: () => _showCreateGoalSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 14, color: AppTheme.primaryPurple),
                    SizedBox(width: 4),
                    Text(
                      'Add Goal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        goalsAsync.when(
          data: (goals) {
            if (goals.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppTheme.textSecondaryDark.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Icon(Iconsax.task_square,
                        size: 32,
                        color: AppTheme.textSecondaryDark.withOpacity(0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'No active goals',
                      style: TextStyle(
                          color: AppTheme.textSecondaryDark.withOpacity(0.7)),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: goals
                  .map((goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CompactGoalCard(goal: goal),
                      ))
                  .toList(),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryPurple)),
          error: (e, _) => Text('Error loading goals: $e',
              style: const TextStyle(color: AppTheme.error)),
        ),
      ],
    ).animate().fadeIn(delay: 250.ms);
  }

  void _showCreateGoalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateGoalForm(),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProfileEditSheet(),
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
        title: const Text('Sign Out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppTheme.error : AppTheme.textPrimaryDark;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: (isDestructive ? AppTheme.error : AppTheme.primaryPurple).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isDestructive ? AppTheme.error : AppTheme.primaryPurple, size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
      subtitle: Text(subtitle, style: TextStyle(color: AppTheme.textSecondaryDark.withOpacity(0.7), fontSize: 12)),
      trailing: Icon(Iconsax.arrow_right_3, color: color.withOpacity(0.5), size: 18),
    );
  }
}
