import 'package:equatable/equatable.dart';

/// Focus Session model - matches Alpha's API contract
class FocusSession extends Equatable {
  final String id;
  final String userId;
  final String squadId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationMinutes;

  const FocusSession({
    required this.id,
    required this.userId,
    required this.squadId,
    required this.startedAt,
    this.endedAt,
    required this.durationMinutes,
  });

  bool get isActive => endedAt == null;

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      squadId: json['squad_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null 
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'squad_id': squadId,
    'started_at': startedAt.toIso8601String(),
    'ended_at': endedAt?.toIso8601String(),
    'duration_minutes': durationMinutes,
  };

  @override
  List<Object?> get props => [id, userId, squadId, startedAt, endedAt, durationMinutes];
}

/// Active focuser with profile info
class ActiveFocuser extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final DateTime startedAt;
  final int durationMinutes;

  const ActiveFocuser({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.startedAt,
    required this.durationMinutes,
  });

  factory ActiveFocuser.fromJson(Map<String, dynamic> json) {
    return ActiveFocuser(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      startedAt: DateTime.parse(json['started_at'] as String),
      durationMinutes: json['duration_minutes'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [userId, displayName, avatarUrl, startedAt, durationMinutes];
}

/// Start focus request
class StartFocusRequest {
  final String squadId;

  const StartFocusRequest({required this.squadId});

  Map<String, dynamic> toJson() => {'squad_id': squadId};
}

/// Start focus response
class StartFocusResponse {
  final String sessionId;
  final DateTime startedAt;

  const StartFocusResponse({required this.sessionId, required this.startedAt});

  factory StartFocusResponse.fromJson(Map<String, dynamic> json) {
    return StartFocusResponse(
      sessionId: json['session_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
    );
  }
}

/// Stop focus response
class StopFocusResponse {
  final String sessionId;
  final int durationMinutes;

  const StopFocusResponse({required this.sessionId, required this.durationMinutes});

  factory StopFocusResponse.fromJson(Map<String, dynamic> json) {
    return StopFocusResponse(
      sessionId: json['session_id'] as String,
      durationMinutes: json['duration_minutes'] as int,
    );
  }
}
