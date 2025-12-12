import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/streak_repository_impl.dart';
import '../../domain/models/streak_models.dart';
import '../../domain/repositories/streak_repository.dart';

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return StreakRepositoryImpl();
});

final currentUserStreakProvider = FutureProvider<StreakData>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  // Using autodispose? Probably should, but sticking to basic for now.
  // Ideally, invalidate this on check-in.
  return repo.getMyStreak();
});

final streakLeaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  return repo.getLeaderboard();
});

final streakHistoryProvider = FutureProvider<List<ActivityDay>>((ref) async {
  // Return history from the current user streak
  final streakData = await ref.watch(currentUserStreakProvider.future);
  return streakData.history;
});

final checkInNotifierProvider = StateNotifierProvider<CheckInNotifier, AsyncValue<void>>((ref) {
  return CheckInNotifier(ref);
});

class CheckInNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  CheckInNotifier(this._ref) : super(const AsyncData(null));

  Future<void> checkIn() async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(streakRepositoryProvider);
      await repo.logActivity('manual_checkin');
      
      // Invalidate streak provider to refresh UI
      _ref.invalidate(currentUserStreakProvider);
      
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
