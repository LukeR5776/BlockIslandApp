import 'package:flutter/material.dart';
import 'colors.dart';

/// Type scale per DESIGN.md. IBM Plex Sans everywhere except [data], which
/// is IBM Plex Mono for tabular figures (counters, coordinates).
class AppText {
  static const display = TextStyle( // tab screen titles
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.20,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );

  static const title = TextStyle( // POI names, module titles
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );

  static const heading = TextStyle( // section headers, card titles
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.ink,
  );

  static const body = TextStyle( // all prose
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.60,
    color: AppColors.ink,
  );

  static const bodyStrong = TextStyle( // emphasis within prose
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.55,
    color: AppColors.ink,
  );

  static const caption = TextStyle( // metadata, helper text
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    height: 1.40,
    color: AppColors.inkMuted,
  );

  static const label = TextStyle( // category chips, tab labels
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.20,
    color: AppColors.ink,
  );

  static const data = TextStyle( // counters, coordinates
    fontFamily: 'IBM Plex Mono',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.20,
    color: AppColors.ink,
  );
}
