import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';

class InfoTipsCard extends StatelessWidget {
  const InfoTipsCard({
    super.key,
    required this.title,
    required this.tips,
    this.padding = const EdgeInsets.all(16),
    this.radius = 10,
    this.gap = 16,
    this.bulletGap = 12,
    this.backgroundColor,
    this.titleStyle,
    this.tipStyle,
    this.bulletColor,
    this.bulletSize = 6,
  });

  final String title;
  final List<String> tips;
  final EdgeInsets padding;
  final double radius;
  final double gap;
  final double bulletGap;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? tipStyle;
  final Color? bulletColor;
  final double bulletSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final Color bgColor = backgroundColor ?? colors.mainColor10;
    final Color bulletClr = bulletColor ?? colors.titles;

    final TextStyle effectiveTitleStyle =
        titleStyle ??
        AppTypography.body14Medium.copyWith(
          color: colors.titles,
          fontWeight: FontWeight.w500,
        );

    final TextStyle effectiveTipStyle =
        tipStyle ??
        AppTypography.label12Regular.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w400,
        );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: effectiveTitleStyle),
          SizedBox(height: gap),
          ...tips.map(
            (tip) => Padding(
              padding: EdgeInsets.only(
                bottom: tips.last == tip ? 0 : bulletGap,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top:
                          (effectiveTipStyle.fontSize ?? 12) / 2 -
                          bulletSize / 2,
                    ),
                    child: Container(
                      width: bulletSize,
                      height: bulletSize,
                      decoration: BoxDecoration(
                        color: bulletClr,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(tip, style: effectiveTipStyle)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
