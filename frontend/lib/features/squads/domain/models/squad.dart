import 'package:equatable/equatable.dart';

/// Squad model - matches Alpha's Go API contract exactly
class Squad extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String inviteCode;
  final String ownerId;
  final int maxMembers;
  final int memberCount;
  final DateTime createdAt;

  const Squad({
    required this.id,
    required this.name,
    this.description,
    required this.inviteCode,
    required this.ownerId,
    required this.maxMembers,
    required this.memberCount,
    required this.createdAt,
  });

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      inviteCode: json['invite_code'] as String,
      ownerId: json['owner_id'] as String,
      maxMembers: json['max_members'] as int? ?? 4,
      memberCount: json['member_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'invite_code': inviteCode,
    'owner_id': ownerId,
    'max_members': maxMembers,
    'member_count': memberCount,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, description, inviteCode, ownerId, maxMembers, memberCount, createdAt];
}

/// Squad member model
class SquadMember extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String role; // 'owner' or 'member'
  final DateTime joinedAt;

  const SquadMember({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
  });

  bool get isOwner => role == 'owner';

  factory SquadMember.fromJson(Map<String, dynamic> json) {
    return SquadMember(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'member',
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  @override
  List<Object?> get props => [userId, displayName, avatarUrl, role, joinedAt];
}

/// Squad detail with members list
class SquadDetail extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String inviteCode;
  final String ownerId;
  final int maxMembers;
  final DateTime createdAt;
  final List<SquadMember> members;

  const SquadDetail({
    required this.id,
    required this.name,
    this.description,
    required this.inviteCode,
    required this.ownerId,
    required this.maxMembers,
    required this.createdAt,
    required this.members,
  });

  int get memberCount => members.length;
  bool get isFull => memberCount >= maxMembers;

  factory SquadDetail.fromJson(Map<String, dynamic> json) {
    return SquadDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      inviteCode: json['invite_code'] as String,
      ownerId: json['owner_id'] as String,
      maxMembers: json['max_members'] as int? ?? 4,
      createdAt: DateTime.parse(json['created_at'] as String),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => SquadMember.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [id, name, description, inviteCode, ownerId, maxMembers, createdAt, members];
}

/// Request models
class CreateSquadRequest {
  final String name;
  final String? description;

  const CreateSquadRequest({required this.name, this.description});

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null) 'description': description,
  };
}

class JoinSquadRequest {
  final String inviteCode;

  const JoinSquadRequest({required this.inviteCode});

  Map<String, dynamic> toJson() => {'invite_code': inviteCode};
}

class UpdateSquadRequest {
  final String? name;
  final String? description;

  const UpdateSquadRequest({this.name, this.description});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (description != null) 'description': description,
  };
}
