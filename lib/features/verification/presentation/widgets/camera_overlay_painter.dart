import 'dart:ui';
import 'package:flutter/material.dart';

class CameraOverlayPainter extends CustomPainter {
  final Color overlayColor;

  CameraOverlayPainter({
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 255),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double margin = 12.0;
    final double width = size.width - (margin * 2);
    final double height = width * 0.80;

    final Rect cutoutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 - 40),
      width: width,
      height: height,
    );

    final Path backgroundPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path cutoutPath =
        Path()..addRRect(
          RRect.fromRectAndRadius(cutoutRect, const Radius.circular(12)),
        );

    final Path finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final Paint paint =
        Paint()
          ..color = overlayColor
          ..style = PaintingStyle.fill;

    canvas.drawPath(finalPath, paint);

    final Paint borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    _drawDashedRect(
      canvas,
      borderPaint,
      RRect.fromRectAndRadius(cutoutRect, const Radius.circular(12)),
    );
  }

  void _drawDashedRect(Canvas canvas, Paint paint, RRect rrect) {
    Path path = Path()..addRRect(rrect);

    Path dashPath = Path();
    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
