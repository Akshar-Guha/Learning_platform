import '../models/focus_session.dart';

/// Focus repository interface - Clean Architecture contract
abstract class FocusRepository {
  /// Start a focus session in a squad
  Future<StartFocusResponse> startFocus(String squadId);

  /// Stop the current focus session
  Future<StopFocusResponse> stopFocus();

  /// Get currently active focusers in a squad
  Future<List<ActiveFocuser>> getActiveFocusers(String squadId);

  /// Get focus session history for a squad (last 7 days)
  Future<List<FocusSession>> getFocusHistory(String squadId);

  /// Get current user's active session (if any)
  Future<FocusSession?> getCurrentSession();

  /// Stream of active sessions in a squad (Realtime)
  Stream<List<FocusSession>> watchActiveSessions(String squadId);
}
