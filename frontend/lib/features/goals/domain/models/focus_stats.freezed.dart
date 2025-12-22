// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FocusStats _$FocusStatsFromJson(Map<String, dynamic> json) {
  return _FocusStats.fromJson(json);
}

/// @nodoc
mixin _$FocusStats {
  @JsonKey(name: 'total_minutes_this_week')
  int get totalMinutesThisWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_minutes_all_time')
  int get totalMinutesAllTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_session_mins')
  int get avgSessionMins => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sessions')
  int get totalSessions => throw _privateConstructorUsedError;
  @JsonKey(name: 'sessions_this_week')
  int get sessionsThisWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_focus_time')
  String get bestFocusTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'longest_session_mins')
  int get longestSessionMins => throw _privateConstructorUsedError;

  /// Serializes this FocusStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusStatsCopyWith<FocusStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusStatsCopyWith<$Res> {
  factory $FocusStatsCopyWith(
          FocusStats value, $Res Function(FocusStats) then) =
      _$FocusStatsCopyWithImpl<$Res, FocusStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_minutes_this_week') int totalMinutesThisWeek,
      @JsonKey(name: 'total_minutes_all_time') int totalMinutesAllTime,
      @JsonKey(name: 'avg_session_mins') int avgSessionMins,
      @JsonKey(name: 'total_sessions') int totalSessions,
      @JsonKey(name: 'sessions_this_week') int sessionsThisWeek,
      @JsonKey(name: 'best_focus_time') String bestFocusTime,
      @JsonKey(name: 'longest_session_mins') int longestSessionMins});
}

