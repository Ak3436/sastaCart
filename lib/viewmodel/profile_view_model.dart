import 'package:flutter/material.dart';

import '../model/user_profile_model.dart';
import '../repository/profile_repository.dart';

/// =========================
/// PROFILE VIEW MODEL
/// =========================
/// Owns all state for [ProfileScreen].
/// Extends [ChangeNotifier] so the UI rebuilds automatically whenever
/// [notifyListeners] is called.
///
/// Responsibilities:
///   • Invoke the repository
///   • Manage loading / error / data states
///   • Expose computed properties the UI can read directly
class ProfileViewModel extends ChangeNotifier {

  // ── Dependencies ─────────────────────────────────────────────────

  /// =========================
  /// REPOSITORY
  /// =========================
  final ProfileRepository repository;

  ProfileViewModel({ProfileRepository? repository})
      : repository = repository ?? ProfileRepository();

  // ── State fields ─────────────────────────────────────────────────

  /// =========================
  /// LOADING STATE
  /// =========================
  /// True while the API call is in flight; drives the shimmer loader.
  bool isLoading = false;

  /// =========================
  /// ERROR MESSAGE
  /// =========================
  /// Non-empty when the API call failed; drives the error widget.
  String errorMessage = '';

  /// =========================
  /// USER DATA
  /// =========================
  /// Null until the API responds successfully.
  UserProfileModel? user;

  // ── API methods ──────────────────────────────────────────────────

  /// =========================
  /// GET PROFILE API
  /// =========================
  /// Fetches user data for [userId].
  /// 1. Sets [isLoading] → true and notifies so the shimmer shows.
  /// 2. Calls the repository.
  /// 3. On success, stores the [UserProfileModel].
  /// 4. On failure, stores the error message.
  /// 5. Always clears [isLoading] and notifies a final rebuild.
  Future<void> getUserProfile(int userId) async {
    try {

      // --- show shimmer ---
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await repository.getUserProfile(userId);

      user = response;

    } catch (e) {

      /// Expose a human-readable message; strip the "Exception:" prefix
      /// that Dart prepends to generic exceptions.
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    // --- hide shimmer and re-render with data or error ---
    isLoading = false;
    notifyListeners();
  }

  // ── Computed helpers ─────────────────────────────────────────────

  /// Formats the ISO birth-date string (e.g. "1990-05-17") into a
  /// human-readable form like "17 May 1990".
  String get formattedBirthDate {
    if (user == null || user!.birthDate.isEmpty) return '-';
    try {
      final parts = user!.birthDate.split('-');
      if (parts.length < 3) return user!.birthDate;
      final months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final month = int.tryParse(parts[1]) ?? 0;
      return '${parts[2]} ${months[month]} ${parts[0]}';
    } catch (_) {
      return user!.birthDate;
    }
  }
}
