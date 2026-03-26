import 'package:flutter/material.dart';

/// Design system shadows exported from Figma
class AppShadows {
  AppShadows._();

  /// Shadow used for cards across the app.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000), // semi-transparent black
      blurRadius: 10,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];

  // ==================== Light Theme Shadows ====================
  static final AppShadowScheme light = AppShadowScheme(
    // الظل الأسود العادي (كما كان في الكود القديم)
    card: [
      const BoxShadow(
        color: Color(0x1A000000), // 10% opacity black
        offset: Offset(0, 1),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ],
    // ظل البوتوم شيت الأسود
    bottomSheet: [
      const BoxShadow(
        color: Color(0x26000000), // 15% opacity black
        offset: Offset(0, 0),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ],
    // ظل الدروب شادو الأسود
    dropShadow: [
      const BoxShadow(
        color: Color(0x33000000), // 20% opacity black
        offset: Offset(0, 1),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ],
  );

  // ==================== Dark Theme Shadows ====================
  static final AppShadowScheme dark = AppShadowScheme(
    // ✅ هنا استخدمنا card2 (الظل الأبيض) ليكون هو ظل الكارد في الوضع الليلي
    card: [
      // const BoxShadow(
      //   color: Color(0x4DFFFFFF), // 30% opacity WHITE (كان card2 سابقاً)
      //   offset: Offset(0, 1),
      //   blurRadius: 4,
      //   spreadRadius: 0,
      // ),
    ],
    // في الوضع الليلي، عادة لا نستخدم ظلال للبوتوم شيت لأن الخلفية سوداء
    // لكن يمكنك استخدام ظل أبيض خفيف جداً لو أردت، هنا سأجعله فارغاً للأناقة
    bottomSheet: [],

    // كذلك الدروب شادو، غالباً لا يظهر في الليلي
    dropShadow: [],
  );
}

/// كلاس يحمل تعريفات أنواع الظلال
class AppShadowScheme {
  final List<BoxShadow> card;
  final List<BoxShadow> bottomSheet;
  final List<BoxShadow> dropShadow;

  AppShadowScheme({
    required this.card,
    required this.bottomSheet,
    required this.dropShadow,
  });
}

/// Extension لاستدعاء الظلال بسهولة عبر الـ context
extension AppShadowsExtension on BuildContext {
  /// Get the current shadow scheme based on theme brightness
  AppShadowScheme get shadows {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.light ? AppShadows.light : AppShadows.dark;
  }
}
