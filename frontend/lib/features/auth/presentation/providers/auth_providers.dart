import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../data/services/auth_service.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthService(supabase: supabase);
});

/// Auth state for UI
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final User? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}

/// Auth notifier for handling auth operations
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Ref _ref;
  
  /// Flag to prevent race condition where authStateProvider's loading event
  /// overwrites the initial session check result
  bool _initialCheckDone = false;

  AuthNotifier(this._authService, this._ref) : super(const AuthState()) {
    _init();
  }

  void _init() {
    // CRITICAL: Check initial session IMMEDIATELY
    // The issue was that _ref.listen() only fires on CHANGES, not initial value
    _checkInitialSession();

    // Also listen to auth state changes for future courses
    _ref.listen(authStateProvider, (previous, next) {
      debugPrint('🔐 AuthNotifier: Stream event: ${next.valueOrNull?.event} Session: ${next.valueOrNull?.session != null}');
      next.when(
        data: (authState) {
          if (authState.session != null) {
            debugPrint('🔐 AuthNotifier: Transitioning to AUTHENTICATED');
            state = AuthState(
              status: AuthStatus.authenticated,
              user: authState.session!.user,
            );
          } else {
            debugPrint('🔐 AuthNotifier: Stream says NO SESSION -> UNAUTHENTICATED');
            state = const AuthState(status: AuthStatus.unauthenticated);
          }
        },
        loading: () {
          // FIX: Only set loading if initial check hasn't completed yet
          debugPrint('🔐 AuthNotifier: Stream LOADING event. InitialCheckDone: $_initialCheckDone');
          if (!_initialCheckDone) {
            state = const AuthState(status: AuthStatus.loading);
          } else {
             debugPrint('🔐 AuthNotifier: IGNORING loading event (Initial check already done)');
          }
        },
        error: (e, st) {
          debugPrint('🔐 AuthNotifier: Stream ERROR: $e');
          state = AuthState(
            status: AuthStatus.error,
            errorMessage: e.toString(),
          );
        },
      );
    });
  }

  void _checkInitialSession() {
    // Mark initial check as done FIRST to prevent race condition
    _initialCheckDone = true;
    
    // Check if there's already a session in Supabase
    final currentSession = _authService.currentSession;
    if (currentSession != null) {
      state = AuthState(
        status: AuthStatus.authenticated,
        user: currentSession.user,
      );
    } else {
      // No existing session - user needs to log in
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        user: response.user,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        user: response.user,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _authService.signOut();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  bool isEduEmail(String email) {
    return _authService.isEduEmail(email);
  }
}

/// Auth notifier provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});
