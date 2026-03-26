import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';

class AddressInfoWindow extends StatelessWidget {
  final String address;

  const AddressInfoWindow({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    // ارتفاع المثلث (السهم)
    const double arrowHeight = 15.0;

    return CustomPaint(
      painter: _BubblePainter(
        color: context.colors.surface, // لون الخلفية (أبيض)
        arrowHeight: arrowHeight, // نمرر الارتفاع للرسام
        shadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        width: 250,
        // ✅ التعديل هنا: نزيد البادينج من الأعلى (Top) عشان النص ما يغطي السهم
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingM,
          AppSizes.paddingM + arrowHeight, // ⬅️ زدنا ارتفاع السهم هنا
          AppSizes.paddingM,
          AppSizes.paddingM,
        ),
        child: Text(
          address,
          textAlign: TextAlign.center,
          style: AppTypography.body16Regular.copyWith(
            color: context.colors.text,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;
  final List<BoxShadow>? shadow;
  final double arrowHeight;

  _BubblePainter({required this.color, this.shadow, required this.arrowHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    const double arrowWidth = 24.0;

    // ارتفاع المستطيل هو الارتفاع الكلي ناقص ارتفاع السهم
    final double rectHeight = size.height - arrowHeight;

    final Path path = Path();

    // 1. رسم السهم (المثلث) في الأعلى
    // نبدأ من رأس السهم (في منتصف العرض، وأعلى نقطة y=0)
    final Path arrowPath = Path();
    arrowPath.moveTo(size.width / 2, 0);
    arrowPath.lineTo(
      size.width / 2 + arrowWidth / 2,
      arrowHeight,
    ); // الزاوية اليمنى للسهم
    arrowPath.lineTo(
      size.width / 2 - arrowWidth / 2,
      arrowHeight,
    ); // الزاوية اليسرى للسهم
    arrowPath.close();

    // 2. رسم المستطيل أسفل السهم
    // يبدأ الـ y من arrowHeight وينتهي عند size.height
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, arrowHeight, size.width, rectHeight),
        const Radius.circular(AppSizes.borderRadius),
      ),
    );

    // 3. دمج السهم مع المستطيل
    path.addPath(arrowPath, Offset.zero);

    // 4. رسم الظل
    if (shadow != null) {
      for (final boxShadow in shadow!) {
        canvas.drawShadow(path, boxShadow.color, boxShadow.blurRadius, true);
      }
    }

    // 5. تعبئة الشكل باللون
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
