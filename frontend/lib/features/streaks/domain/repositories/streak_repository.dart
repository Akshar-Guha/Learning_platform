import '../models/streak_models.dart';

abstract class StreakRepository {
  Future<StreakData> getMyStreak();
  Future<StreakData> getUserStreak(String userId);
  Future<List<LeaderboardEntry>> getLeaderboard();
  Future<StreakData> logActivity(String activityType);
}