/// @nodoc
class _$FocusStatsCopyWithImpl<$Res, $Val extends FocusStats>
    implements $FocusStatsCopyWith<$Res> {
  _$FocusStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMinutesThisWeek = null,
    Object? totalMinutesAllTime = null,
    Object? avgSessionMins = null,
    Object? totalSessions = null,
    Object? sessionsThisWeek = null,
    Object? bestFocusTime = null,
    Object? longestSessionMins = null,
  }) {
    return _then(_value.copyWith(
      totalMinutesThisWeek: null == totalMinutesThisWeek
          ? _value.totalMinutesThisWeek
          : totalMinutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutesAllTime: null == totalMinutesAllTime
          ? _value.totalMinutesAllTime
          : totalMinutesAllTime // ignore: cast_nullable_to_non_nullable
              as int,
      avgSessionMins: null == avgSessionMins
          ? _value.avgSessionMins
          : avgSessionMins // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      sessionsThisWeek: null == sessionsThisWeek
          ? _value.sessionsThisWeek
          : sessionsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      bestFocusTime: null == bestFocusTime
          ? _value.bestFocusTime
          : bestFocusTime // ignore: cast_nullable_to_non_nullable
              as String,
      longestSessionMins: null == longestSessionMins
          ? _value.longestSessionMins
          : longestSessionMins // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FocusStatsImplCopyWith<$Res>
    implements $FocusStatsCopyWith<$Res> {
  factory _$$FocusStatsImplCopyWith(
          _$FocusStatsImpl value, $Res Function(_$FocusStatsImpl) then) =
      __$$FocusStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_minutes_this_week') int totalMinutesThisWeek,
      @JsonKey(name: 'total_minutes_all_time') int totalMinutesAllTime,
      @JsonKey(name: 'avg_session_mins') int avgSessionMins,
      @JsonKey(name: 'total_sessions') int totalSessions,
      @JsonKey(name: 'sessions_this_week') int sessionsThisWeek,
      @JsonKey(name: 'best_focus_time') String bestFocusTime,
      @JsonKey(name: 'longest_session_mins') int longestSessionMins});
}

/// @nodoc
class __$$FocusStatsImplCopyWithImpl<$Res>
    extends _$FocusStatsCopyWithImpl<$Res, _$FocusStatsImpl>
    implements _$$FocusStatsImplCopyWith<$Res> {
  __$$FocusStatsImplCopyWithImpl(
      _$FocusStatsImpl _value, $Res Function(_$FocusStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMinutesThisWeek = null,
    Object? totalMinutesAllTime = null,
    Object? avgSessionMins = null,
    Object? totalSessions = null,
    Object? sessionsThisWeek = null,
    Object? bestFocusTime = null,
    Object? longestSessionMins = null,
  }) {
    return _then(_$FocusStatsImpl(
      totalMinutesThisWeek: null == totalMinutesThisWeek
          ? _value.totalMinutesThisWeek
          : totalMinutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutesAllTime: null == totalMinutesAllTime
          ? _value.totalMinutesAllTime
          : totalMinutesAllTime // ignore: cast_nullable_to_non_nullable
              as int,
      avgSessionMins: null == avgSessionMins
          ? _value.avgSessionMins
          : avgSessionMins // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      sessionsThisWeek: null == sessionsThisWeek
          ? _value.sessionsThisWeek
          : sessionsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      bestFocusTime: null == bestFocusTime
          ? _value.bestFocusTime
          : bestFocusTime // ignore: cast_nullable_to_non_nullable
              as String,
      longestSessionMins: null == longestSessionMins
          ? _value.longestSessionMins
          : longestSessionMins // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusStatsImpl extends _FocusStats {
  const _$FocusStatsImpl(
      {@JsonKey(name: 'total_minutes_this_week') this.totalMinutesThisWeek = 0,
      @JsonKey(name: 'total_minutes_all_time') this.totalMinutesAllTime = 0,
      @JsonKey(name: 'avg_session_mins') this.avgSessionMins = 0,
      @JsonKey(name: 'total_sessions') this.totalSessions = 0,
      @JsonKey(name: 'sessions_this_week') this.sessionsThisWeek = 0,
      @JsonKey(name: 'best_focus_time') this.bestFocusTime = '',
      @JsonKey(name: 'longest_session_mins') this.longestSessionMins = 0})
      : super._();

  factory _$FocusStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_minutes_this_week')
  final int totalMinutesThisWeek;
  @override
  @JsonKey(name: 'total_minutes_all_time')
  final int totalMinutesAllTime;
  @override
  @JsonKey(name: 'avg_session_mins')
  final int avgSessionMins;
  @override
  @JsonKey(name: 'total_sessions')
  final int totalSessions;
  @override
  @JsonKey(name: 'sessions_this_week')
  final int sessionsThisWeek;
  @override
  @JsonKey(name: 'best_focus_time')
  final String bestFocusTime;
  @override
  @JsonKey(name: 'longest_session_mins')
  final int longestSessionMins;

  @override
  String toString() {
    return 'FocusStats(totalMinutesThisWeek: $totalMinutesThisWeek, totalMinutesAllTime: $totalMinutesAllTime, avgSessionMins: $avgSessionMins, totalSessions: $totalSessions, sessionsThisWeek: $sessionsThisWeek, bestFocusTime: $bestFocusTime, longestSessionMins: $longestSessionMins)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusStatsImpl &&
            (identical(other.totalMinutesThisWeek, totalMinutesThisWeek) ||
                other.totalMinutesThisWeek == totalMinutesThisWeek) &&
            (identical(other.totalMinutesAllTime, totalMinutesAllTime) ||
                other.totalMinutesAllTime == totalMinutesAllTime) &&
            (identical(other.avgSessionMins, avgSessionMins) ||
                other.avgSessionMins == avgSessionMins) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.sessionsThisWeek, sessionsThisWeek) ||
                other.sessionsThisWeek == sessionsThisWeek) &&
            (identical(other.bestFocusTime, bestFocusTime) ||
                other.bestFocusTime == bestFocusTime) &&
            (identical(other.longestSessionMins, longestSessionMins) ||
                other.longestSessionMins == longestSessionMins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalMinutesThisWeek,
      totalMinutesAllTime,
      avgSessionMins,
      totalSessions,
      sessionsThisWeek,
      bestFocusTime,
      longestSessionMins);

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusStatsImplCopyWith<_$FocusStatsImpl> get copyWith =>
      __$$FocusStatsImplCopyWithImpl<_$FocusStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusStatsImplToJson(
      this,
    );
  }
}

abstract class _FocusStats extends FocusStats {
  const factory _FocusStats(
      {@JsonKey(name: 'total_minutes_this_week') final int totalMinutesThisWeek,
      @JsonKey(name: 'total_minutes_all_time') final int totalMinutesAllTime,
      @JsonKey(name: 'avg_session_mins') final int avgSessionMins,
      @JsonKey(name: 'total_sessions') final int totalSessions,
      @JsonKey(name: 'sessions_this_week') final int sessionsThisWeek,
      @JsonKey(name: 'best_focus_time') final String bestFocusTime,
      @JsonKey(name: 'longest_session_mins')
      final int longestSessionMins}) = _$FocusStatsImpl;
  const _FocusStats._() : super._();

  factory _FocusStats.fromJson(Map<String, dynamic> json) =
      _$FocusStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_minutes_this_week')
  int get totalMinutesThisWeek;
  @override
  @JsonKey(name: 'total_minutes_all_time')
  int get totalMinutesAllTime;
  @override
  @JsonKey(name: 'avg_session_mins')
  int get avgSessionMins;
  @override
  @JsonKey(name: 'total_sessions')
  int get totalSessions;
  @override
  @JsonKey(name: 'sessions_this_week')
  int get sessionsThisWeek;
  @override
  @JsonKey(name: 'best_focus_time')
  String get bestFocusTime;
  @override
  @JsonKey(name: 'longest_session_mins')
  int get longestSessionMins;

  /// Create a copy of FocusStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusStatsImplCopyWith<_$FocusStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberFocusStat _$MemberFocusStatFromJson(Map<String, dynamic> json) {
  return _MemberFocusStat.fromJson(json);
}

/// @nodoc
mixin _$MemberFocusStat {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'minutes_this_week')
  int get minutesThisWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'sessions_this_week')
  int get sessionsThisWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_focusing')
  bool get isFocusing => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_session_mins')
  int get currentSessionMins => throw _privateConstructorUsedError;

  /// Serializes this MemberFocusStat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberFocusStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberFocusStatCopyWith<MemberFocusStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberFocusStatCopyWith<$Res> {
  factory $MemberFocusStatCopyWith(
          MemberFocusStat value, $Res Function(MemberFocusStat) then) =
      _$MemberFocusStatCopyWithImpl<$Res, MemberFocusStat>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'minutes_this_week') int minutesThisWeek,
      @JsonKey(name: 'sessions_this_week') int sessionsThisWeek,
      @JsonKey(name: 'is_focusing') bool isFocusing,
      @JsonKey(name: 'current_session_mins') int currentSessionMins});
}

