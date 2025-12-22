/// Focus Stats Models
/// 
/// Aggregated focus statistics for dashboard display

import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_stats.freezed.dart';
part 'focus_stats.g.dart';

/// User focus statistics
@freezed
class FocusStats with _$FocusStats {
  const FocusStats._();

  const factory FocusStats({
    @JsonKey(name: 'total_minutes_this_week') @Default(0) int totalMinutesThisWeek,
    @JsonKey(name: 'total_minutes_all_time') @Default(0) int totalMinutesAllTime,
    @JsonKey(name: 'avg_session_mins') @Default(0) int avgSessionMins,
    @JsonKey(name: 'total_sessions') @Default(0) int totalSessions,
    @JsonKey(name: 'sessions_this_week') @Default(0) int sessionsThisWeek,
    @JsonKey(name: 'best_focus_time') @Default('') String bestFocusTime,
    @JsonKey(name: 'longest_session_mins') @Default(0) int longestSessionMins,
  }) = _FocusStats;

  factory FocusStats.fromJson(Map<String, dynamic> json) => _$FocusStatsFromJson(json);

  /// Format total hours this week
  String get hoursThisWeekFormatted {
    final hours = totalMinutesThisWeek ~/ 60;
    final mins = totalMinutesThisWeek % 60;
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  /// Format average session
  String get avgSessionFormatted {
    if (avgSessionMins == 0) return '--';
    return '${avgSessionMins}m';
  }
}

/// Squad member focus stats
@freezed  
class MemberFocusStat with _$MemberFocusStat {
  const factory MemberFocusStat({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'minutes_this_week') @Default(0) int minutesThisWeek,
    @JsonKey(name: 'sessions_this_week') @Default(0) int sessionsThisWeek,
    @JsonKey(name: 'is_focusing') @Default(false) bool isFocusing,
    @JsonKey(name: 'current_session_mins') @Default(0) int currentSessionMins,
  }) = _MemberFocusStat;

  factory MemberFocusStat.fromJson(Map<String, dynamic> json) => _$MemberFocusStatFromJson(json);
}

/// Squad focus statistics
@freezed
class SquadFocusStats with _$SquadFocusStats {
  const SquadFocusStats._();

  const factory SquadFocusStats({
    @JsonKey(name: 'squad_id') required String squadId,
    @JsonKey(name: 'total_minutes_this_week') @Default(0) int totalMinutesThisWeek,
    @JsonKey(name: 'avg_member_minutes') @Default(0) int avgMemberMinutes,
    @JsonKey(name: 'member_stats') @Default([]) List<MemberFocusStat> memberStats,
  }) = _SquadFocusStats;

  factory SquadFocusStats.fromJson(Map<String, dynamic> json) => _$SquadFocusStatsFromJson(json);

  /// Get members currently focusing
  List<MemberFocusStat> get focusingMembers => 
      memberStats.where((m) => m.isFocusing).toList();
}

/// Session insight types
enum InsightType {
  pattern,
  comparison,
  milestone,
  recommendation,
}

/// AI-generated session insight
@freezed
class SessionInsight with _$SessionInsight {
  const factory SessionInsight({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'goal_id') String? goalId,
    @JsonKey(name: 'insight_type') required InsightType insightType,
    @JsonKey(name: 'insight_text') required String insightText,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _SessionInsight;

  factory SessionInsight.fromJson(Map<String, dynamic> json) => _$SessionInsightFromJson(json);
}

/// Focus stats response wrapper
@freezed
class FocusStatsResponse with _$FocusStatsResponse {
  const factory FocusStatsResponse({
    required FocusStats stats,
  }) = _FocusStatsResponse;

  factory FocusStatsResponse.fromJson(Map<String, dynamic> json) => _$FocusStatsResponseFromJson(json);
}

/// Insights list response
@freezed
class InsightsListResponse with _$InsightsListResponse {
  const factory InsightsListResponse({
    required List<SessionInsight> insights,
    @JsonKey(name: 'total_count') required int totalCount,
  }) = _InsightsListResponse;

  factory InsightsListResponse.fromJson(Map<String, dynamic> json) => _$InsightsListResponseFromJson(json);
}
