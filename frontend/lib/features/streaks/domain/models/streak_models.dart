import 'package:equatable/equatable.dart';

class StreakData extends Equatable {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final int consistencyScore;
  final int totalActiveDays;
  final List<ActivityDay> history;

  const StreakData({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActiveDate,
    required this.consistencyScore,
    required this.totalActiveDays,
    required this.history,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      userId: json['user_id'] as String,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActiveDate: json['last_active_date'] != null
          ? DateTime.parse(json['last_active_date'] as String)
          : null,
      consistencyScore: json['consistency_score'] as int? ?? 0,
      totalActiveDays: json['total_active_days'] as int? ?? 0,
      history: (json['streak_history'] as List<dynamic>?)
              ?.map((e) => ActivityDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_active_date': lastActiveDate?.toIso8601String(),
      'consistency_score': consistencyScore,
      'total_active_days': totalActiveDays,
      'streak_history': history.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        userId,
        currentStreak,
        longestStreak,
        lastActiveDate,
        consistencyScore,
        totalActiveDays,
        history,
      ];
}

class ActivityDay extends Equatable {
  final DateTime date;
  final bool isActive;

  const ActivityDay({
    required this.date,
    required this.isActive,
  });

  factory ActivityDay.fromJson(Map<String, dynamic> json) {
    return ActivityDay(
      date: DateTime.parse(json['date'] as String),
      isActive: json['active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'active': isActive,
    };
  }

  @override
  List<Object?> get props => [date, isActive];
}

class LeaderboardEntry extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int currentStreak;
  final int consistencyScore;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.currentStreak,
    required this.consistencyScore,
    this.rank = 0,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String? ?? 'Unknown',
      avatarUrl: json['avatar_url'] as String?,
      currentStreak: json['current_streak'] as int? ?? 0,
      consistencyScore: json['consistency_score'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'current_streak': currentStreak,
      'consistency_score': consistencyScore,
      'rank': rank,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        displayName,
        avatarUrl,
        currentStreak,
        consistencyScore,
        rank,
      ];
}
