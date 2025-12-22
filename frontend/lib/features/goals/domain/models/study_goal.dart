/// Study Goal Model
/// 
/// Represents a user's study goal with optional AI-generated schedule

import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_goal.freezed.dart';
part 'study_goal.g.dart';

/// Goal priority levels
enum GoalPriority {
  @JsonValue(1)
  high,
  @JsonValue(2)
  medium,
  @JsonValue(3)
  low,
}

/// Goal status
enum GoalStatus {
  active,
  completed,
  expired,
  archived,
}

/// Focus block within a daily plan
@freezed
class FocusBlock with _$FocusBlock {
  const factory FocusBlock({
    required String start,
    required int duration,
  }) = _FocusBlock;

  factory FocusBlock.fromJson(Map<String, dynamic> json) => _$FocusBlockFromJson(json);
}

/// Daily plan within AI schedule
@freezed
class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    required String date,
    @Default([]) List<FocusBlock> blocks,
  }) = _DailyPlan;

  factory DailyPlan.fromJson(Map<String, dynamic> json) => _$DailyPlanFromJson(json);
}

/// AI-generated study schedule
@freezed
class AISchedule with _$AISchedule {
  const factory AISchedule({
    @Default([]) List<DailyPlan> days,
    @JsonKey(name: 'daily_target_mins') int? dailyTargetMins,
    @JsonKey(name: 'buffer_hours') int? bufferHours,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
  }) = _AISchedule;

  factory AISchedule.fromJson(Map<String, dynamic> json) => _$AIScheduleFromJson(json);
}

/// Study Goal
@freezed
class StudyGoal with _$StudyGoal {
  const StudyGoal._();

  const factory StudyGoal({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? description,
    @JsonKey(name: 'target_hours') required int targetHours,
    @JsonKey(name: 'completed_minutes') @Default(0) int completedMinutes,
    required DateTime deadline,
    @Default(GoalPriority.medium) GoalPriority priority,
    @Default(GoalStatus.active) GoalStatus status,
    @JsonKey(name: 'ai_schedule') AISchedule? aiSchedule,
    @JsonKey(name: 'ai_schedule_generated') @Default(false) bool aiScheduleGenerated,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _StudyGoal;

  factory StudyGoal.fromJson(Map<String, dynamic> json) => _$StudyGoalFromJson(json);

  /// Calculate progress as a value between 0.0 and 1.0
  double get progressPercent {
    if (targetHours <= 0) return 0;
    final targetMinutes = targetHours * 60;
    final progress = completedMinutes / targetMinutes;
    return progress > 1 ? 1 : progress;
  }

  /// Get completed hours (rounded)
  int get completedHours => (completedMinutes / 60).round();

  /// Calculate days remaining until deadline
  int get daysRemaining {
    final days = deadline.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  /// Check if goal is on track
  bool get isOnTrack {
    if (daysRemaining <= 0) return completedMinutes >= targetHours * 60;
    final requiredDailyMins = (targetHours * 60 - completedMinutes) / daysRemaining;
    return requiredDailyMins <= 240; // Max 4 hours per day is achievable
  }
}

/// Create goal request
@freezed
class CreateGoalRequest with _$CreateGoalRequest {
  const factory CreateGoalRequest({
    required String title,
    String? description,
    @JsonKey(name: 'target_hours') required int targetHours,
    required String deadline,
    @Default(2) int priority,
  }) = _CreateGoalRequest;

  factory CreateGoalRequest.fromJson(Map<String, dynamic> json) => _$CreateGoalRequestFromJson(json);
}

/// Goals list response
@freezed
class GoalsListResponse with _$GoalsListResponse {
  const factory GoalsListResponse({
    required List<StudyGoal> goals,
    @JsonKey(name: 'total_count') required int totalCount,
  }) = _GoalsListResponse;

  factory GoalsListResponse.fromJson(Map<String, dynamic> json) => _$GoalsListResponseFromJson(json);
}
