/// Goals Providers
/// 
/// Riverpod providers for goals and focus stats state management

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/study_goal.dart';
import '../../domain/models/focus_stats.dart';
import '../../domain/repositories/goals_repository.dart';

// =============================================================================
// GOALS PROVIDERS
// =============================================================================

/// Provider for user's active goals (Live Updates via Polling)
final userGoalsProvider = StreamProvider<List<StudyGoal>>((ref) async* {
  final repo = ref.watch(goalsRepositoryProvider);
  while (true) {
    yield await repo.getGoals(activeOnly: true);
    await Future.delayed(const Duration(seconds: 15));
  }
});

/// Provider for all goals (including completed/archived)
final allGoalsProvider = FutureProvider<List<StudyGoal>>((ref) async {
  final repo = ref.watch(goalsRepositoryProvider);
  return repo.getGoals(activeOnly: false);
});

/// Provider for a single goal by ID
final goalDetailProvider = FutureProvider.family<StudyGoal, String>((ref, goalId) async {
  final repo = ref.watch(goalsRepositoryProvider);
  return repo.getGoal(goalId);
});

// =============================================================================
// FOCUS STATS PROVIDERS
// =============================================================================

/// Provider for current user's focus statistics
final myFocusStatsProvider = StreamProvider<FocusStats>((ref) async* {
  final repo = ref.watch(goalsRepositoryProvider);
  while (true) {
    yield await repo.getMyStats();
    await Future.delayed(const Duration(seconds: 30));
  }
});

/// Provider for squad focus statistics
final squadFocusStatsProvider = FutureProvider.family<SquadFocusStats, String>((ref, squadId) async {
  final repo = ref.watch(goalsRepositoryProvider);
  return repo.getSquadStats(squadId);
});

/// Provider for recent AI insights
final recentInsightsProvider = StreamProvider<List<SessionInsight>>((ref) async* {
  final repo = ref.watch(goalsRepositoryProvider);
  while (true) {
    yield await repo.getRecentInsights();
    await Future.delayed(const Duration(seconds: 60));
  }
});

// =============================================================================
// CREATE GOAL NOTIFIER
// =============================================================================

/// State notifier for creating goals
class CreateGoalNotifier extends StateNotifier<AsyncValue<StudyGoal?>> {
  final GoalsRepository _repo;
  final Ref _ref;

  CreateGoalNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<bool> createGoal({
    required String title,
    String? description,
    required int targetHours,
    required DateTime deadline,
    int priority = 2,
  }) async {
    state = const AsyncValue.loading();

    try {
      final request = CreateGoalRequest(
        title: title,
        description: description,
        targetHours: targetHours,
        deadline: deadline.toIso8601String().split('T').first,
        priority: priority,
      );

      final goal = await _repo.createGoal(request);
      state = AsyncValue.data(goal);

      // Refresh goals list
      _ref.invalidate(userGoalsProvider);

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final createGoalNotifierProvider = StateNotifierProvider<CreateGoalNotifier, AsyncValue<StudyGoal?>>((ref) {
  final repo = ref.watch(goalsRepositoryProvider);
  return CreateGoalNotifier(repo, ref);
});

// =============================================================================
// GENERATE SCHEDULE NOTIFIER  
// =============================================================================

/// State notifier for generating AI schedule
class GenerateScheduleNotifier extends StateNotifier<AsyncValue<AISchedule?>> {
  final GoalsRepository _repo;
  final Ref _ref;

  GenerateScheduleNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));

  Future<bool> generateSchedule(String goalId) async {
    state = const AsyncValue.loading();

    try {
      final schedule = await _repo.generateSchedule(goalId);
      state = AsyncValue.data(schedule);

      // Refresh goal detail
      _ref.invalidate(goalDetailProvider(goalId));
      _ref.invalidate(userGoalsProvider);

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final generateScheduleNotifierProvider = StateNotifierProvider<GenerateScheduleNotifier, AsyncValue<AISchedule?>>((ref) {
  final repo = ref.watch(goalsRepositoryProvider);
  return GenerateScheduleNotifier(repo, ref);
});

// =============================================================================
// SELECTED GOAL FOR FOCUS (used when starting focus session)
// =============================================================================

/// Currently selected goal for focus session
final selectedGoalForFocusProvider = StateProvider<StudyGoal?>((ref) => null);
