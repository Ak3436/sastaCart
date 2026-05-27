import 'dart:async';

import 'package:demo_flutter/screens/home_screen.dart';
import 'package:demo_flutter/session/session_manager.dart';
import 'package:demo_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import '../utils/edge_to_edge.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    /// ============================================
    /// APP INITIALIZATION
    /// ============================================
    /// Splash screen instantly show karne ke liye
    /// saare initialization yaha perform honge.
    /// ============================================
    initializeApp();
  }

  /// ============================================
  /// INITIALIZE APP
  /// ============================================
  Future<void> initializeApp() async {

    /// ==========================================
    /// SYSTEM UI SETUP
    /// ==========================================
    /// Status bar and navigation bar setup
    /// ==========================================
    await EdgeToEdge.configureSystemUi();

    /// Small delay for smooth rendering
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    /// Login check
    checkLogin();
  }

  /// ============================================
  /// CHECK LOGIN STATUS
  /// ============================================
  Future<void> checkLogin() async {

    /// SharedPreference se login status check
    bool isLogin =
    await SessionManager.isLoggedIn();

    /// Splash Delay
    Timer(const Duration(seconds: 2), () {

      /// ========================================
      /// IF USER ALREADY LOGIN
      /// ========================================
      if (isLogin) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
            const HomeScreen(),
          ),
        );

      } else {

        /// ======================================
        /// IF USER NOT LOGIN
        /// ======================================
        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
            const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.primaryColor,

      body: Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            /// ==================================
            /// APP LOGO
            /// ==================================
            Image.asset(

              'assets/images/sastalogo.png',

              width: 110,

              height: 110,

              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            /// ==================================
            /// APP NAME
            /// ==================================
            Text(

              AppStrings.appName,

              style:
              AppTextStyles.appnameHead,
            ),

            const SizedBox(height: 25),

            /// ==================================
            /// LOADING INDICATOR
            /// ==================================
            const CircularProgressIndicator(

              color: Colors.white,

              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}