import 'package:flutter/material.dart';

import '../model/user_profile_model.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel
    extends ChangeNotifier {

  /// =========================
  /// REPOSITORY
  /// =========================
  final ProfileRepository
  repository =
  ProfileRepository();

  /// =========================
  /// LOADING
  /// =========================
  bool isLoading = false;

  /// =========================
  /// ERROR MESSAGE
  /// =========================
  String errorMessage = "";

  /// =========================
  /// USER DATA
  /// =========================
  UserProfileModel? user;

  /// =========================
  /// GET PROFILE API
  /// =========================
  /// VIEWMODEL LOGIC
  Future<void> getUserProfile(
      int userId) async {

    try {

      isLoading = true;

      notifyListeners();

      final response =
      await repository
          .getUserProfile(
        userId,
      );

      user = response;

    } catch (e) {

      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }
}