/// @nodoc
class _$MemberFocusStatCopyWithImpl<$Res, $Val extends MemberFocusStat>
    implements $MemberFocusStatCopyWith<$Res> {
  _$MemberFocusStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberFocusStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? minutesThisWeek = null,
    Object? sessionsThisWeek = null,
    Object? isFocusing = null,
    Object? currentSessionMins = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      minutesThisWeek: null == minutesThisWeek
          ? _value.minutesThisWeek
          : minutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      sessionsThisWeek: null == sessionsThisWeek
          ? _value.sessionsThisWeek
          : sessionsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      isFocusing: null == isFocusing
          ? _value.isFocusing
          : isFocusing // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSessionMins: null == currentSessionMins
          ? _value.currentSessionMins
          : currentSessionMins // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberFocusStatImplCopyWith<$Res>
    implements $MemberFocusStatCopyWith<$Res> {
  factory _$$MemberFocusStatImplCopyWith(_$MemberFocusStatImpl value,
          $Res Function(_$MemberFocusStatImpl) then) =
      __$$MemberFocusStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'minutes_this_week') int minutesThisWeek,
      @JsonKey(name: 'sessions_this_week') int sessionsThisWeek,
      @JsonKey(name: 'is_focusing') bool isFocusing,
      @JsonKey(name: 'current_session_mins') int currentSessionMins});
}

