import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../data/repositories/focus_repository_impl.dart';
import '../../domain/models/focus_session.dart';
import '../../domain/repositories/focus_repository.dart';

/// Focus repository provider
final focusRepositoryProvider = Provider<FocusRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FocusRepositoryImpl(supabase: supabase);
});

/// Current user's active focus session
final currentFocusSessionProvider = StateNotifierProvider<CurrentFocusNotifier, AsyncValue<FocusSession?>>((ref) {
  final repository = ref.watch(focusRepositoryProvider);
  return CurrentFocusNotifier(repository);
});

/// Notifier for current focus session
class CurrentFocusNotifier extends StateNotifier<AsyncValue<FocusSession?>> {
  final FocusRepository _repository;

  CurrentFocusNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCurrentSession();
  }

  Future<void> _loadCurrentSession() async {
    try {
      final session = await _repository.getCurrentSession();
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> startFocus(String squadId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.startFocus(squadId);
      // Refresh to get full session data
      await _loadCurrentSession();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> stopFocus() async {
    state = const AsyncValue.loading();
    try {
      await _repository.stopFocus();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadCurrentSession();
  }
}

/// Realtime stream of active focus sessions in a squad
final squadActiveSessionsProvider = StreamProvider.family<List<FocusSession>, String>((ref, squadId) {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.watchActiveSessions(squadId);
});

/// Active focusers with profile info (non-realtime snapshot)
final squadActiveFocusersProvider = FutureProvider.family<List<ActiveFocuser>, String>((ref, squadId) async {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.getActiveFocusers(squadId);
});

/// Focus history for a squad (last 7 days)
final focusHistoryProvider = FutureProvider.family<List<FocusSession>, String>((ref, squadId) async {
  final repository = ref.watch(focusRepositoryProvider);
  return repository.getFocusHistory(squadId);
});

/// Check if current user is focusing in a specific squad
final isCurrentUserFocusingProvider = Provider.family<bool, String>((ref, squadId) {
  final currentSession = ref.watch(currentFocusSessionProvider).valueOrNull;
  if (currentSession == null) return false;
  return currentSession.isActive && currentSession.squadId == squadId;
});
