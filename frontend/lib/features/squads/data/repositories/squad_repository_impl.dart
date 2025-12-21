import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/squad.dart';
import '../../domain/repositories/squad_repository.dart';

/// Squad repository implementation using Go Backend API
/// All operations go through the backend - no direct Supabase calls
class SquadRepositoryImpl implements SquadRepository {
  final SupabaseClient _supabase;
  final http.Client _httpClient;

  SquadRepositoryImpl({SupabaseClient? supabase, http.Client? httpClient})
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
  Future<List<Squad>> getMySquads() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/squads'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    final data = jsonDecode(response.body);
    final squadsJson = data['data'] as List? ?? [];
    return squadsJson.map((json) => Squad.fromJson(json)).toList();
  }

  @override
  Future<SquadDetail> getSquadDetail(String squadId) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/squads/$squadId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    return SquadDetail.fromJson(jsonDecode(response.body));
  }

  @override
  Future<Squad> createSquad(CreateSquadRequest request) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/squads'),
      headers: _getHeaders(),
      body: jsonEncode({
        'name': request.name,
        'description': request.description,
      }),
    );

    if (response.statusCode != 201) {
      throw _parseError(response);
    }

    return Squad.fromJson(jsonDecode(response.body));
  }

  @override
  Future<Squad> updateSquad(String squadId, UpdateSquadRequest request) async {
    final body = <String, dynamic>{};
    if (request.name != null) body['name'] = request.name;
    if (request.description != null) body['description'] = request.description;

    final response = await _httpClient.patch(
      Uri.parse('$_baseUrl/squads/$squadId'),
      headers: _getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    return Squad.fromJson(jsonDecode(response.body));
  }

  @override
  Future<void> deleteSquad(String squadId) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/squads/$squadId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  @override
  Future<Squad> joinSquad(JoinSquadRequest request) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/squads/join'),
      headers: _getHeaders(),
      body: jsonEncode({
        'invite_code': request.inviteCode,
      }),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    return Squad.fromJson(jsonDecode(response.body));
  }

  @override
  Future<void> removeMember(String squadId, String userId) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/squads/$squadId/members/$userId'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }
  }

  @override
  Future<String> regenerateInviteCode(String squadId) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/squads/$squadId/regenerate-code'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw _parseError(response);
    }

    final data = jsonDecode(response.body);
    return data['invite_code'] as String;
  }

  /// Parse error response from backend
  Exception _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      final code = data['code'] as String? ?? 'UNKNOWN_ERROR';
      final message = data['error'] as String? ?? 'An error occurred';
      
      // Map backend error codes to user-friendly messages
      switch (code) {
        case 'SQUAD_NOT_FOUND':
          return Exception('Squad not found');
        case 'NOT_OWNER':
          return Exception('Only squad owner can perform this action');
        case 'NOT_MEMBER':
          return Exception('You are not a member of this squad');
        case 'SQUAD_FULL':
          return Exception('Squad is full');
        case 'ALREADY_MEMBER':
          return Exception('You are already a member of this squad');
        case 'INVALID_INVITE_CODE':
          return Exception('Invalid invite code');
        case 'CANNOT_KICK_OWNER':
          return Exception('Cannot kick squad owner');
        case 'NAME_REQUIRED':
          return Exception('Squad name is required');
        case 'NAME_TOO_LONG':
          return Exception('Squad name must be 50 characters or less');
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
