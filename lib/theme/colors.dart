import 'package:flutter/material.dart';

class AppColors {
  // Ground
  static const paper = Color(0xFFFDFDFB); // app background
  static const surface = Color(0xFFFFFFFF); // cards, sheets
  static const hairline = Color(0xFFCBD6DC); // borders, rules

  // Chart tints — surfaces only, never text
  static const shoal = Color(0xFFE3EDF2); // pale chart blue (water)
  static const land = Color(0xFFF0E8D8); // chart buff (land)

  // Ink
  static const ink = Color(0xFF16212B); // primary text
  static const inkMuted = Color(0xFF5E7280); // secondary text, captions

  // Primary interactive
  static const depth = Color(0xFF1D4A66); // buttons, links, active nav

  // The accent. Markers, completion, progress. Use sparingly.
  static const beacon = Color(0xFFB12C7D);

  // Supporting
  static const kelp = Color(0xFF4A6B4F); // conservation
  static const hazard = Color(0xFFA8431F); // visitor cautions

  // POI categories — used at 0.12 opacity for chip fills,
  // full opacity for chip text and marker rings.
  static const catShore = Color(0xFF2E7191);
  static const catTrail = Color(0xFF4A6B4F);
  static const catHistoric = Color(0xFF7A5C3E);
  static const catWildlife = Color(0xFF6B7F3F);
  static const catTown = Color(0xFF8C4B3A);

  // Elevation
  static const sheetShadow = Color(0x1416212B); // ink at 8% opacity
}
