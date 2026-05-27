import 'dart:async';

import 'package:demo_flutter/screens/home_screen.dart';
import 'package:demo_flutter/session/session_manager.dart';
import 'package:demo_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
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

    checkLogin();
  }

  Future<void> checkLogin() async {

    bool isLogin =
    await SessionManager.isLoggedIn();

    Timer(const Duration(seconds: 2), () {

      if (isLogin) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
            const HomeScreen(),
          ),
        );

      } else {

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

            Image.asset(

              'assets/images/sastalogo.png',

              width: 100,

              height: 100,

              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            Text(

              AppStrings.appName,

              style:
              AppTextStyles.appnameHead,
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
