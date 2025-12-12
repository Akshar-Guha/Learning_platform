import '../../domain/models/profile.dart';

/// Repository interface for profile operations
/// Following Clean Architecture - this is the contract between data and domain layers
abstract class ProfileRepository {
  /// Get the current authenticated user's profile
  Future<Profile> getCurrentProfile();

  /// Update the current user's profile
  Future<Profile> updateProfile(UpdateProfileRequest request);

  /// Get a public profile by user ID
  Future<PublicProfile> getPublicProfile(String userId);
}
