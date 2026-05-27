import 'package:demo_flutter/screens/splash_screen.dart';
import 'package:demo_flutter/utils/app_colors.dart';
import 'package:demo_flutter/utils/edge_to_edge.dart';
import 'package:demo_flutter/utils/app_text_styles.dart';
import 'package:demo_flutter/viewmodel/cart_view_model.dart';
import 'package:demo_flutter/viewmodel/home_view_model.dart';
import 'package:demo_flutter/viewmodel/profile_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EdgeToEdge.configureSystemUi();
  runApp(
    MultiProvider(
      providers: [
        /// HOME VIEW MODEL
        ChangeNotifierProvider(create: (_) => HomeViewModel()),

        /// CART VIEW MODEL
        /// Shared globally so cart count badges update from any screen.
        ChangeNotifierProvider(create: (_) => CartViewModel()),

        /// Profile View MOdel
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: EdgeToEdge.systemUiOverlayStyle,
        ),
        textTheme: const TextTheme(
          headlineLarge: AppTextStyles.heading,
          bodyMedium: AppTextStyles.bodyText,
        ),
      ),

      /// SPLASH SCREEN
      home: const SplashScreen(),
    );
  }
}



