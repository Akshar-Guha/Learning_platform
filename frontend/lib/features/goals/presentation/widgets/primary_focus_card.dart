/// Primary Focus Card Widget
/// 
/// Large "Start Focus" CTA card with goal and squad selection

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../squads/presentation/providers/squad_providers.dart';
import '../../domain/models/study_goal.dart';
import '../providers/goals_providers.dart';

class PrimaryFocusCard extends ConsumerWidget {
  const PrimaryFocusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(userGoalsProvider);
    final selectedGoal = ref.watch(selectedGoalForFocusProvider);
    final squadsAsync = ref.watch(userSquadsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Iconsax.activity,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Focus?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Start a body doubling session',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Goal selector (if goals exist)
          goalsAsync.when(
            data: (goals) {
              if (goals.isEmpty) return const SizedBox.shrink();
              return _buildGoalSelector(context, ref, goals, selectedGoal);
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 20),

          // Start Focus Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to focus room
                squadsAsync.when(
                  data: (squads) {
                    if (squads.isNotEmpty) {
                      // Navigate to focus room (unified flow)
                      context.go(AppRoutes.focus);
                    } else {
                      // Show snackbar to join squad first
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Join a squad first to start focusing!'),
                          backgroundColor: AppTheme.warning,
                        ),
                      );
                    }
                  },
                  loading: () {},
                  error: (_, __) {},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.play_circle, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Start Focus Session',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.15, end: 0)
        .shimmer(duration: 1500.ms, delay: 300.ms, color: Colors.white24);
  }

  Widget _buildGoalSelector(
    BuildContext context,
    WidgetRef ref,
    List<StudyGoal> goals,
    StudyGoal? selectedGoal,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.flag,
            size: 18,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StudyGoal?>(
                value: selectedGoal,
                isExpanded: true,
                icon: Icon(
                  Iconsax.arrow_down_1,
                  size: 18,
                  color: Colors.white.withOpacity(0.8),
                ),
                dropdownColor: const Color(0xFF059669),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                hint: Text(
                  'Select goal (optional)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                items: [
                  const DropdownMenuItem<StudyGoal?>(
                    value: null,
                    child: Text('No specific goal'),
                  ),
                  ...goals.map((goal) => DropdownMenuItem<StudyGoal>(
                        value: goal,
                        child: Text(
                          goal.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                ],
                onChanged: (goal) {
                  ref.read(selectedGoalForFocusProvider.notifier).state = goal;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