/// @nodoc
class __$$MemberFocusStatImplCopyWithImpl<$Res>
    extends _$MemberFocusStatCopyWithImpl<$Res, _$MemberFocusStatImpl>
    implements _$$MemberFocusStatImplCopyWith<$Res> {
  __$$MemberFocusStatImplCopyWithImpl(
      _$MemberFocusStatImpl _value, $Res Function(_$MemberFocusStatImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberFocusStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? minutesThisWeek = null,
    Object? sessionsThisWeek = null,
    Object? isFocusing = null,
    Object? currentSessionMins = null,
  }) {
    return _then(_$MemberFocusStatImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      minutesThisWeek: null == minutesThisWeek
          ? _value.minutesThisWeek
          : minutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      sessionsThisWeek: null == sessionsThisWeek
          ? _value.sessionsThisWeek
          : sessionsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      isFocusing: null == isFocusing
          ? _value.isFocusing
          : isFocusing // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSessionMins: null == currentSessionMins
          ? _value.currentSessionMins
          : currentSessionMins // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberFocusStatImpl implements _MemberFocusStat {
  const _$MemberFocusStatImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'display_name') required this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'minutes_this_week') this.minutesThisWeek = 0,
      @JsonKey(name: 'sessions_this_week') this.sessionsThisWeek = 0,
      @JsonKey(name: 'is_focusing') this.isFocusing = false,
      @JsonKey(name: 'current_session_mins') this.currentSessionMins = 0});

  factory _$MemberFocusStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberFocusStatImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'minutes_this_week')
  final int minutesThisWeek;
  @override
  @JsonKey(name: 'sessions_this_week')
  final int sessionsThisWeek;
  @override
  @JsonKey(name: 'is_focusing')
  final bool isFocusing;
  @override
  @JsonKey(name: 'current_session_mins')
  final int currentSessionMins;

  @override
  String toString() {
    return 'MemberFocusStat(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, minutesThisWeek: $minutesThisWeek, sessionsThisWeek: $sessionsThisWeek, isFocusing: $isFocusing, currentSessionMins: $currentSessionMins)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberFocusStatImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.minutesThisWeek, minutesThisWeek) ||
                other.minutesThisWeek == minutesThisWeek) &&
            (identical(other.sessionsThisWeek, sessionsThisWeek) ||
                other.sessionsThisWeek == sessionsThisWeek) &&
            (identical(other.isFocusing, isFocusing) ||
                other.isFocusing == isFocusing) &&
            (identical(other.currentSessionMins, currentSessionMins) ||
                other.currentSessionMins == currentSessionMins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, displayName, avatarUrl,
      minutesThisWeek, sessionsThisWeek, isFocusing, currentSessionMins);

  /// Create a copy of MemberFocusStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberFocusStatImplCopyWith<_$MemberFocusStatImpl> get copyWith =>
      __$$MemberFocusStatImplCopyWithImpl<_$MemberFocusStatImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberFocusStatImplToJson(
      this,
    );
  }
}

abstract class _MemberFocusStat implements MemberFocusStat {
  const factory _MemberFocusStat(
      {@JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'display_name') required final String displayName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'minutes_this_week') final int minutesThisWeek,
      @JsonKey(name: 'sessions_this_week') final int sessionsThisWeek,
      @JsonKey(name: 'is_focusing') final bool isFocusing,
      @JsonKey(name: 'current_session_mins')
      final int currentSessionMins}) = _$MemberFocusStatImpl;

  factory _MemberFocusStat.fromJson(Map<String, dynamic> json) =
      _$MemberFocusStatImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'display_name')
  String get displayName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'minutes_this_week')
  int get minutesThisWeek;
  @override
  @JsonKey(name: 'sessions_this_week')
  int get sessionsThisWeek;
  @override
  @JsonKey(name: 'is_focusing')
  bool get isFocusing;
  @override
  @JsonKey(name: 'current_session_mins')
  int get currentSessionMins;

  /// Create a copy of MemberFocusStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberFocusStatImplCopyWith<_$MemberFocusStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SquadFocusStats _$SquadFocusStatsFromJson(Map<String, dynamic> json) {
  return _SquadFocusStats.fromJson(json);
}

/// @nodoc
mixin _$SquadFocusStats {
  @JsonKey(name: 'squad_id')
  String get squadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_minutes_this_week')
  int get totalMinutesThisWeek => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_member_minutes')
  int get avgMemberMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_stats')
  List<MemberFocusStat> get memberStats => throw _privateConstructorUsedError;

  /// Serializes this SquadFocusStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SquadFocusStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SquadFocusStatsCopyWith<SquadFocusStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SquadFocusStatsCopyWith<$Res> {
  factory $SquadFocusStatsCopyWith(
          SquadFocusStats value, $Res Function(SquadFocusStats) then) =
      _$SquadFocusStatsCopyWithImpl<$Res, SquadFocusStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'squad_id') String squadId,
      @JsonKey(name: 'total_minutes_this_week') int totalMinutesThisWeek,
      @JsonKey(name: 'avg_member_minutes') int avgMemberMinutes,
      @JsonKey(name: 'member_stats') List<MemberFocusStat> memberStats});
}

