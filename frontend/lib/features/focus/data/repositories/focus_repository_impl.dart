import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/focus_session.dart';
import '../../domain/repositories/focus_repository.dart';

/// Focus repository implementation using Go Backend API
/// All operations go through the backend - no direct Supabase calls for mutations
class FocusRepositoryImpl implements FocusRepository {
  final SupabaseClient _supabase;
  final http.Client _httpClient;

  FocusRepositoryImpl({SupabaseClient? supabase, http.Client? httpClient})
      : _supabase = supabase ?? Supabase.instance.client,
        _httpClient = httpClient ?? http.Client();

  /// Get authorization headers with current user's JWT token
  Map<String, String> _getHeaders() {
    final token = _supabase.auth.currentSession?.accessToken;
    if (token == null) {
      throw Exception('Not authenticated');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Base URL for API calls
  String get _baseUrl => AppConfig.apiBaseUrl;

  @override
  Future<StartFocusResponse> startFocus(String squadId) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/focus/start'),
      headers: _getHeaders(),
      body: jsonEncode({'squad_id': squadId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw _parseError(response);
    }

    final data = jsonDecode(response.body);
    return StartFocusResponse(
      sessionId: data['session_id'] as String,
      startedAt: DateTime.parse(data['started_at'] as String),
    );
  }

  @override
  Future<StopFocusResponse> stopFocus() async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/focus/stop'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    final data = jsonDecode(response.body);
    return StopFocusResponse(
      sessionId: data['session_id'] as String,
      durationMinutes: data['duration_minutes'] as int,
    );
  }

  @override
  Future<List<ActiveFocuser>> getActiveFocusers(String squadId) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/focus/active/$squadId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    final data = jsonDecode(response.body);
    final sessions = data['active_sessions'] as List? ?? [];
    
    return sessions.map((session) {
      final startedAt = DateTime.parse(session['started_at'] as String);
      return ActiveFocuser(
        userId: session['user_id'] as String,
        displayName: session['display_name'] as String? ?? 'Unknown',
        avatarUrl: session['avatar_url'] as String?,
        startedAt: startedAt,
        durationMinutes: DateTime.now().toUtc().difference(startedAt).inMinutes,
      );
    }).toList();
  }

  @override
  Future<List<FocusSession>> getFocusHistory(String squadId) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/focus/history/$squadId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    final data = jsonDecode(response.body);
    final history = data['history'] as List? ?? [];
    
    return history.map((item) => FocusSession(
      id: item['session_id'] as String,
      squadId: squadId,
      userId: item['user_id'] as String,
      startedAt: DateTime.parse(item['started_at'] as String),
      endedAt: item['ended_at'] != null 
          ? DateTime.parse(item['ended_at'] as String) 
          : null,
      durationMinutes: item['duration_minutes'] as int? ?? 0,
    ),).toList();
  }

  @override
  Future<FocusSession?> getCurrentSession() async {
    // For current session check, we use Supabase Realtime-compatible query
    // This is acceptable as it's a read operation for the current user
    final userId = _supabase.auth.currentUser?.id;
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
    // Supabase Realtime subscription - this is acceptable for real-time features
    return _supabase
        .from('focus_sessions')
        .stream(primaryKey: ['id'])
        .eq('squad_id', squadId)
        .map((data) {
          return data
              .where((row) => row['ended_at'] == null)
              .map((row) => FocusSession.fromJson(row))
              .toList();
        });
  }

  /// Parse error response from backend
  Exception _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      final code = data['code'] as String? ?? 'UNKNOWN_ERROR';
      final message = data['error'] as String? ?? 'An error occurred';
      
      switch (code) {
        case 'NOT_MEMBER':
          return Exception('You are not a member of this squad');
        case 'SESSION_ACTIVE':
          return Exception('You already have an active focus session');
        case 'NO_ACTIVE_SESSION':
          return Exception('No active focus session to stop');
        case 'UNAUTHORIZED':
          return Exception('Please log in again');
        default:
          return Exception(message);
      }
    } catch (_) {
      return Exception('Request failed: ${response.statusCode}');
    }
  }
}
