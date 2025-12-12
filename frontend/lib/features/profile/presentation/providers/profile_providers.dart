import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Profile repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileRepositoryImpl(supabase: supabase);
});

/// Current user profile provider - fetches and caches the logged-in user's profile
final currentUserProfileProvider = FutureProvider<Profile?>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  
  if (!isAuthenticated) {
    return null;
  }

  final repository = ref.watch(profileRepositoryProvider);
  return repository.getCurrentProfile();
});

/// Profile update notifier - handles profile mutations
class ProfileNotifier extends StateNotifier<AsyncValue<Profile?>> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final isAuthenticated = _ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getCurrentProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
    String? timezone,
  }) async {
    try {
      final request = UpdateProfileRequest(
        displayName: displayName,
        avatarUrl: avatarUrl,
        timezone: timezone,
      );
      final updated = await _repository.updateProfile(request);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadProfile();
  }
}

/// Profile notifier provider - for mutations
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Profile?>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository, ref);
});

/// Public profile provider - for viewing other users
final publicProfileProvider =
    FutureProvider.family<PublicProfile, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getPublicProfile(userId);
});