/// @nodoc
class _$SquadFocusStatsCopyWithImpl<$Res, $Val extends SquadFocusStats>
    implements $SquadFocusStatsCopyWith<$Res> {
  _$SquadFocusStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SquadFocusStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? squadId = null,
    Object? totalMinutesThisWeek = null,
    Object? avgMemberMinutes = null,
    Object? memberStats = null,
  }) {
    return _then(_value.copyWith(
      squadId: null == squadId
          ? _value.squadId
          : squadId // ignore: cast_nullable_to_non_nullable
              as String,
      totalMinutesThisWeek: null == totalMinutesThisWeek
          ? _value.totalMinutesThisWeek
          : totalMinutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      avgMemberMinutes: null == avgMemberMinutes
          ? _value.avgMemberMinutes
          : avgMemberMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      memberStats: null == memberStats
          ? _value.memberStats
          : memberStats // ignore: cast_nullable_to_non_nullable
              as List<MemberFocusStat>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SquadFocusStatsImplCopyWith<$Res>
    implements $SquadFocusStatsCopyWith<$Res> {
  factory _$$SquadFocusStatsImplCopyWith(_$SquadFocusStatsImpl value,
          $Res Function(_$SquadFocusStatsImpl) then) =
      __$$SquadFocusStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'squad_id') String squadId,
      @JsonKey(name: 'total_minutes_this_week') int totalMinutesThisWeek,
      @JsonKey(name: 'avg_member_minutes') int avgMemberMinutes,
      @JsonKey(name: 'member_stats') List<MemberFocusStat> memberStats});
}

