import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';

/// A simple summary card like the Figma "Activity Summary".
///
/// Shows:
/// - title (e.g. "10 hours")
/// - subtitle (e.g. "Avg. response")
///
/// Theme-friendly by default using [AppColors], [AppTypography], and [AppSizes].
class ActivitySummaryCard extends StatelessWidget {
  const ActivitySummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2, // 2.0 from AppSizes
    this.radius = 10, // 10.0 from AppSizes
    this.padding = const EdgeInsets.all(
      AppSizes.paddingM,
    ), // 16.0 from AppSizes
    this.titleStyle,
    this.subtitleStyle,
    this.titleColor,
    this.subtitleColor,
    this.gap = AppSizes.paddingS, // 12.0 from AppSizes (Figma spacing)
    this.elevation = 0,
    this.shadowColor,
    this.onTap,
    this.semanticsLabel,
  });

  /// Main text (e.g. "10 hours")
  final String title;

  /// Secondary text (e.g. "Avg. response")
  final String subtitle;

  /// Card background color (defaults to colors.surface).
  final Color? backgroundColor;

  /// Border color (defaults to colors.border).
  final Color? borderColor;

  /// Border width (defaults to AppSizes.borderWidthCard = 2.0).
  final double borderWidth;

  /// Corner radius (defaults to AppSizes.borderRadiusCard = 10.0).
  final double radius;

  /// Inner padding (defaults to AppSizes.paddingM = 16.0).
  final EdgeInsets padding;

  /// Override title TextStyle (wins over [titleColor]).
  final TextStyle? titleStyle;

  /// Override subtitle TextStyle (wins over [subtitleStyle]).
  final TextStyle? subtitleStyle;

  /// Optional title color override (used only if [titleStyle] is null).
  final Color? titleColor;

  /// Optional subtitle color override (used only if [subtitleStyle] is null).
  final Color? subtitleColor;

  /// Space between title and subtitle (defaults to AppSizes.paddingXS = 8.0).
  final double gap;

  /// Simple shadow elevation. 0 = no shadow.
  final double elevation;

  /// Shadow color (defaults to theme shadowColor).
  final Color? shadowColor;

  /// Optional tap handler.
  final VoidCallback? onTap;

  /// Optional accessibility label.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    // Use context.colors extension to get theme-aware colors
    final colors = context.colors;

    final Color bg = backgroundColor ?? colors.surface;
    final Color bdr = borderColor ?? colors.border;

    // Use AppTypography with theme colors
    final TextStyle effectiveTitleStyle =
        titleStyle ??
        AppTypography.body16Medium.copyWith(color: titleColor ?? colors.titles);

    final TextStyle effectiveSubtitleStyle =
        subtitleStyle ??
        AppTypography.label12Regular.copyWith(
          color: subtitleColor ?? colors.text,
        );

    final BorderRadius br = BorderRadius.circular(radius);

    Widget card = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: br,
        border: Border.all(color: bdr, width: borderWidth),
        boxShadow:
            elevation > 0
                ? [
                  BoxShadow(
                    color: (shadowColor ?? Theme.of(context).shadowColor)
                        .withOpacity(0.12),
                    blurRadius: 12 * elevation,
                    offset: Offset(0, 3 * elevation),
                  ),
                ]
                : null,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: effectiveTitleStyle),
          SizedBox(height: gap),
          Text(subtitle, style: effectiveSubtitleStyle),
        ],
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(borderRadius: br, onTap: onTap, child: card),
      );
    }

    return Semantics(label: semanticsLabel ?? '$title, $subtitle', child: card);
  }
}
