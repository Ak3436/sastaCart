import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class EdgeToEdge {
  const EdgeToEdge._();

  static Future<void> configureSystemUi() {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.blue,
    systemNavigationBarColor: Colors.blue,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
  );

  static const SystemUiOverlayStyle onPrimarySystemUiOverlayStyle =
      SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        systemNavigationBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      );

  static const EdgeInsets screenPadding = EdgeInsets.all(15);
  static const EdgeInsets listPadding = EdgeInsets.fromLTRB(14, 14, 14, 14);
}

class EdgeToEdgeBody extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const EdgeToEdgeBody({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }
}

class EdgeToEdgeBottomBar extends StatelessWidget {
  final Widget child;
  final Color color;

  const EdgeToEdgeBottomBar({
    super.key,
    required this.child,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: SafeArea(top: false, child: child),
    );
  }
}

EdgeInsets edgeToEdgeScrollPadding(
  BuildContext context, {
  double left = 0,
  double top = 0,
  double right = 0,
  double bottom = 0,
}) {
  final viewPadding = MediaQuery.viewPaddingOf(context);

  return EdgeInsets.fromLTRB(left, top, right, bottom + viewPadding.bottom);
}
