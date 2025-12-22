// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FocusStatsImpl _$$FocusStatsImplFromJson(Map<String, dynamic> json) =>
    _$FocusStatsImpl(
      totalMinutesThisWeek:
          (json['total_minutes_this_week'] as num?)?.toInt() ?? 0,
      totalMinutesAllTime:
          (json['total_minutes_all_time'] as num?)?.toInt() ?? 0,
      avgSessionMins: (json['avg_session_mins'] as num?)?.toInt() ?? 0,
      totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
      sessionsThisWeek: (json['sessions_this_week'] as num?)?.toInt() ?? 0,
      bestFocusTime: json['best_focus_time'] as String? ?? '',
      longestSessionMins: (json['longest_session_mins'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FocusStatsImplToJson(_$FocusStatsImpl instance) =>
    <String, dynamic>{
      'total_minutes_this_week': instance.totalMinutesThisWeek,
      'total_minutes_all_time': instance.totalMinutesAllTime,
      'avg_session_mins': instance.avgSessionMins,
      'total_sessions': instance.totalSessions,
      'sessions_this_week': instance.sessionsThisWeek,
      'best_focus_time': instance.bestFocusTime,
      'longest_session_mins': instance.longestSessionMins,
    };

_$MemberFocusStatImpl _$$MemberFocusStatImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberFocusStatImpl(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      minutesThisWeek: (json['minutes_this_week'] as num?)?.toInt() ?? 0,
      sessionsThisWeek: (json['sessions_this_week'] as num?)?.toInt() ?? 0,
      isFocusing: json['is_focusing'] as bool? ?? false,
      currentSessionMins: (json['current_session_mins'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MemberFocusStatImplToJson(
        _$MemberFocusStatImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'minutes_this_week': instance.minutesThisWeek,
      'sessions_this_week': instance.sessionsThisWeek,
      'is_focusing': instance.isFocusing,
      'current_session_mins': instance.currentSessionMins,
    };

_$SquadFocusStatsImpl _$$SquadFocusStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$SquadFocusStatsImpl(
      squadId: json['squad_id'] as String,
      totalMinutesThisWeek:
          (json['total_minutes_this_week'] as num?)?.toInt() ?? 0,
      avgMemberMinutes: (json['avg_member_minutes'] as num?)?.toInt() ?? 0,
      memberStats: (json['member_stats'] as List<dynamic>?)
              ?.map((e) => MemberFocusStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SquadFocusStatsImplToJson(
        _$SquadFocusStatsImpl instance) =>
    <String, dynamic>{
      'squad_id': instance.squadId,
      'total_minutes_this_week': instance.totalMinutesThisWeek,
      'avg_member_minutes': instance.avgMemberMinutes,
      'member_stats': instance.memberStats,
    };

_$SessionInsightImpl _$$SessionInsightImplFromJson(Map<String, dynamic> json) =>
    _$SessionInsightImpl(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      userId: json['user_id'] as String,
      goalId: json['goal_id'] as String?,
      insightType: $enumDecode(_$InsightTypeEnumMap, json['insight_type']),
      insightText: json['insight_text'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SessionInsightImplToJson(
        _$SessionInsightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'user_id': instance.userId,
      'goal_id': instance.goalId,
      'insight_type': _$InsightTypeEnumMap[instance.insightType]!,
      'insight_text': instance.insightText,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$InsightTypeEnumMap = {
  InsightType.pattern: 'pattern',
  InsightType.comparison: 'comparison',
  InsightType.milestone: 'milestone',
  InsightType.recommendation: 'recommendation',
};

_$FocusStatsResponseImpl _$$FocusStatsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FocusStatsResponseImpl(
      stats: FocusStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FocusStatsResponseImplToJson(
        _$FocusStatsResponseImpl instance) =>
    <String, dynamic>{
      'stats': instance.stats,
    };

_$InsightsListResponseImpl _$$InsightsListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InsightsListResponseImpl(
      insights: (json['insights'] as List<dynamic>)
          .map((e) => SessionInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
    );

Map<String, dynamic> _$$InsightsListResponseImplToJson(
        _$InsightsListResponseImpl instance) =>
    <String, dynamic>{
      'insights': instance.insights,
      'total_count': instance.totalCount,
    };
