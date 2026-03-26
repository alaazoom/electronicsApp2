import 'package:flutter/material.dart';

/// Design system typography for mobile
/// Font family: Poppins
class AppTypography {
  AppTypography._();

  static const String _fontFamily = 'Poppins';

  // ==================== Buttons ====================
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static const TextStyle buttonBig = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  // ==================== Headings ====================
  // H2 - 20px
  static const TextStyle h2_20SemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );

  static const TextStyle h2_20Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static const TextStyle h2_20Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  // H3 - 18px
  static const TextStyle h3_18Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );

  static const TextStyle h3_18Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  // ==================== Body Text ====================
  // Body - 16px
  static const TextStyle body16Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const TextStyle body16Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  // Body - 14px
  static const TextStyle body14Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const TextStyle body14Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  // ==================== Labels ====================
  // Labels - 10px
  static const TextStyle label10Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 10,
  );

  static const TextStyle label10Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  // Labels - 12px
  static const TextStyle label12Regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static const TextStyle label12Medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  // Backwards-compatible aliases used in older widgets
  static const TextStyle caption12Regular = label12Regular;
  static const TextStyle h5_20Medium = h2_20Medium;
}
