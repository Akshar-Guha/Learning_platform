/// Goals Repository
/// 
/// API calls for study goals CRUD operations

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ulp/core/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

import '../models/study_goal.dart';
import '../models/focus_stats.dart';

/// Goals Repository Provider
final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository(Supabase.instance.client);
});

class GoalsRepository {
  final SupabaseClient _supabase;

  GoalsRepository(this._supabase);

  String get _baseUrl => AppConfig.apiBaseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${_supabase.auth.currentSession?.accessToken ?? ''}',
        'Content-Type': 'application/json',
      };

  /// Create a new study goal
  Future<StudyGoal> createGoal(CreateGoalRequest request) async {
    developer.log('[GoalsRepository.createGoal] Creating goal: ${request.title}');

    final response = await http.post(
      Uri.parse('$_baseUrl/goals'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      developer.log('[GoalsRepository.createGoal] Error: ${error['message']}');
      throw Exception(error['message'] ?? 'Failed to create goal');
    }

    final data = jsonDecode(response.body);
    developer.log('[GoalsRepository.createGoal] Goal created successfully');
    return StudyGoal.fromJson(data['goal']);
  }

  /// Get all goals for user
  Future<List<StudyGoal>> getGoals({bool activeOnly = true}) async {
    developer.log('[GoalsRepository.getGoals] Fetching goals (activeOnly: $activeOnly)');

    final queryParams = activeOnly ? '?active=true' : '';
    final response = await http.get(
      Uri.parse('$_baseUrl/goals$queryParams'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      developer.log('[GoalsRepository.getGoals] Error: ${response.statusCode}');
      throw Exception('Failed to fetch goals');
    }

    final data = jsonDecode(response.body);
    final goals = (data['goals'] as List)
        .map((g) => StudyGoal.fromJson(g))
        .toList();

    developer.log('[GoalsRepository.getGoals] Fetched ${goals.length} goals');
    return goals;
  }

  /// Get a single goal by ID
  Future<StudyGoal> getGoal(String goalId) async {
    developer.log('[GoalsRepository.getGoal] Fetching goal: $goalId');

    final response = await http.get(
      Uri.parse('$_baseUrl/goals/$goalId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch goal');
    }

    final data = jsonDecode(response.body);
    return StudyGoal.fromJson(data['goal']);
  }

  /// Update a goal
  Future<StudyGoal> updateGoal(String goalId, Map<String, dynamic> updates) async {
    developer.log('[GoalsRepository.updateGoal] Updating goal: $goalId');

    final response = await http.patch(
      Uri.parse('$_baseUrl/goals/$goalId'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update goal');
    }

    final data = jsonDecode(response.body);
    return StudyGoal.fromJson(data['goal']);
  }

  /// Delete (archive) a goal
  Future<void> deleteGoal(String goalId) async {
    developer.log('[GoalsRepository.deleteGoal] Archiving goal: $goalId');

    final response = await http.delete(
      Uri.parse('$_baseUrl/goals/$goalId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete goal');
    }
  }

  /// Generate AI schedule for goal (one-time only)
  Future<AISchedule> generateSchedule(String goalId) async {
    developer.log('[GoalsRepository.generateSchedule] Generating schedule for: $goalId');

    final response = await http.post(
      Uri.parse('$_baseUrl/goals/$goalId/generate-schedule'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to generate schedule');
    }

    final data = jsonDecode(response.body);
    developer.log('[GoalsRepository.generateSchedule] Schedule generated');
    return AISchedule.fromJson(data['schedule']);
  }

  /// Get focus stats for current user
  Future<FocusStats> getMyStats() async {
    developer.log('[GoalsRepository.getMyStats] Fetching user stats');

    final response = await http.get(
      Uri.parse('$_baseUrl/focus/stats/me'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      developer.log('[GoalsRepository.getMyStats] Error: ${response.statusCode}');
      throw Exception('Failed to fetch stats');
    }

    final data = jsonDecode(response.body);
    return FocusStats.fromJson(data['stats']);
  }

  /// Get squad focus stats
  Future<SquadFocusStats> getSquadStats(String squadId) async {
    developer.log('[GoalsRepository.getSquadStats] Fetching squad stats: $squadId');

    final response = await http.get(
      Uri.parse('$_baseUrl/focus/stats/squad/$squadId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch squad stats');
    }

    final data = jsonDecode(response.body);
    return SquadFocusStats.fromJson(data['stats']);
  }

  /// Get recent AI insights
  Future<List<SessionInsight>> getRecentInsights() async {
    developer.log('[GoalsRepository.getRecentInsights] Fetching recent insights');

    final response = await http.get(
      Uri.parse('$_baseUrl/insights/recent'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      developer.log('[GoalsRepository.getRecentInsights] Error: ${response.statusCode}');
      return []; // Return empty on error
    }

    final data = jsonDecode(response.body);
    final insights = (data['insights'] as List)
        .map((i) => SessionInsight.fromJson(i))
        .toList();

    developer.log('[GoalsRepository.getRecentInsights] Fetched ${insights.length} insights');
    return insights;
  }
}
