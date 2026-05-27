import 'package:demo_flutter/screens/splash_screen.dart';
import 'package:demo_flutter/utils/app_colors.dart';
import 'package:demo_flutter/utils/edge_to_edge.dart';
import 'package:demo_flutter/utils/app_text_styles.dart';
import 'package:demo_flutter/viewmodel/cart_view_model.dart';
import 'package:demo_flutter/viewmodel/home_view_model.dart';
import 'package:demo_flutter/viewmodel/profile_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ======================================================
/// MAIN METHOD
/// ======================================================
/// App execution yaha se start hota hai.
/// Blank screen issue avoid karne ke liye
/// koi heavy async operation yaha nahi karenge.
/// ======================================================
void main() {

  /// Flutter engine initialize
  WidgetsFlutterBinding.ensureInitialized();

  runApp(

    /// ==================================================
    /// MULTI PROVIDER
    /// ==================================================
    /// Sare ViewModels globally provide kiye gaye hain
    /// taki app me kahi bhi access ho sake.
    /// ==================================================
    MultiProvider(

      providers: [

        /// HOME SCREEN VIEW MODEL
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),

        /// CART VIEW MODEL
        ChangeNotifierProvider(
          create: (_) => CartViewModel(),
        ),

        /// PROFILE VIEW MODEL
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

/// ======================================================
/// ROOT APP
/// ======================================================
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      /// ==================================================
      /// APP THEME
      /// ==================================================
      theme: ThemeData(

        primaryColor: AppColors.primaryColor,

        scaffoldBackgroundColor:
        AppColors.backgroundColor,

        appBarTheme: const AppBarTheme(

          systemOverlayStyle:
          EdgeToEdge.systemUiOverlayStyle,
        ),

        textTheme: const TextTheme(

          headlineLarge:
          AppTextStyles.heading,

          bodyMedium:
          AppTextStyles.bodyText,
        ),
      ),

      /// ==================================================
      /// FIRST SCREEN
      /// ==================================================
      home: const SplashScreen(),
    );
  }
}