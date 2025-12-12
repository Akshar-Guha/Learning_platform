import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication service for Supabase Auth operations
class AuthService {
  final SupabaseClient _supabase;

  AuthService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Sign up with email and password
  /// If email ends with .edu, profile will be automatically marked as verified
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': displayName ?? email.split('@').first,
      },
    );

    if (response.user == null) {
      throw Exception('Sign up failed: No user returned');
    }

    return response;
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign in failed: Invalid credentials');
    }

    return response;
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  /// Check if email is an .edu email
  bool isEduEmail(String email) {
    return email.toLowerCase().endsWith('.edu');
  }

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;
}
