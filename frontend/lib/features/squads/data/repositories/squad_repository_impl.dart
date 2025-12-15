import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/squad.dart';
import '../../domain/repositories/squad_repository.dart';

/// Squad repository implementation using Go Backend API
class SquadRepositoryImpl implements SquadRepository {
  final SupabaseClient _supabase;

  SquadRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;


  @override
  Future<List<Squad>> getMySquads() async {
    // Direct Supabase query for now (fallback until Go API is connected)
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _supabase
        .from('squad_members')
        .select('squad_id, squads(*)')
        .eq('user_id', userId);

    final squads = <Squad>[];
    for (final row in response as List) {
      if (row['squads'] != null) {
        final squadData = row['squads'] as Map<String, dynamic>;
        // Get member count
        final countResponse = await _supabase
            .from('squad_members')
            .select()
            .eq('squad_id', squadData['id'])
            .count(CountOption.exact);
        squadData['member_count'] = countResponse.count;
        squads.add(Squad.fromJson(squadData));
      }
    }
    return squads;
  }

  @override
  Future<SquadDetail> getSquadDetail(String squadId) async {
    final squadResponse = await _supabase
        .from('squads')
        .select()
        .eq('id', squadId)
        .single();

    final membersResponse = await _supabase
        .from('squad_members')
        .select('user_id, role, joined_at, profiles(display_name, avatar_url)')
        .eq('squad_id', squadId);

    final members = (membersResponse as List).map((m) {
      final profile = m['profiles'] as Map<String, dynamic>?;
      return {
        'user_id': m['user_id'],
        'role': m['role'],
        'joined_at': m['joined_at'],
        'display_name': profile?['display_name'] ?? 'Unknown',
        'avatar_url': profile?['avatar_url'],
      };
    }).toList();

    squadResponse['members'] = members;
    return SquadDetail.fromJson(squadResponse);
  }

  @override
  Future<Squad> createSquad(CreateSquadRequest request) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // Generate invite code
    final inviteCode = _generateInviteCode();

    final response = await _supabase.from('squads').insert({
      'name': request.name,
      'description': request.description,
      'invite_code': inviteCode,
      'owner_id': userId,
    }).select().single();

    // Add owner as first member
    await _supabase.from('squad_members').insert({
      'squad_id': response['id'],
      'user_id': userId,
      'role': 'owner',
    });

    response['member_count'] = 1;
    return Squad.fromJson(response);
  }

  @override
  Future<Squad> updateSquad(String squadId, UpdateSquadRequest request) async {
    final updates = <String, dynamic>{};
    if (request.name != null) updates['name'] = request.name;
    if (request.description != null) updates['description'] = request.description;

    final response = await _supabase
        .from('squads')
        .update(updates)
        .eq('id', squadId)
        .select()
        .single();

    return Squad.fromJson(response);
  }

  @override
  Future<void> deleteSquad(String squadId) async {
    await _supabase.from('squads').delete().eq('id', squadId);
  }

  @override
  Future<Squad> joinSquad(JoinSquadRequest request) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // Find squad by invite code
    final squadResponse = await _supabase
        .from('squads')
        .select()
        .eq('invite_code', request.inviteCode)
        .single();

    final squadId = squadResponse['id'] as String;

    // Check member count
    final countResponse = await _supabase
        .from('squad_members')
        .select()
        .eq('squad_id', squadId)
        .count(CountOption.exact);

    final maxMembers = squadResponse['max_members'] as int? ?? 4;
    if (countResponse.count >= maxMembers) {
      throw Exception('Squad is full');
    }

    // Add member
    await _supabase.from('squad_members').insert({
      'squad_id': squadId,
      'user_id': userId,
      'role': 'member',
    });

    squadResponse['member_count'] = countResponse.count + 1;
    return Squad.fromJson(squadResponse);
  }

  @override
  Future<void> removeMember(String squadId, String userId) async {
    await _supabase
        .from('squad_members')
        .delete()
        .eq('squad_id', squadId)
        .eq('user_id', userId);
  }

  @override
  Future<String> regenerateInviteCode(String squadId) async {
    final newCode = _generateInviteCode();
    await _supabase
        .from('squads')
        .update({'invite_code': newCode})
        .eq('id', squadId);
    return newCode;
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(8, (i) => chars[(random + i * 7) % chars.length]).join();
  }
}
