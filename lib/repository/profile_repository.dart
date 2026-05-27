import 'package:demo_flutter/network/api_service.dart';

import '../model/user_profile_model.dart';

/// =========================
/// PROFILE REPOSITORY
/// =========================
/// Acts as the single source-of-truth for profile data.
/// The ViewModel should NEVER call [ApiService] directly; it always
/// goes through the repository so caching / offline logic can be
/// added here later without touching the ViewModel.
class ProfileRepository {

  /// =========================
  /// API SERVICE DEPENDENCY
  /// =========================
  /// Injected via the constructor in production; overridable in tests.
  final ApiService apiService;

  ProfileRepository({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  /// =========================
  /// FETCH USER PROFILE
  /// =========================
  /// Delegates to [ApiService.getUserProfile] and returns the fully
  /// typed [UserProfileModel] to the ViewModel.
  Future<UserProfileModel> getUserProfile(int userId) async {
    return await apiService.getUserProfile(userId);
  }
}
