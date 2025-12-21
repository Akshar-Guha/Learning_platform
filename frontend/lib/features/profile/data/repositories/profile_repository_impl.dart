import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Profile repository implementation using Go Backend API
/// All operations go through the backend - no direct Supabase calls
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;
  final http.Client _httpClient;

  ProfileRepositoryImpl({SupabaseClient? supabase, http.Client? httpClient})
      : _supabase = supabase ?? Supabase.instance.client,
        _httpClient = httpClient ?? http.Client();

  /// Get authorization headers with Supabase JWT
  Map<String, String> _getHeaders() {
    final session = _supabase.auth.currentSession;
    if (session?.accessToken == null) {
      throw Exception('Not authenticated');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session!.accessToken}',
    };
  }

  String get _baseUrl => AppConfig.apiBaseUrl;

  @override
  Future<Profile> getCurrentProfile() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/profile/me'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Profile.fromJson(data);
    }

    throw _parseError(response);
  }

  @override
  Future<Profile> updateProfile(UpdateProfileRequest request) async {
    final body = <String, dynamic>{};
    if (request.displayName != null) body['display_name'] = request.displayName;
    if (request.avatarUrl != null) body['avatar_url'] = request.avatarUrl;
    if (request.timezone != null) body['timezone'] = request.timezone;

    final response = await _httpClient.patch(
      Uri.parse('$_baseUrl/profile/me'),
      headers: _getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Profile.fromJson(data);
    }

    throw _parseError(response);
  }

  @override
  Future<PublicProfile> getPublicProfile(String userId) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/profile/$userId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return PublicProfile.fromJson(data);
    }

    throw _parseError(response);
  }

  /// Parse error response from backend
  Exception _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      final code = data['code'] as String? ?? 'UNKNOWN_ERROR';
      final message = data['error'] as String? ?? 'An error occurred';
      
      switch (code) {
        case 'PROFILE_NOT_FOUND':
          return Exception('Profile not found');
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
