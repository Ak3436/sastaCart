import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  static const String isLoginKey =
      "isLogin";

  static const String userDataKey =
      "userData";

  static const String accessTokenKey =
      "accessToken";

  /// Save Login Session
  static Future<void> saveLoginSession({

    required Map<String, dynamic>
    userData,

    required String accessToken,

  }) async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      isLoginKey,
      true,
    );

    await prefs.setString(
      accessTokenKey,
      accessToken,
    );

    await prefs.setString(
      userDataKey,
      jsonEncode(userData),
    );
  }

  /// Check Login
  static Future<bool> isLoggedIn() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(isLoginKey) ??
        false;
  }

  /// Get User Data
  static Future<Map<String, dynamic>?>
  getUserData() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    String? userData =
    prefs.getString(userDataKey);

    if (userData != null) {

      return jsonDecode(userData);
    }

    return null;
  }

  /// Get Access Token
  static Future<String?> getAccessToken()
  async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      accessTokenKey,
    );
  }

  /// Logout
  static Future<void> logout() async {

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.clear();
  }
}