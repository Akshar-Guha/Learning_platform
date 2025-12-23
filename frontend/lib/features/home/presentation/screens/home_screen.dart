import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../goals/presentation/providers/goals_providers.dart';
import '../../../goals/presentation/widgets/active_goal_card.dart';
import '../../../goals/presentation/widgets/focus_stats_card.dart';
import '../../../goals/presentation/widgets/latest_insight_card.dart';
import '../../../goals/presentation/widgets/primary_focus_card.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../streaks/presentation/providers/streak_providers.dart';
import '../../../streaks/presentation/widgets/streak_widgets.dart';
import '../widgets/welcome_header.dart';

/// Home Screen - Purpose-driven dashboard with focus as primary action
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final streakAsync = ref.watch(currentUserStreakProvider);
    final goalsAsync = ref.watch(userGoalsProvider);
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
              ref.invalidate(currentUserStreakProvider);
              ref.invalidate(userGoalsProvider);
              ref.invalidate(myFocusStatsProvider);
              ref.invalidate(recentInsightsProvider);
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
                      onTap: () => context.push(AppRoutes.profile),
                    ),
                    loading: () => const WelcomeHeader(
                      name: 'Loading...',
                      isEduVerified: false,
                    ),
                    error: (_, __) => const WelcomeHeader(
                      name: 'Explorer',
                      isEduVerified: false,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Primary Focus Card - Main CTA
                  const PrimaryFocusCard(),

                  const SizedBox(height: 24),

                  // Focus Stats Card
                  const FocusStatsCard(),

                  const SizedBox(height: 24),

                  // Active Goals Section
                  goalsAsync.when(
                    data: (goals) {
                      if (goals.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Active Goals',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimaryDark,
                                ),
                              ),
                              Text(
                                '${goals.length}/5',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondaryDark.withOpacity(0.7),
                                ),
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 200.ms),
                          const SizedBox(height: 12),
                          ...goals.take(2).map((goal) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ActiveGoalCard(
                                  goal: goal,
                                  onTap: () {
                                    // TODO: Navigate to goal detail
                                  },
                                  onGenerateSchedule: !goal.aiScheduleGenerated
                                      ? () async {
                                          await ref
                                              .read(generateScheduleNotifierProvider.notifier)
                                              .generateSchedule(goal.id);
                                        }
                                      : null,
                                ),
                              )),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 16),

                  // Latest AI Insight
                  const LatestInsightCard(),

                  const SizedBox(height: 20),

                  // Streak Card (kept from original)
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
