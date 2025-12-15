import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Profile repository implementation using Go Backend API
/// Follows Alpha's API contract: /api/v1/profile/me, /api/v1/profile/{userID}
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepositoryImpl({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Get authorization headers with Supabase JWT
  Map<String, String> get _headers {
    final session = _supabase.auth.currentSession;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${session?.accessToken ?? ''}',
    };
  }

  String get _baseUrl => AppConfig.apiBaseUrl;

  @override
  Future<Profile> getCurrentProfile() async {
    try {
      // Call Go backend API directly
      final response = await http.get(
        Uri.parse('$_baseUrl/profile/me'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Profile.fromJson(data);
      }

      // If backend fails, try direct Supabase query as fallback
      if (response.statusCode == 404 || response.statusCode >= 500) {
        return await _getProfileFromSupabase();
      }

      throw Exception('Failed to get profile: ${response.statusCode} - ${response.body}');
    } catch (e) {
      // Network error - fallback to Supabase
      debugPrint('⚠️ Backend API error, falling back to Supabase: $e');
      return await _getProfileFromSupabase();
    }
  }

  /// Fallback: Get profile directly from Supabase
  Future<Profile> _getProfileFromSupabase() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return Profile.fromJson(data);
  }

  @override
  Future<Profile> updateProfile(UpdateProfileRequest request) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Direct Supabase update (RLS protects this)
    final data = await _supabase
        .from('profiles')
        .update(request.toJson())
        .eq('id', userId)
        .select()
        .single();

    return Profile.fromJson(data);
  }

  @override
  Future<PublicProfile> getPublicProfile(String userId) async {
    final data = await _supabase
        .from('profiles')
        .select('id, display_name, avatar_url, is_edu_verified, consistency_score')
        .eq('id', userId)
        .single();

    return PublicProfile.fromJson(data);
  }
}
