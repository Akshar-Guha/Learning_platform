import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../streaks/presentation/providers/streak_providers.dart';
import '../../../streaks/presentation/widgets/streak_widgets.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/welcome_header.dart';

/// Home Screen - Main dashboard with streak and quick actions
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final streakAsync = ref.watch(currentUserStreakProvider);
    final isCheckingIn = ref.watch(checkInNotifierProvider).isLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F1A),
              AppTheme.darkBg,
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserProfileProvider);
            },
            color: AppTheme.primaryPurple,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Welcome Header
                  profileAsync.when(
                    data: (profile) => WelcomeHeader(
                      name: profile?.displayName ?? 'Explorer',
                      avatarUrl: profile?.avatarUrl,
                      isEduVerified: profile?.isEduVerified ?? false,
                    ),
                    loading: () => const WelcomeHeader(
                      name: 'Loading...',
                      isEduVerified: false,
                    ),
                    error: (_, __) => const WelcomeHeader(
                      name: 'Explorer',
                      isEduVerified: false,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 28),

                  // Streak Card with Social Facilitation Psychology
                  // Streak Card with Social Facilitation Psychology
                  streakAsync.when(
                    data: (streak) => StreakCard(
                      streakData: streak,
                      isCheckingIn: isCheckingIn,
                      onCheckIn: () => ref.read(checkInNotifierProvider.notifier).checkIn(),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox.shrink(),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 28),

                  // Quick Actions Section
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryDark,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms),

                  const SizedBox(height: 16),

                  // Action Cards Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      QuickActionCard(
                        icon: Icons.play_circle_filled_rounded,
                        title: 'Start Session',
                        subtitle: 'Begin body doubling',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        onTap: () {
                          // TODO: Navigate to session
                        },
                      ),
                      QuickActionCard(
                        icon: Icons.group_add_rounded,
                        title: 'Find Squad',
                        subtitle: 'Join or create',
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryPurple, AppTheme.primaryIndigo],
                        ),
                        onTap: () {
                          // TODO: Navigate to squads
                        },
                      ),
                      QuickActionCard(
                        icon: Icons.insights_rounded,
                        title: 'Analytics',
                        subtitle: 'View your stats',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                        ),
                        onTap: () {
                          context.push(AppRoutes.leaderboard);
                        },
                      ),
                      QuickActionCard(
                        icon: Icons.chat_bubble_rounded,
                        title: 'Squad Chat',
                        subtitle: 'Message your team',
                        gradient: const LinearGradient(
                          colors: [AppTheme.accentCyan, Color(0xFF0891B2)],
                        ),
                        onTap: () {
                          // TODO: Navigate to chat
                        },
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