/// @nodoc
class __$$SquadFocusStatsImplCopyWithImpl<$Res>
    extends _$SquadFocusStatsCopyWithImpl<$Res, _$SquadFocusStatsImpl>
    implements _$$SquadFocusStatsImplCopyWith<$Res> {
  __$$SquadFocusStatsImplCopyWithImpl(
      _$SquadFocusStatsImpl _value, $Res Function(_$SquadFocusStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SquadFocusStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? squadId = null,
    Object? totalMinutesThisWeek = null,
    Object? avgMemberMinutes = null,
    Object? memberStats = null,
  }) {
    return _then(_$SquadFocusStatsImpl(
      squadId: null == squadId
          ? _value.squadId
          : squadId // ignore: cast_nullable_to_non_nullable
              as String,
      totalMinutesThisWeek: null == totalMinutesThisWeek
          ? _value.totalMinutesThisWeek
          : totalMinutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      avgMemberMinutes: null == avgMemberMinutes
          ? _value.avgMemberMinutes
          : avgMemberMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      memberStats: null == memberStats
          ? _value._memberStats
          : memberStats // ignore: cast_nullable_to_non_nullable
              as List<MemberFocusStat>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SquadFocusStatsImpl extends _SquadFocusStats {
  const _$SquadFocusStatsImpl(
      {@JsonKey(name: 'squad_id') required this.squadId,
      @JsonKey(name: 'total_minutes_this_week') this.totalMinutesThisWeek = 0,
      @JsonKey(name: 'avg_member_minutes') this.avgMemberMinutes = 0,
      @JsonKey(name: 'member_stats')
      final List<MemberFocusStat> memberStats = const []})
      : _memberStats = memberStats,
        super._();

  factory _$SquadFocusStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SquadFocusStatsImplFromJson(json);

  @override
  @JsonKey(name: 'squad_id')
  final String squadId;
  @override
  @JsonKey(name: 'total_minutes_this_week')
  final int totalMinutesThisWeek;
  @override
  @JsonKey(name: 'avg_member_minutes')
  final int avgMemberMinutes;
  final List<MemberFocusStat> _memberStats;
  @override
  @JsonKey(name: 'member_stats')
  List<MemberFocusStat> get memberStats {
    if (_memberStats is EqualUnmodifiableListView) return _memberStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberStats);
  }

  @override
  String toString() {
    return 'SquadFocusStats(squadId: $squadId, totalMinutesThisWeek: $totalMinutesThisWeek, avgMemberMinutes: $avgMemberMinutes, memberStats: $memberStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SquadFocusStatsImpl &&
            (identical(other.squadId, squadId) || other.squadId == squadId) &&
            (identical(other.totalMinutesThisWeek, totalMinutesThisWeek) ||
                other.totalMinutesThisWeek == totalMinutesThisWeek) &&
            (identical(other.avgMemberMinutes, avgMemberMinutes) ||
                other.avgMemberMinutes == avgMemberMinutes) &&
            const DeepCollectionEquality()
                .equals(other._memberStats, _memberStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, squadId, totalMinutesThisWeek,
      avgMemberMinutes, const DeepCollectionEquality().hash(_memberStats));

  /// Create a copy of SquadFocusStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SquadFocusStatsImplCopyWith<_$SquadFocusStatsImpl> get copyWith =>
      __$$SquadFocusStatsImplCopyWithImpl<_$SquadFocusStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SquadFocusStatsImplToJson(
      this,
    );
  }
}

abstract class _SquadFocusStats extends SquadFocusStats {
  const factory _SquadFocusStats(
      {@JsonKey(name: 'squad_id') required final String squadId,
      @JsonKey(name: 'total_minutes_this_week') final int totalMinutesThisWeek,
      @JsonKey(name: 'avg_member_minutes') final int avgMemberMinutes,
      @JsonKey(name: 'member_stats')
      final List<MemberFocusStat> memberStats}) = _$SquadFocusStatsImpl;
  const _SquadFocusStats._() : super._();

  factory _SquadFocusStats.fromJson(Map<String, dynamic> json) =
      _$SquadFocusStatsImpl.fromJson;

  @override
  @JsonKey(name: 'squad_id')
  String get squadId;
  @override
  @JsonKey(name: 'total_minutes_this_week')
  int get totalMinutesThisWeek;
  @override
  @JsonKey(name: 'avg_member_minutes')
  int get avgMemberMinutes;
  @override
  @JsonKey(name: 'member_stats')
  List<MemberFocusStat> get memberStats;

  /// Create a copy of SquadFocusStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SquadFocusStatsImplCopyWith<_$SquadFocusStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionInsight _$SessionInsightFromJson(Map<String, dynamic> json) {
  return _SessionInsight.fromJson(json);
}

/// @nodoc
mixin _$SessionInsight {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'goal_id')
  String? get goalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'insight_type')
  InsightType get insightType => throw _privateConstructorUsedError;
  @JsonKey(name: 'insight_text')
  String get insightText => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SessionInsight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionInsightCopyWith<SessionInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionInsightCopyWith<$Res> {
  factory $SessionInsightCopyWith(
          SessionInsight value, $Res Function(SessionInsight) then) =
      _$SessionInsightCopyWithImpl<$Res, SessionInsight>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'goal_id') String? goalId,
      @JsonKey(name: 'insight_type') InsightType insightType,
      @JsonKey(name: 'insight_text') String insightText,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$SessionInsightCopyWithImpl<$Res, $Val extends SessionInsight>
    implements $SessionInsightCopyWith<$Res> {
  _$SessionInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? userId = null,
    Object? goalId = freezed,
    Object? insightType = null,
    Object? insightText = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String?,
      insightType: null == insightType
          ? _value.insightType
          : insightType // ignore: cast_nullable_to_non_nullable
              as InsightType,
      insightText: null == insightText
          ? _value.insightText
          : insightText // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionInsightImplCopyWith<$Res>
    implements $SessionInsightCopyWith<$Res> {
  factory _$$SessionInsightImplCopyWith(_$SessionInsightImpl value,
          $Res Function(_$SessionInsightImpl) then) =
      __$$SessionInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'goal_id') String? goalId,
      @JsonKey(name: 'insight_type') InsightType insightType,
      @JsonKey(name: 'insight_text') String insightText,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$SessionInsightImplCopyWithImpl<$Res>
    extends _$SessionInsightCopyWithImpl<$Res, _$SessionInsightImpl>
    implements _$$SessionInsightImplCopyWith<$Res> {
  __$$SessionInsightImplCopyWithImpl(
      _$SessionInsightImpl _value, $Res Function(_$SessionInsightImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionInsight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? userId = null,
    Object? goalId = freezed,
    Object? insightType = null,
    Object? insightText = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$SessionInsightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String?,
      insightType: null == insightType
          ? _value.insightType
          : insightType // ignore: cast_nullable_to_non_nullable
              as InsightType,
      insightText: null == insightText
          ? _value.insightText
          : insightText // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionInsightImpl implements _SessionInsight {
  const _$SessionInsightImpl(
      {required this.id,
      @JsonKey(name: 'session_id') required this.sessionId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'goal_id') this.goalId,
      @JsonKey(name: 'insight_type') required this.insightType,
      @JsonKey(name: 'insight_text') required this.insightText,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$SessionInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionInsightImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'goal_id')
  final String? goalId;
  @override
  @JsonKey(name: 'insight_type')
  final InsightType insightType;
  @override
  @JsonKey(name: 'insight_text')
  final String insightText;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SessionInsight(id: $id, sessionId: $sessionId, userId: $userId, goalId: $goalId, insightType: $insightType, insightText: $insightText, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.insightType, insightType) ||
                other.insightType == insightType) &&
            (identical(other.insightText, insightText) ||
                other.insightText == insightText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionId, userId, goalId,
      insightType, insightText, createdAt);

  /// Create a copy of SessionInsight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionInsightImplCopyWith<_$SessionInsightImpl> get copyWith =>
      __$$SessionInsightImplCopyWithImpl<_$SessionInsightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionInsightImplToJson(
      this,
    );
  }
}

abstract class _SessionInsight implements SessionInsight {
  const factory _SessionInsight(
          {required final String id,
          @JsonKey(name: 'session_id') required final String sessionId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'goal_id') final String? goalId,
          @JsonKey(name: 'insight_type') required final InsightType insightType,
          @JsonKey(name: 'insight_text') required final String insightText,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$SessionInsightImpl;

  factory _SessionInsight.fromJson(Map<String, dynamic> json) =
      _$SessionInsightImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'goal_id')
  String? get goalId;
  @override
  @JsonKey(name: 'insight_type')
  InsightType get insightType;
  @override
  @JsonKey(name: 'insight_text')
  String get insightText;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of SessionInsight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionInsightImplCopyWith<_$SessionInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FocusStatsResponse _$FocusStatsResponseFromJson(Map<String, dynamic> json) {
  return _FocusStatsResponse.fromJson(json);
}

/// @nodoc
mixin _$FocusStatsResponse {
  FocusStats get stats => throw _privateConstructorUsedError;

  /// Serializes this FocusStatsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FocusStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FocusStatsResponseCopyWith<FocusStatsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusStatsResponseCopyWith<$Res> {
  factory $FocusStatsResponseCopyWith(
          FocusStatsResponse value, $Res Function(FocusStatsResponse) then) =
      _$FocusStatsResponseCopyWithImpl<$Res, FocusStatsResponse>;
  @useResult
  $Res call({FocusStats stats});

  $FocusStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$FocusStatsResponseCopyWithImpl<$Res, $Val extends FocusStatsResponse>
    implements $FocusStatsResponseCopyWith<$Res> {
  _$FocusStatsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FocusStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
  }) {
    return _then(_value.copyWith(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as FocusStats,
    ) as $Val);
  }

  /// Create a copy of FocusStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FocusStatsCopyWith<$Res> get stats {
    return $FocusStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FocusStatsResponseImplCopyWith<$Res>
    implements $FocusStatsResponseCopyWith<$Res> {
  factory _$$FocusStatsResponseImplCopyWith(_$FocusStatsResponseImpl value,
          $Res Function(_$FocusStatsResponseImpl) then) =
      __$$FocusStatsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FocusStats stats});

  @override
  $FocusStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$FocusStatsResponseImplCopyWithImpl<$Res>
    extends _$FocusStatsResponseCopyWithImpl<$Res, _$FocusStatsResponseImpl>
    implements _$$FocusStatsResponseImplCopyWith<$Res> {
  __$$FocusStatsResponseImplCopyWithImpl(_$FocusStatsResponseImpl _value,
      $Res Function(_$FocusStatsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FocusStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
  }) {
    return _then(_$FocusStatsResponseImpl(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as FocusStats,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusStatsResponseImpl implements _FocusStatsResponse {
  const _$FocusStatsResponseImpl({required this.stats});

  factory _$FocusStatsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusStatsResponseImplFromJson(json);

  @override
  final FocusStats stats;

  @override
  String toString() {
    return 'FocusStatsResponse(stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusStatsResponseImpl &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, stats);

  /// Create a copy of FocusStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusStatsResponseImplCopyWith<_$FocusStatsResponseImpl> get copyWith =>
      __$$FocusStatsResponseImplCopyWithImpl<_$FocusStatsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusStatsResponseImplToJson(
      this,
    );
  }
}

abstract class _FocusStatsResponse implements FocusStatsResponse {
  const factory _FocusStatsResponse({required final FocusStats stats}) =
      _$FocusStatsResponseImpl;

  factory _FocusStatsResponse.fromJson(Map<String, dynamic> json) =
      _$FocusStatsResponseImpl.fromJson;

  @override
  FocusStats get stats;

  /// Create a copy of FocusStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FocusStatsResponseImplCopyWith<_$FocusStatsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsightsListResponse _$InsightsListResponseFromJson(Map<String, dynamic> json) {
  return _InsightsListResponse.fromJson(json);
}

/// @nodoc
mixin _$InsightsListResponse {
  List<SessionInsight> get insights => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_count')
  int get totalCount => throw _privateConstructorUsedError;

  /// Serializes this InsightsListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsightsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightsListResponseCopyWith<InsightsListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsListResponseCopyWith<$Res> {
  factory $InsightsListResponseCopyWith(InsightsListResponse value,
          $Res Function(InsightsListResponse) then) =
      _$InsightsListResponseCopyWithImpl<$Res, InsightsListResponse>;
  @useResult
  $Res call(
      {List<SessionInsight> insights,
      @JsonKey(name: 'total_count') int totalCount});
}

/// @nodoc
class _$InsightsListResponseCopyWithImpl<$Res,
        $Val extends InsightsListResponse>
    implements $InsightsListResponseCopyWith<$Res> {
  _$InsightsListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? totalCount = null,
  }) {
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<SessionInsight>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsightsListResponseImplCopyWith<$Res>
    implements $InsightsListResponseCopyWith<$Res> {
  factory _$$InsightsListResponseImplCopyWith(_$InsightsListResponseImpl value,
          $Res Function(_$InsightsListResponseImpl) then) =
      __$$InsightsListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SessionInsight> insights,
      @JsonKey(name: 'total_count') int totalCount});
}

/// @nodoc
class __$$InsightsListResponseImplCopyWithImpl<$Res>
    extends _$InsightsListResponseCopyWithImpl<$Res, _$InsightsListResponseImpl>
    implements _$$InsightsListResponseImplCopyWith<$Res> {
  __$$InsightsListResponseImplCopyWithImpl(_$InsightsListResponseImpl _value,
      $Res Function(_$InsightsListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsightsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? totalCount = null,
  }) {
    return _then(_$InsightsListResponseImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<SessionInsight>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightsListResponseImpl implements _InsightsListResponse {
  const _$InsightsListResponseImpl(
      {required final List<SessionInsight> insights,
      @JsonKey(name: 'total_count') required this.totalCount})
      : _insights = insights;

  factory _$InsightsListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightsListResponseImplFromJson(json);

  final List<SessionInsight> _insights;
  @override
  List<SessionInsight> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  @JsonKey(name: 'total_count')
  final int totalCount;

  @override
  String toString() {
    return 'InsightsListResponse(insights: $insights, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsListResponseImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_insights), totalCount);

  /// Create a copy of InsightsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsListResponseImplCopyWith<_$InsightsListResponseImpl>
      get copyWith =>
          __$$InsightsListResponseImplCopyWithImpl<_$InsightsListResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightsListResponseImplToJson(
      this,
    );
  }
}

abstract class _InsightsListResponse implements InsightsListResponse {
  const factory _InsightsListResponse(
          {required final List<SessionInsight> insights,
          @JsonKey(name: 'total_count') required final int totalCount}) =
      _$InsightsListResponseImpl;

  factory _InsightsListResponse.fromJson(Map<String, dynamic> json) =
      _$InsightsListResponseImpl.fromJson;

  @override
  List<SessionInsight> get insights;
  @override
  @JsonKey(name: 'total_count')
  int get totalCount;

  /// Create a copy of InsightsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightsListResponseImplCopyWith<_$InsightsListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
