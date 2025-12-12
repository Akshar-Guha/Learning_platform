import '../models/squad.dart';

/// Squad repository interface - Clean Architecture contract
abstract class SquadRepository {
  /// Get all squads for the current user
  Future<List<Squad>> getMySquads();

  /// Get squad details with members
  Future<SquadDetail> getSquadDetail(String squadId);

  /// Create a new squad
  Future<Squad> createSquad(CreateSquadRequest request);

  /// Update squad (owner only)
  Future<Squad> updateSquad(String squadId, UpdateSquadRequest request);

  /// Delete squad (owner only)
  Future<void> deleteSquad(String squadId);

  /// Join squad via invite code
  Future<Squad> joinSquad(JoinSquadRequest request);

  /// Leave or kick member from squad
  Future<void> removeMember(String squadId, String userId);

  /// Regenerate invite code (owner only)
  Future<String> regenerateInviteCode(String squadId);
}
