import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/streak_models.dart';
import '../../domain/repositories/streak_repository.dart';

class StreakRepositoryImpl implements StreakRepository {
  final SupabaseClient _supabase;
  final http.Client _client;

  StreakRepositoryImpl({
    SupabaseClient? supabase,
    http.Client? client,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _client = client ?? http.Client();

  String get _baseUrl => AppConfig.apiBaseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final session = _supabase.auth.currentSession;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session?.accessToken ?? ''}',
    };
  }

  @override
  Future<StreakData> getMyStreak() async {
    final headers = await _getHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/streaks/me'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return StreakData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user streak: ${response.statusCode}');
    }
  }

  @override
  Future<StreakData> getUserStreak(String userId) async {
    final headers = await _getHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/streaks/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return StreakData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user streak: ${response.statusCode}');
    }
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final headers = await _getHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/streaks/leaderboard'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['leaderboard'] as List;
      return list.map((e) => LeaderboardEntry.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get leaderboard: ${response.statusCode}');
    }
  }

  @override
  Future<StreakData> logActivity(String activityType) async {
    final headers = await _getHeaders();
    final response = await _client.post(
      Uri.parse('$_baseUrl/streaks/log'),
      headers: headers,
      body: jsonEncode({'activity_type': activityType}),
    );

    if (response.statusCode == 200) {
      // The response returns {success: true, activity_date, current_streak}
      // But we probably want to return the updated StreakData. 
      // Current design says response is limited. 
      // However, usually logging activity updates the streak.
      // Let's re-fetch the streak data to be safe and update the UI correctly
      // OR construct a partial one. 
      // The instruction says "POST /api/v1/streaks/log - Response { success: true, activity_date: ..., current_streak: 5 }"
      // This is not a full StreakData object.
      // But the interface returns Future<StreakData>.
      
      // I will re-fetch 'getMyStreak' afterwards or assume the backend validates it?
      // Re-fetching is safer for consistency.
      return getMyStreak();
    } else {
      throw Exception('Failed to log activity: ${response.statusCode}');
    }
  }
}
