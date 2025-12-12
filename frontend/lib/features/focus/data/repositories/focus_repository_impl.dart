import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/focus_session.dart';
import '../../domain/repositories/focus_repository.dart';

/// Focus repository implementation using Supabase with Realtime
class FocusRepositoryImpl implements FocusRepository {
  final SupabaseClient _supabase;

  FocusRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  @override
  Future<StartFocusResponse> startFocus(String squadId) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('Not authenticated');

    // Check if user already has an active session
    final existing = await getCurrentSession();
    if (existing != null) {
      throw Exception('You already have an active focus session');
    }

    // Insert new focus session
    final response = await _supabase.from('focus_sessions').insert({
      'user_id': userId,
      'squad_id': squadId,
    }).select().single();

    return StartFocusResponse(
      sessionId: response['id'] as String,
      startedAt: DateTime.parse(response['started_at'] as String),
    );
  }

  @override
  Future<StopFocusResponse> stopFocus() async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('Not authenticated');

    // Find and end the active session
    final now = DateTime.now().toUtc();
    final response = await _supabase
        .from('focus_sessions')
        .update({'ended_at': now.toIso8601String()})
        .eq('user_id', userId)
        .isFilter('ended_at', null)
        .select()
        .single();

    final startedAt = DateTime.parse(response['started_at'] as String);
    final durationMinutes = now.difference(startedAt).inMinutes;

    return StopFocusResponse(
      sessionId: response['id'] as String,
      durationMinutes: durationMinutes,
    );
  }

  @override
  Future<List<ActiveFocuser>> getActiveFocusers(String squadId) async {
    final response = await _supabase
        .from('focus_sessions')
        .select('user_id, started_at, profiles(display_name, avatar_url)')
        .eq('squad_id', squadId)
        .isFilter('ended_at', null);

    return (response as List).map((row) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      final startedAt = DateTime.parse(row['started_at'] as String);
      return ActiveFocuser(
        userId: row['user_id'] as String,
        displayName: profile?['display_name'] ?? 'Unknown',
        avatarUrl: profile?['avatar_url'] as String?,
        startedAt: startedAt,
        durationMinutes: DateTime.now().toUtc().difference(startedAt).inMinutes,
      );
    }).toList();
  }

  @override
  Future<List<FocusSession>> getFocusHistory(String squadId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    
    final response = await _supabase
        .from('focus_sessions')
        .select()
        .eq('squad_id', squadId)
        .gte('started_at', sevenDaysAgo.toIso8601String())
        .order('started_at', ascending: false);

    return (response as List)
        .map((row) => FocusSession.fromJson(row))
        .toList();
  }

  @override
  Future<FocusSession?> getCurrentSession() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    try {
      final response = await _supabase
          .from('focus_sessions')
          .select()
          .eq('user_id', userId)
          .isFilter('ended_at', null)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return FocusSession.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<FocusSession>> watchActiveSessions(String squadId) {
    // Supabase Realtime subscription
    return _supabase
        .from('focus_sessions')
        .stream(primaryKey: ['id'])
        .eq('squad_id', squadId)
        .map((data) {
          // Filter to only active sessions (ended_at is null)
          return data
              .where((row) => row['ended_at'] == null)
              .map((row) => FocusSession.fromJson(row))
              .toList();
        });
  }
}
