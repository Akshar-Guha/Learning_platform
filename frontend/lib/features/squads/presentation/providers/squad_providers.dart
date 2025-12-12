import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../data/repositories/squad_repository_impl.dart';
import '../../domain/models/squad.dart';
import '../../domain/repositories/squad_repository.dart';

/// Squad repository provider
final squadRepositoryProvider = Provider<SquadRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SquadRepositoryImpl(supabase: supabase);
});

/// User's squads list provider
final userSquadsProvider = FutureProvider<List<Squad>>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return [];

  final repository = ref.watch(squadRepositoryProvider);
  return repository.getMySquads();
});

/// Squad detail provider (family - takes squadId)
final squadDetailProvider = FutureProvider.family<SquadDetail, String>((ref, squadId) async {
  final repository = ref.watch(squadRepositoryProvider);
  return repository.getSquadDetail(squadId);
});

/// Squad operations notifier for mutations
class SquadNotifier extends StateNotifier<AsyncValue<void>> {
  final SquadRepository _repository;
  final Ref _ref;

  SquadNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<Squad> createSquad({required String name, String? description}) async {
    state = const AsyncValue.loading();
    try {
      final request = CreateSquadRequest(name: name, description: description);
      final squad = await _repository.createSquad(request);
      state = const AsyncValue.data(null);
      _ref.invalidate(userSquadsProvider); // Refresh list
      return squad;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Squad> joinSquad(String inviteCode) async {
    state = const AsyncValue.loading();
    try {
      final request = JoinSquadRequest(inviteCode: inviteCode.toUpperCase().trim());
      final squad = await _repository.joinSquad(request);
      state = const AsyncValue.data(null);
      _ref.invalidate(userSquadsProvider);
      return squad;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> leaveSquad(String squadId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeMember(squadId, userId);
      state = const AsyncValue.data(null);
      _ref.invalidate(userSquadsProvider);
      _ref.invalidate(squadDetailProvider(squadId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> kickMember(String squadId, String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeMember(squadId, userId);
      state = const AsyncValue.data(null);
      _ref.invalidate(squadDetailProvider(squadId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteSquad(String squadId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteSquad(squadId);
      state = const AsyncValue.data(null);
      _ref.invalidate(userSquadsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<String> regenerateCode(String squadId) async {
    state = const AsyncValue.loading();
    try {
      final newCode = await _repository.regenerateInviteCode(squadId);
      state = const AsyncValue.data(null);
      _ref.invalidate(squadDetailProvider(squadId));
      return newCode;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Squad notifier provider
final squadNotifierProvider = StateNotifierProvider<SquadNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(squadRepositoryProvider);
  return SquadNotifier(repository, ref);
});
