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
    final response = await _supabase.functions.invoke(
      'profile-proxy',
      body: {
        'method': 'GET',
        'endpoint': '$_baseUrl/profile/me',
        'headers': _headers,
      },
    );

    // If edge function not set up, try direct Supabase query as fallback
    if (response.status != 200) {
      // Direct query to profiles table
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

    return Profile.fromJson(response.data as Map<String, dynamic>);
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
