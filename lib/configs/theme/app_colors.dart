import 'package:flutter/material.dart';

/// Design system colors exported from Figma
class AppColors {
  AppColors._();

  // ==================== Basic Colors (Your Design System) ====================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF101010);
  static const Color placeholders = Color(0xFFC7C7C7);
  static const Color border = Color(0xFFE4E4E4);
  static const Color icons = Color(0xFF828282);
  static const Color text = Color(0xFF3D3D3D);
  static const Color titles = Color(0xFF212121);
  static const Color hint = Color(0xFF828282);
  static const Color greyFillButton = Color(0xFFF9FAFB);

  // ==================== Main Colors ====================
  static const Color mainColor = Color(0xFF2563EB);
  static const Color mainColor40 = Color(0x662563EB);
  static const Color mainColor20 = Color(0x332563EB);
  static const Color mainColor10 = Color(0x1A2563EB);
  static const Color mainColor5 = Color(0x0D2563EB);

  // ==================== Secondary Colors ====================
  static const Color secondaryColor = Color(0xFF14B8A6);
  static const Color secondaryColor40 = Color(0x6614B8A6);
  static const Color secondaryColor20 = Color(0x3314B8A6);
  static const Color secondaryColor10 = Color(0x1A14B8A6);
  static const Color secondaryColor5 = Color(0x0D14B8A6);

  // ==================== Status Colors ====================
  static const Color warning = Color(0xFFFACC15);
  static const Color warning20 = Color(0x33FACC15);
  static const Color warning10 = Color(0x1AFACC15);

  static const Color success = Color(0xFF22C55E);
  static const Color success20 = Color(0x3322C55E);
  static const Color success10 = Color(0x1A22C55E);

  static const Color error = Color(0xFFEF4444);
  static const Color error20 = Color(0x33EF4444);
  static const Color error10 = Color(0x1AEF4444);

  static const Color neutral = Color(0xFF6B7280);
  static const Color neutralWithoutTransparent = Color(0xFFD9DBDE);
  static const Color neutral20 = Color(0x336B7280);
  static const Color neutral10 = Color(0x1A6B7280);
  static const Color neutral5 = Color(0x0D6B7280);

  // ==================== Light Theme Colors (Your Design System) ====================
  /// Light theme - uses your exact Figma colors
  static AppColorScheme light = AppColorScheme(
    // Use your original color names
    background: white,
    surface: white,
    titles: titles,
    text: text,
    hint: hint,
    placeholders: placeholders,
    border: border,
    icons: icons,
    greyFillButton: greyFillButton,
    // Main colors with variants
    mainColor: mainColor,
    mainColor40: mainColor40,
    mainColor20: mainColor20,
    mainColor10: mainColor10,
    mainColor5: mainColor5,
    // Secondary colors with variants
    secondaryColor: secondaryColor,
    secondaryColor40: secondaryColor40,
    secondaryColor20: secondaryColor20,
    secondaryColor10: secondaryColor10,
    secondaryColor5: secondaryColor5,
    // Status colors with variants
    error: error,
    error20: error20,
    error10: error10,
    warning: warning,
    warning20: warning20,
    warning10: warning10,
    success: success,
    success20: success20,
    success10: success10,
    neutral: neutral,
    neutral20: neutral20,
    neutral10: neutral10,
    neutral5: neutral5,
    neutralWithoutTransparent: neutralWithoutTransparent,
  );

  // ==================== Dark Theme Colors (Inverted for Dark Mode) ====================
  /// Dark theme - same color names, different values
  static AppColorScheme dark = AppColorScheme(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    titles: Color(0xFFE5E5E5), // Light for dark bg
    text: Color(0xFFB3B3B3), // Light for dark bg
    hint: Color(0xFF808080), // Light for dark bg
    placeholders: Color(0xFF666666), // Light for dark bg
    border: Color(0xFF3D3D3D), // Dark border
    icons: Color(0xFFB3B3B3), // Light icons
    greyFillButton: Color(0xFF2A2A2A), // Dark fill
    // Main colors with variants
    mainColor: Color(0xFF3B82F6), // Brighter for dark bg
    mainColor40: Color(0x663B82F6),
    mainColor20: Color(0x333B82F6),
    mainColor10: Color(0x1A3B82F6),
    mainColor5: Color(0x0D3B82F6),
    // Secondary colors with variants
    secondaryColor: secondaryColor, // Keep same
    secondaryColor40: secondaryColor40,
    secondaryColor20: secondaryColor20,
    secondaryColor10: secondaryColor10,
    secondaryColor5: secondaryColor5,
    // Status colors with variants
    error: Color(0xFFF87171), // Lighter error
    error20: Color(0x33F87171),
    error10: Color(0x1AF87171),
    warning: Color(0xFFFCD34D), // Lighter warning
    warning20: Color(0x33FCD34D),
    warning10: Color(0x1AFCD34D),
    success: Color(0xFF4ADE80), // Lighter success
    success20: Color(0x334ADE80),
    success10: Color(0x1A4ADE80),
    neutral: Color(0xFF9CA3AF), // Lighter neutral
    neutral20: Color(0x339CA3AF),
    neutral10: Color(0x1A9CA3AF),
    neutral5: Color(0x0D9CA3AF),
    neutralWithoutTransparent: Color(0xFF2A2A2A),
  );
}

/// Theme-aware color scheme using your original color names
class AppColorScheme {
  final Color background;
  final Color surface;
  final Color titles;
  final Color text;
  final Color hint;
  final Color placeholders;
  final Color border;
  final Color icons;
  final Color greyFillButton;

  // Main colors with all variants
  final Color mainColor;
  final Color mainColor40;
  final Color mainColor20;
  final Color mainColor10;
  final Color mainColor5;

  // Secondary colors with all variants
  final Color secondaryColor;
  final Color secondaryColor40;
  final Color secondaryColor20;
  final Color secondaryColor10;
  final Color secondaryColor5;

  // Status colors with variants
  final Color error;
  final Color error20;
  final Color error10;
  final Color warning;
  final Color warning20;
  final Color warning10;
  final Color success;
  final Color success20;
  final Color success10;
  final Color neutral;
  final Color neutral20;
  final Color neutral10;
  final Color neutral5;
  final Color neutralWithoutTransparent;

  AppColorScheme({
    required this.background,
    required this.surface,
    required this.titles,
    required this.text,
    required this.hint,
    required this.placeholders,
    required this.border,
    required this.icons,
    required this.greyFillButton,
    required this.mainColor,
    required this.mainColor40,
    required this.mainColor20,
    required this.mainColor10,
    required this.mainColor5,
    required this.secondaryColor,
    required this.secondaryColor40,
    required this.secondaryColor20,
    required this.secondaryColor10,
    required this.secondaryColor5,
    required this.error,
    required this.error20,
    required this.error10,
    required this.warning,
    required this.warning20,
    required this.warning10,
    required this.success,
    required this.success20,
    required this.success10,
    required this.neutral,
    required this.neutral20,
    required this.neutral10,
    required this.neutral5,
    required this.neutralWithoutTransparent,
  });
}

/// Extension to easily access theme-aware colors from BuildContext
extension AppColorsExtension on BuildContext {
  /// Get the current color scheme based on theme
  /// Usage: context.colors.titles, context.colors.text, etc.
  AppColorScheme get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.light ? AppColors.light : AppColors.dark;
  }
}
