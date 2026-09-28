import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Assembles the single, light-only ThemeData from the token files.
ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.paper,
    fontFamily: 'IBM Plex Sans',
    textTheme: const TextTheme(
      displayLarge: AppText.display,
      displayMedium: AppText.display,
      displaySmall: AppText.display,
      headlineLarge: AppText.title,
      headlineMedium: AppText.title,
      headlineSmall: AppText.heading,
      titleLarge: AppText.title,
      titleMedium: AppText.heading,
      titleSmall: AppText.heading,
      bodyLarge: AppText.body,
      bodyMedium: AppText.body,
      bodySmall: AppText.caption,
      labelLarge: AppText.label,
      labelMedium: AppText.label,
      labelSmall: AppText.label,
    ),
    // iOS-native push transition on both platforms — no router package.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
