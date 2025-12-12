import 'package:equatable/equatable.dart';

/// Profile domain model - STRICTLY matches Alpha's API contract
/// Field names match exactly: id, email, display_name, avatar_url, etc.
class Profile extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool isEduVerified;
  final String timezone;
  final int consistencyScore;
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.isEduVerified,
    required this.timezone,
    required this.consistencyScore,
    required this.currentStreak,
    required this.longestStreak,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor from JSON - matches Alpha's API response exactly
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isEduVerified: json['is_edu_verified'] as bool,
      timezone: json['timezone'] as String,
      consistencyScore: json['consistency_score'] as int,
      currentStreak: json['current_streak'] as int,
      longestStreak: json['longest_streak'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'is_edu_verified': isEduVerified,
      'timezone': timezone,
      'consistency_score': consistencyScore,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  Profile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    bool? isEduVerified,
    String? timezone,
    int? consistencyScore,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEduVerified: isEduVerified ?? this.isEduVerified,
      timezone: timezone ?? this.timezone,
      consistencyScore: consistencyScore ?? this.consistencyScore,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        isEduVerified,
        timezone,
        consistencyScore,
        currentStreak,
        longestStreak,
        createdAt,
        updatedAt,
      ];
}

/// PublicProfile - limited fields for public viewing
/// Matches Alpha's PublicProfile contract
class PublicProfile extends Equatable {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final bool isEduVerified;
  final int consistencyScore;

  const PublicProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    required this.isEduVerified,
    required this.consistencyScore,
  });

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isEduVerified: json['is_edu_verified'] as bool,
      consistencyScore: json['consistency_score'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'is_edu_verified': isEduVerified,
      'consistency_score': consistencyScore,
    };
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        avatarUrl,
        isEduVerified,
        consistencyScore,
      ];
}

/// Request model for updating profile - matches Alpha's UpdateProfileRequest
class UpdateProfileRequest {
  final String? displayName;
  final String? avatarUrl;
  final String? timezone;

  const UpdateProfileRequest({
    this.displayName,
    this.avatarUrl,
    this.timezone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (displayName != null) data['display_name'] = displayName;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    if (timezone != null) data['timezone'] = timezone;
    return data;
  }
}
