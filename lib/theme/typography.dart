import 'package:flutter/material.dart';
import 'colors.dart';

class AppText {
  static const display = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.20,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );

  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );

  static const heading = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.60,
    color: AppColors.ink,
  );

  static const bodyStrong = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.55,
    color: AppColors.ink,
  );

  static const caption = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    height: 1.40,
    color: AppColors.inkMuted,
  );

  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.20,
    color: AppColors.ink,
  );

  static const data = TextStyle(
    fontFamily: 'IBM Plex Mono',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.20,
    color: AppColors.ink,
  );
}
