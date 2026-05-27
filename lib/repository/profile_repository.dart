

import 'package:demo_flutter/network/api_service.dart';

import '../model/user_profile_model.dart';

class ProfileRepository {

  /// =========================
  /// API SERVICE OBJECT
  /// =========================
  final ApiService apiService =
  ApiService();

  /// =========================
  /// REPOSITORY LOGIC
  /// =========================
  Future<UserProfileModel>
  getUserProfile(int userId) async {

    return await apiService.getUserProfile(userId);
  }
}