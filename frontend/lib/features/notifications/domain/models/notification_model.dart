import 'package:equatable/equatable.dart';

/// Notification types for different nudge scenarios
enum NotificationType {
  nudge,        // AI-generated nudge
  squadAlert,   // Squad activity
  streakRisk,   // Streak about to break
  system,       // System messages
}

/// Domain model for notifications
class AppNotification extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.metadata,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: _parseType(json['type'] as String?),
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  static NotificationType _parseType(String? type) {
    switch (type) {
      case 'nudge':
        return NotificationType.nudge;
      case 'squad_alert':
        return NotificationType.squadAlert;
      case 'streak_risk':
        return NotificationType.streakRisk;
      default:
        return NotificationType.system;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type.name,
    'title': title,
    'message': message,
    'is_read': isRead,
    'created_at': createdAt.toIso8601String(),
    'metadata': metadata,
  };

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      metadata: metadata,
    );
  }

  @override
  List<Object?> get props => [id, userId, type, title, message, isRead, createdAt];
}
