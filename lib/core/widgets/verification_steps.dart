import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

/// A pill-shaped progress bar with an optional right-side label like "2 / 4".
///
/// Required:
/// - [current], [total]
///
/// Optional properties with Theme defaults:
/// - [fillColor] (defaults to colors.mainColor)
/// - [trackColor] (defaults to colors.border)
///
/// Uses [AppColors], [AppTypography], and [AppSizes] from the custom theme.
class StepsProgressBar extends StatelessWidget {
  const StepsProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.fillColor,
    this.trackColor,
    this.height = 16, // Matches Android XML layout_height="16dp"
    this.borderRadius,
    this.showLabel = true,
    this.labelStyle,
    this.labelBuilder,
    this.labelGap = AppSizes.paddingS, // 12.0 from AppSizes
    this.padding = EdgeInsets.zero,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOut,
    this.clampValue = true,
    this.semanticsLabel,
  });

  /// Current step (e.g., 2).
  final int current;

  /// Total steps (e.g., 4). If <= 0, progress renders as 0%.
  final int total;

  /// Filled portion color. Defaults to colors.mainColor if null.
  final Color? fillColor;

  /// Track (unfilled) color. Defaults to colors.border if null.
  final Color? trackColor;

  /// Height of the bar.
  final double height;

  /// Corner radius. Defaults to a full pill.
  final BorderRadius? borderRadius;

  /// Whether to show the "current / total" label on the right.
  final bool showLabel;

  /// Label style override.
  final TextStyle? labelStyle;

  /// Custom label builder (e.g., "Step 2 of 4").
  final String Function(int current, int total)? labelBuilder;

  /// Gap between bar and label (defaults to AppSizes.paddingS = 12.0).
  final double labelGap;

  /// Outer padding around the whole row.
  final EdgeInsets padding;

  /// Animated fill change duration.
  final Duration animationDuration;

  /// Animated fill curve.
  final Curve animationCurve;

  /// Clamp progress to [0..total] (and avoid over/underflow).
  final bool clampValue;

  /// Optional semantics label for accessibility.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    // Use context.colors extension for theme-aware colors
    final colors = context.colors;

    final Color effectiveFillColor = fillColor ?? colors.mainColor;
    final Color effectiveTrackColor = trackColor ?? colors.border;

    final int safeTotal = total <= 0 ? 0 : total;
    final int safeCurrent = _safeCurrent(current, safeTotal);

    final double progress = (safeTotal == 0) ? 0.0 : (safeCurrent / safeTotal);

    final BorderRadius radius =
        borderRadius ?? BorderRadius.circular(height / 2);

    final String labelText =
        (labelBuilder != null)
            ? labelBuilder!(safeCurrent, safeTotal)
            : '$safeCurrent / $safeTotal';

    // Use AppTypography with theme colors
    final TextStyle effectiveLabelStyle =
        labelStyle ?? AppTypography.body14Medium.copyWith(color: colors.text);

    return Semantics(
      label: semanticsLabel ?? 'Progress $safeCurrent of $safeTotal',
      value: '${(progress * 100).round()}%',
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: radius,
                child: SizedBox(
                  height: height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Track
                      DecoratedBox(
                        decoration: BoxDecoration(color: effectiveTrackColor),
                      ),

                      // Fill (animated)
                      AnimatedFractionallySizedBox(
                        duration: animationDuration,
                        curve: animationCurve,
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: effectiveFillColor,
                            borderRadius: radius,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showLabel) ...[
              SizedBox(width: labelGap),
              Text(labelText, style: effectiveLabelStyle),
            ],
          ],
        ),
      ),
    );
  }

  int _safeCurrent(int value, int safeTotal) {
    if (!clampValue) return value;
    if (safeTotal <= 0) return 0;
    if (value < 0) return 0;
    if (value > safeTotal) return safeTotal;
    return value;
  }
}
