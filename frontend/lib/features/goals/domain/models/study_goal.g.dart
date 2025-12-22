// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FocusBlockImpl _$$FocusBlockImplFromJson(Map<String, dynamic> json) =>
    _$FocusBlockImpl(
      start: json['start'] as String,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$$FocusBlockImplToJson(_$FocusBlockImpl instance) =>
    <String, dynamic>{
      'start': instance.start,
      'duration': instance.duration,
    };

_$DailyPlanImpl _$$DailyPlanImplFromJson(Map<String, dynamic> json) =>
    _$DailyPlanImpl(
      date: json['date'] as String,
      blocks: (json['blocks'] as List<dynamic>?)
              ?.map((e) => FocusBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DailyPlanImplToJson(_$DailyPlanImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'blocks': instance.blocks,
    };

_$AIScheduleImpl _$$AIScheduleImplFromJson(Map<String, dynamic> json) =>
    _$AIScheduleImpl(
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => DailyPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dailyTargetMins: (json['daily_target_mins'] as num?)?.toInt(),
      bufferHours: (json['buffer_hours'] as num?)?.toInt(),
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$$AIScheduleImplToJson(_$AIScheduleImpl instance) =>
    <String, dynamic>{
      'days': instance.days,
      'daily_target_mins': instance.dailyTargetMins,
      'buffer_hours': instance.bufferHours,
      'generated_at': instance.generatedAt?.toIso8601String(),
    };

_$StudyGoalImpl _$$StudyGoalImplFromJson(Map<String, dynamic> json) =>
    _$StudyGoalImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      targetHours: (json['target_hours'] as num).toInt(),
      completedMinutes: (json['completed_minutes'] as num?)?.toInt() ?? 0,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: $enumDecodeNullable(_$GoalPriorityEnumMap, json['priority']) ??
          GoalPriority.medium,
      status: $enumDecodeNullable(_$GoalStatusEnumMap, json['status']) ??
          GoalStatus.active,
      aiSchedule: json['ai_schedule'] == null
          ? null
          : AISchedule.fromJson(json['ai_schedule'] as Map<String, dynamic>),
      aiScheduleGenerated: json['ai_schedule_generated'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StudyGoalImplToJson(_$StudyGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'target_hours': instance.targetHours,
      'completed_minutes': instance.completedMinutes,
      'deadline': instance.deadline.toIso8601String(),
      'priority': _$GoalPriorityEnumMap[instance.priority]!,
      'status': _$GoalStatusEnumMap[instance.status]!,
      'ai_schedule': instance.aiSchedule,
      'ai_schedule_generated': instance.aiScheduleGenerated,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$GoalPriorityEnumMap = {
  GoalPriority.high: 1,
  GoalPriority.medium: 2,
  GoalPriority.low: 3,
};

const _$GoalStatusEnumMap = {
  GoalStatus.active: 'active',
  GoalStatus.completed: 'completed',
  GoalStatus.expired: 'expired',
  GoalStatus.archived: 'archived',
};

_$CreateGoalRequestImpl _$$CreateGoalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateGoalRequestImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      targetHours: (json['target_hours'] as num).toInt(),
      deadline: json['deadline'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$$CreateGoalRequestImplToJson(
        _$CreateGoalRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'target_hours': instance.targetHours,
      'deadline': instance.deadline,
      'priority': instance.priority,
    };

_$GoalsListResponseImpl _$$GoalsListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GoalsListResponseImpl(
      goals: (json['goals'] as List<dynamic>)
          .map((e) => StudyGoal.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
    );

Map<String, dynamic> _$$GoalsListResponseImplToJson(
        _$GoalsListResponseImpl instance) =>
    <String, dynamic>{
      'goals': instance.goals,
      'total_count': instance.totalCount,
    };
