// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FocusBlock _$FocusBlockFromJson(Map<String, dynamic> json) {
  return _FocusBlock.fromJson(json);
}

/// @nodoc
mixin _$FocusBlock {
  String get start => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;

  /// Serializes this FocusBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusBlockCopyWith<FocusBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusBlockCopyWith<$Res> {
  factory $FocusBlockCopyWith(
          FocusBlock value, $Res Function(FocusBlock) then) =
      _$FocusBlockCopyWithImpl<$Res, FocusBlock>;
  @useResult
  $Res call({String start, int duration});
}

/// @nodoc
class _$FocusBlockCopyWithImpl<$Res, $Val extends FocusBlock>
    implements $FocusBlockCopyWith<$Res> {
  _$FocusBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FocusBlockImplCopyWith<$Res>
    implements $FocusBlockCopyWith<$Res> {
  factory _$$FocusBlockImplCopyWith(
          _$FocusBlockImpl value, $Res Function(_$FocusBlockImpl) then) =
      __$$FocusBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String start, int duration});
}

/// @nodoc
class __$$FocusBlockImplCopyWithImpl<$Res>
    extends _$FocusBlockCopyWithImpl<$Res, _$FocusBlockImpl>
    implements _$$FocusBlockImplCopyWith<$Res> {
  __$$FocusBlockImplCopyWithImpl(
      _$FocusBlockImpl _value, $Res Function(_$FocusBlockImpl) _then)
      : super(_value, _then);

  /// Create a copy of FocusBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? duration = null,
  }) {
    return _then(_$FocusBlockImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusBlockImpl implements _FocusBlock {
  const _$FocusBlockImpl({required this.start, required this.duration});

  factory _$FocusBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusBlockImplFromJson(json);

  @override
  final String start;
  @override
  final int duration;

  @override
  String toString() {
    return 'FocusBlock(start: $start, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusBlockImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, duration);

  /// Create a copy of FocusBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusBlockImplCopyWith<_$FocusBlockImpl> get copyWith =>
      __$$FocusBlockImplCopyWithImpl<_$FocusBlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusBlockImplToJson(
      this,
    );
  }
}

abstract class _FocusBlock implements FocusBlock {
  const factory _FocusBlock(
      {required final String start,
      required final int duration}) = _$FocusBlockImpl;

  factory _FocusBlock.fromJson(Map<String, dynamic> json) =
      _$FocusBlockImpl.fromJson;

  @override
  String get start;
  @override
  int get duration;

  /// Create a copy of FocusBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusBlockImplCopyWith<_$FocusBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyPlan _$DailyPlanFromJson(Map<String, dynamic> json) {
  return _DailyPlan.fromJson(json);
}

/// @nodoc
mixin _$DailyPlan {
  String get date => throw _privateConstructorUsedError;
  List<FocusBlock> get blocks => throw _privateConstructorUsedError;

  /// Serializes this DailyPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyPlanCopyWith<DailyPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyPlanCopyWith<$Res> {
  factory $DailyPlanCopyWith(DailyPlan value, $Res Function(DailyPlan) then) =
      _$DailyPlanCopyWithImpl<$Res, DailyPlan>;
  @useResult
  $Res call({String date, List<FocusBlock> blocks});
}

/// @nodoc
class _$DailyPlanCopyWithImpl<$Res, $Val extends DailyPlan>
    implements $DailyPlanCopyWith<$Res> {
  _$DailyPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? blocks = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      blocks: null == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<FocusBlock>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyPlanImplCopyWith<$Res>
    implements $DailyPlanCopyWith<$Res> {
  factory _$$DailyPlanImplCopyWith(
          _$DailyPlanImpl value, $Res Function(_$DailyPlanImpl) then) =
      __$$DailyPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, List<FocusBlock> blocks});
}

/// @nodoc
class __$$DailyPlanImplCopyWithImpl<$Res>
    extends _$DailyPlanCopyWithImpl<$Res, _$DailyPlanImpl>
    implements _$$DailyPlanImplCopyWith<$Res> {
  __$$DailyPlanImplCopyWithImpl(
      _$DailyPlanImpl _value, $Res Function(_$DailyPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? blocks = null,
  }) {
    return _then(_$DailyPlanImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      blocks: null == blocks
          ? _value._blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<FocusBlock>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyPlanImpl implements _DailyPlan {
  const _$DailyPlanImpl(
      {required this.date, final List<FocusBlock> blocks = const []})
      : _blocks = blocks;

  factory _$DailyPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyPlanImplFromJson(json);

  @override
  final String date;
  final List<FocusBlock> _blocks;
  @override
  @JsonKey()
  List<FocusBlock> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  @override
  String toString() {
    return 'DailyPlan(date: $date, blocks: $blocks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyPlanImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._blocks, _blocks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_blocks));

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyPlanImplCopyWith<_$DailyPlanImpl> get copyWith =>
      __$$DailyPlanImplCopyWithImpl<_$DailyPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyPlanImplToJson(
      this,
    );
  }
}

abstract class _DailyPlan implements DailyPlan {
  const factory _DailyPlan(
      {required final String date,
      final List<FocusBlock> blocks}) = _$DailyPlanImpl;

  factory _DailyPlan.fromJson(Map<String, dynamic> json) =
      _$DailyPlanImpl.fromJson;

  @override
  String get date;
  @override
  List<FocusBlock> get blocks;

  /// Create a copy of DailyPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyPlanImplCopyWith<_$DailyPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AISchedule _$AIScheduleFromJson(Map<String, dynamic> json) {
  return _AISchedule.fromJson(json);
}

/// @nodoc
mixin _$AISchedule {
  List<DailyPlan> get days => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_target_mins')
  int? get dailyTargetMins => throw _privateConstructorUsedError;
  @JsonKey(name: 'buffer_hours')
  int? get bufferHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this AISchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AISchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIScheduleCopyWith<AISchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIScheduleCopyWith<$Res> {
  factory $AIScheduleCopyWith(
          AISchedule value, $Res Function(AISchedule) then) =
      _$AIScheduleCopyWithImpl<$Res, AISchedule>;
  @useResult
  $Res call(
      {List<DailyPlan> days,
      @JsonKey(name: 'daily_target_mins') int? dailyTargetMins,
      @JsonKey(name: 'buffer_hours') int? bufferHours,
      @JsonKey(name: 'generated_at') DateTime? generatedAt});
}

/// @nodoc
class _$AIScheduleCopyWithImpl<$Res, $Val extends AISchedule>
    implements $AIScheduleCopyWith<$Res> {
  _$AIScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AISchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? dailyTargetMins = freezed,
    Object? bufferHours = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DailyPlan>,
      dailyTargetMins: freezed == dailyTargetMins
          ? _value.dailyTargetMins
          : dailyTargetMins // ignore: cast_nullable_to_non_nullable
              as int?,
      bufferHours: freezed == bufferHours
          ? _value.bufferHours
          : bufferHours // ignore: cast_nullable_to_non_nullable
              as int?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIScheduleImplCopyWith<$Res>
    implements $AIScheduleCopyWith<$Res> {
  factory _$$AIScheduleImplCopyWith(
          _$AIScheduleImpl value, $Res Function(_$AIScheduleImpl) then) =
      __$$AIScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<DailyPlan> days,
      @JsonKey(name: 'daily_target_mins') int? dailyTargetMins,
      @JsonKey(name: 'buffer_hours') int? bufferHours,
      @JsonKey(name: 'generated_at') DateTime? generatedAt});
}

/// @nodoc
class __$$AIScheduleImplCopyWithImpl<$Res>
    extends _$AIScheduleCopyWithImpl<$Res, _$AIScheduleImpl>
    implements _$$AIScheduleImplCopyWith<$Res> {
  __$$AIScheduleImplCopyWithImpl(
      _$AIScheduleImpl _value, $Res Function(_$AIScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of AISchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? dailyTargetMins = freezed,
    Object? bufferHours = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(_$AIScheduleImpl(
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DailyPlan>,
      dailyTargetMins: freezed == dailyTargetMins
          ? _value.dailyTargetMins
          : dailyTargetMins // ignore: cast_nullable_to_non_nullable
              as int?,
      bufferHours: freezed == bufferHours
          ? _value.bufferHours
          : bufferHours // ignore: cast_nullable_to_non_nullable
              as int?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIScheduleImpl implements _AISchedule {
  const _$AIScheduleImpl(
      {final List<DailyPlan> days = const [],
      @JsonKey(name: 'daily_target_mins') this.dailyTargetMins,
      @JsonKey(name: 'buffer_hours') this.bufferHours,
      @JsonKey(name: 'generated_at') this.generatedAt})
      : _days = days;

  factory _$AIScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIScheduleImplFromJson(json);

  final List<DailyPlan> _days;
  @override
  @JsonKey()
  List<DailyPlan> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  @JsonKey(name: 'daily_target_mins')
  final int? dailyTargetMins;
  @override
  @JsonKey(name: 'buffer_hours')
  final int? bufferHours;
  @override
  @JsonKey(name: 'generated_at')
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'AISchedule(days: $days, dailyTargetMins: $dailyTargetMins, bufferHours: $bufferHours, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIScheduleImpl &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.dailyTargetMins, dailyTargetMins) ||
                other.dailyTargetMins == dailyTargetMins) &&
            (identical(other.bufferHours, bufferHours) ||
                other.bufferHours == bufferHours) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_days),
      dailyTargetMins,
      bufferHours,
      generatedAt);

  /// Create a copy of AISchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIScheduleImplCopyWith<_$AIScheduleImpl> get copyWith =>
      __$$AIScheduleImplCopyWithImpl<_$AIScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIScheduleImplToJson(
      this,
    );
  }
}

abstract class _AISchedule implements AISchedule {
  const factory _AISchedule(
          {final List<DailyPlan> days,
          @JsonKey(name: 'daily_target_mins') final int? dailyTargetMins,
          @JsonKey(name: 'buffer_hours') final int? bufferHours,
          @JsonKey(name: 'generated_at') final DateTime? generatedAt}) =
      _$AIScheduleImpl;

  factory _AISchedule.fromJson(Map<String, dynamic> json) =
      _$AIScheduleImpl.fromJson;

  @override
  List<DailyPlan> get days;
  @override
  @JsonKey(name: 'daily_target_mins')
  int? get dailyTargetMins;
  @override
  @JsonKey(name: 'buffer_hours')
  int? get bufferHours;
  @override
  @JsonKey(name: 'generated_at')
  DateTime? get generatedAt;

  /// Create a copy of AISchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIScheduleImplCopyWith<_$AIScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StudyGoal _$StudyGoalFromJson(Map<String, dynamic> json) {
  return _StudyGoal.fromJson(json);
}

/// @nodoc
mixin _$StudyGoal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_hours')
  int get targetHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_minutes')
  int get completedMinutes => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  GoalPriority get priority => throw _privateConstructorUsedError;
  GoalStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_schedule')
  AISchedule? get aiSchedule => throw _privateConstructorUsedError;
  @JsonKey(name: 'ai_schedule_generated')
  bool get aiScheduleGenerated => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StudyGoal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudyGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyGoalCopyWith<StudyGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyGoalCopyWith<$Res> {
  factory $StudyGoalCopyWith(StudyGoal value, $Res Function(StudyGoal) then) =
      _$StudyGoalCopyWithImpl<$Res, StudyGoal>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      String? description,
      @JsonKey(name: 'target_hours') int targetHours,
      @JsonKey(name: 'completed_minutes') int completedMinutes,
      DateTime deadline,
      GoalPriority priority,
      GoalStatus status,
      @JsonKey(name: 'ai_schedule') AISchedule? aiSchedule,
      @JsonKey(name: 'ai_schedule_generated') bool aiScheduleGenerated,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  $AIScheduleCopyWith<$Res>? get aiSchedule;
}

/// @nodoc
class _$StudyGoalCopyWithImpl<$Res, $Val extends StudyGoal>
    implements $StudyGoalCopyWith<$Res> {
  _$StudyGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetHours = null,
    Object? completedMinutes = null,
    Object? deadline = null,
    Object? priority = null,
    Object? status = null,
    Object? aiSchedule = freezed,
    Object? aiScheduleGenerated = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHours: null == targetHours
          ? _value.targetHours
          : targetHours // ignore: cast_nullable_to_non_nullable
              as int,
      completedMinutes: null == completedMinutes
          ? _value.completedMinutes
          : completedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as GoalPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GoalStatus,
      aiSchedule: freezed == aiSchedule
          ? _value.aiSchedule
          : aiSchedule // ignore: cast_nullable_to_non_nullable
              as AISchedule?,
      aiScheduleGenerated: null == aiScheduleGenerated
          ? _value.aiScheduleGenerated
          : aiScheduleGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of StudyGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIScheduleCopyWith<$Res>? get aiSchedule {
    if (_value.aiSchedule == null) {
      return null;
    }

    return $AIScheduleCopyWith<$Res>(_value.aiSchedule!, (value) {
      return _then(_value.copyWith(aiSchedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudyGoalImplCopyWith<$Res>
    implements $StudyGoalCopyWith<$Res> {
  factory _$$StudyGoalImplCopyWith(
          _$StudyGoalImpl value, $Res Function(_$StudyGoalImpl) then) =
      __$$StudyGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      String? description,
      @JsonKey(name: 'target_hours') int targetHours,
      @JsonKey(name: 'completed_minutes') int completedMinutes,
      DateTime deadline,
      GoalPriority priority,
      GoalStatus status,
      @JsonKey(name: 'ai_schedule') AISchedule? aiSchedule,
      @JsonKey(name: 'ai_schedule_generated') bool aiScheduleGenerated,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  @override
  $AIScheduleCopyWith<$Res>? get aiSchedule;
}

/// @nodoc
class __$$StudyGoalImplCopyWithImpl<$Res>
    extends _$StudyGoalCopyWithImpl<$Res, _$StudyGoalImpl>
    implements _$$StudyGoalImplCopyWith<$Res> {
  __$$StudyGoalImplCopyWithImpl(
      _$StudyGoalImpl _value, $Res Function(_$StudyGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of StudyGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? targetHours = null,
    Object? completedMinutes = null,
    Object? deadline = null,
    Object? priority = null,
    Object? status = null,
    Object? aiSchedule = freezed,
    Object? aiScheduleGenerated = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$StudyGoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHours: null == targetHours
          ? _value.targetHours
          : targetHours // ignore: cast_nullable_to_non_nullable
              as int,
      completedMinutes: null == completedMinutes
          ? _value.completedMinutes
          : completedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as GoalPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GoalStatus,
      aiSchedule: freezed == aiSchedule
          ? _value.aiSchedule
          : aiSchedule // ignore: cast_nullable_to_non_nullable
              as AISchedule?,
      aiScheduleGenerated: null == aiScheduleGenerated
          ? _value.aiScheduleGenerated
          : aiScheduleGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudyGoalImpl extends _StudyGoal {
  const _$StudyGoalImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      this.description,
      @JsonKey(name: 'target_hours') required this.targetHours,
      @JsonKey(name: 'completed_minutes') this.completedMinutes = 0,
      required this.deadline,
      this.priority = GoalPriority.medium,
      this.status = GoalStatus.active,
      @JsonKey(name: 'ai_schedule') this.aiSchedule,
      @JsonKey(name: 'ai_schedule_generated') this.aiScheduleGenerated = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$StudyGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudyGoalImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_hours')
  final int targetHours;
  @override
  @JsonKey(name: 'completed_minutes')
  final int completedMinutes;
  @override
  final DateTime deadline;
  @override
  @JsonKey()
  final GoalPriority priority;
  @override
  @JsonKey()
  final GoalStatus status;
  @override
  @JsonKey(name: 'ai_schedule')
  final AISchedule? aiSchedule;
  @override
  @JsonKey(name: 'ai_schedule_generated')
  final bool aiScheduleGenerated;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StudyGoal(id: $id, userId: $userId, title: $title, description: $description, targetHours: $targetHours, completedMinutes: $completedMinutes, deadline: $deadline, priority: $priority, status: $status, aiSchedule: $aiSchedule, aiScheduleGenerated: $aiScheduleGenerated, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetHours, targetHours) ||
                other.targetHours == targetHours) &&
            (identical(other.completedMinutes, completedMinutes) ||
                other.completedMinutes == completedMinutes) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.aiSchedule, aiSchedule) ||
                other.aiSchedule == aiSchedule) &&
            (identical(other.aiScheduleGenerated, aiScheduleGenerated) ||
                other.aiScheduleGenerated == aiScheduleGenerated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      description,
      targetHours,
      completedMinutes,
      deadline,
      priority,
      status,
      aiSchedule,
      aiScheduleGenerated,
      createdAt,
      updatedAt);

  /// Create a copy of StudyGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyGoalImplCopyWith<_$StudyGoalImpl> get copyWith =>
      __$$StudyGoalImplCopyWithImpl<_$StudyGoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudyGoalImplToJson(
      this,
    );
  }
}

abstract class _StudyGoal extends StudyGoal {
  const factory _StudyGoal(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String title,
      final String? description,
      @JsonKey(name: 'target_hours') required final int targetHours,
      @JsonKey(name: 'completed_minutes') final int completedMinutes,
      required final DateTime deadline,
      final GoalPriority priority,
      final GoalStatus status,
      @JsonKey(name: 'ai_schedule') final AISchedule? aiSchedule,
      @JsonKey(name: 'ai_schedule_generated') final bool aiScheduleGenerated,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$StudyGoalImpl;
  const _StudyGoal._() : super._();

  factory _StudyGoal.fromJson(Map<String, dynamic> json) =
      _$StudyGoalImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_hours')
  int get targetHours;
  @override
  @JsonKey(name: 'completed_minutes')
  int get completedMinutes;
  @override
  DateTime get deadline;
  @override
  GoalPriority get priority;
  @override
  GoalStatus get status;
  @override
  @JsonKey(name: 'ai_schedule')
  AISchedule? get aiSchedule;
  @override
  @JsonKey(name: 'ai_schedule_generated')
  bool get aiScheduleGenerated;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of StudyGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyGoalImplCopyWith<_$StudyGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateGoalRequest _$CreateGoalRequestFromJson(Map<String, dynamic> json) {
  return _CreateGoalRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateGoalRequest {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_hours')
  int get targetHours => throw _privateConstructorUsedError;
  String get deadline => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;

  /// Serializes this CreateGoalRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateGoalRequestCopyWith<CreateGoalRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGoalRequestCopyWith<$Res> {
  factory $CreateGoalRequestCopyWith(
          CreateGoalRequest value, $Res Function(CreateGoalRequest) then) =
      _$CreateGoalRequestCopyWithImpl<$Res, CreateGoalRequest>;
  @useResult
  $Res call(
      {String title,
      String? description,
      @JsonKey(name: 'target_hours') int targetHours,
      String deadline,
      int priority});
}

/// @nodoc
class _$CreateGoalRequestCopyWithImpl<$Res, $Val extends CreateGoalRequest>
    implements $CreateGoalRequestCopyWith<$Res> {
  _$CreateGoalRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? targetHours = null,
    Object? deadline = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHours: null == targetHours
          ? _value.targetHours
          : targetHours // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateGoalRequestImplCopyWith<$Res>
    implements $CreateGoalRequestCopyWith<$Res> {
  factory _$$CreateGoalRequestImplCopyWith(_$CreateGoalRequestImpl value,
          $Res Function(_$CreateGoalRequestImpl) then) =
      __$$CreateGoalRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      @JsonKey(name: 'target_hours') int targetHours,
      String deadline,
      int priority});
}

/// @nodoc
class __$$CreateGoalRequestImplCopyWithImpl<$Res>
    extends _$CreateGoalRequestCopyWithImpl<$Res, _$CreateGoalRequestImpl>
    implements _$$CreateGoalRequestImplCopyWith<$Res> {
  __$$CreateGoalRequestImplCopyWithImpl(_$CreateGoalRequestImpl _value,
      $Res Function(_$CreateGoalRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? targetHours = null,
    Object? deadline = null,
    Object? priority = null,
  }) {
    return _then(_$CreateGoalRequestImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetHours: null == targetHours
          ? _value.targetHours
          : targetHours // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateGoalRequestImpl implements _CreateGoalRequest {
  const _$CreateGoalRequestImpl(
      {required this.title,
      this.description,
      @JsonKey(name: 'target_hours') required this.targetHours,
      required this.deadline,
      this.priority = 2});

  factory _$CreateGoalRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateGoalRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_hours')
  final int targetHours;
  @override
  final String deadline;
  @override
  @JsonKey()
  final int priority;

  @override
  String toString() {
    return 'CreateGoalRequest(title: $title, description: $description, targetHours: $targetHours, deadline: $deadline, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGoalRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetHours, targetHours) ||
                other.targetHours == targetHours) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, targetHours, deadline, priority);

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateGoalRequestImplCopyWith<_$CreateGoalRequestImpl> get copyWith =>
      __$$CreateGoalRequestImplCopyWithImpl<_$CreateGoalRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateGoalRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateGoalRequest implements CreateGoalRequest {
  const factory _CreateGoalRequest(
      {required final String title,
      final String? description,
      @JsonKey(name: 'target_hours') required final int targetHours,
      required final String deadline,
      final int priority}) = _$CreateGoalRequestImpl;

  factory _CreateGoalRequest.fromJson(Map<String, dynamic> json) =
      _$CreateGoalRequestImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_hours')
  int get targetHours;
  @override
  String get deadline;
  @override
  int get priority;

  /// Create a copy of CreateGoalRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateGoalRequestImplCopyWith<_$CreateGoalRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoalsListResponse _$GoalsListResponseFromJson(Map<String, dynamic> json) {
  return _GoalsListResponse.fromJson(json);
}

/// @nodoc
mixin _$GoalsListResponse {
  List<StudyGoal> get goals => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_count')
  int get totalCount => throw _privateConstructorUsedError;

  /// Serializes this GoalsListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoalsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalsListResponseCopyWith<GoalsListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalsListResponseCopyWith<$Res> {
  factory $GoalsListResponseCopyWith(
          GoalsListResponse value, $Res Function(GoalsListResponse) then) =
      _$GoalsListResponseCopyWithImpl<$Res, GoalsListResponse>;
  @useResult
  $Res call(
      {List<StudyGoal> goals, @JsonKey(name: 'total_count') int totalCount});
}

/// @nodoc
class _$GoalsListResponseCopyWithImpl<$Res, $Val extends GoalsListResponse>
    implements $GoalsListResponseCopyWith<$Res> {
  _$GoalsListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goals = null,
    Object? totalCount = null,
  }) {
    return _then(_value.copyWith(
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<StudyGoal>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalsListResponseImplCopyWith<$Res>
    implements $GoalsListResponseCopyWith<$Res> {
  factory _$$GoalsListResponseImplCopyWith(_$GoalsListResponseImpl value,
          $Res Function(_$GoalsListResponseImpl) then) =
      __$$GoalsListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<StudyGoal> goals, @JsonKey(name: 'total_count') int totalCount});
}

/// @nodoc
class __$$GoalsListResponseImplCopyWithImpl<$Res>
    extends _$GoalsListResponseCopyWithImpl<$Res, _$GoalsListResponseImpl>
    implements _$$GoalsListResponseImplCopyWith<$Res> {
  __$$GoalsListResponseImplCopyWithImpl(_$GoalsListResponseImpl _value,
      $Res Function(_$GoalsListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goals = null,
    Object? totalCount = null,
  }) {
    return _then(_$GoalsListResponseImpl(
      goals: null == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<StudyGoal>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalsListResponseImpl implements _GoalsListResponse {
  const _$GoalsListResponseImpl(
      {required final List<StudyGoal> goals,
      @JsonKey(name: 'total_count') required this.totalCount})
      : _goals = goals;

  factory _$GoalsListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalsListResponseImplFromJson(json);

  final List<StudyGoal> _goals;
  @override
  List<StudyGoal> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  @override
  @JsonKey(name: 'total_count')
  final int totalCount;

  @override
  String toString() {
    return 'GoalsListResponse(goals: $goals, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalsListResponseImpl &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_goals), totalCount);

  /// Create a copy of GoalsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalsListResponseImplCopyWith<_$GoalsListResponseImpl> get copyWith =>
      __$$GoalsListResponseImplCopyWithImpl<_$GoalsListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalsListResponseImplToJson(
      this,
    );
  }
}

abstract class _GoalsListResponse implements GoalsListResponse {
  const factory _GoalsListResponse(
          {required final List<StudyGoal> goals,
          @JsonKey(name: 'total_count') required final int totalCount}) =
      _$GoalsListResponseImpl;

  factory _GoalsListResponse.fromJson(Map<String, dynamic> json) =
      _$GoalsListResponseImpl.fromJson;

  @override
  List<StudyGoal> get goals;
  @override
  @JsonKey(name: 'total_count')
  int get totalCount;

  /// Create a copy of GoalsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalsListResponseImplCopyWith<_$GoalsListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
