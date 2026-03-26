import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';

class SimpleSelectionOption {
  const SimpleSelectionOption({required this.label, this.enabled = true});
  final String label;
  final bool enabled;
}

class SimpleSelectionList extends StatelessWidget {
  const SimpleSelectionList({
    super.key,
    required this.title,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.titlePadding = const EdgeInsets.only(bottom: 16),
    this.optionSpacing = 12,
    this.optionPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.radius = 12,
    this.borderWidth = 1,
    this.backgroundColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.titleStyle,
    this.optionTextStyle,
    this.disabledOpacity = 0.45,
    this.indicatorSize = 24,
    this.indicatorStrokeWidth = 2,
    this.indicatorColor,
    this.optionHeight = 48,
    this.showSelectedShadow = true,
  });

  final String title;
  final List<SimpleSelectionOption> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  final EdgeInsets padding;
  final EdgeInsets titlePadding;
  final double optionSpacing;
  final EdgeInsets optionPadding;
  final double radius;
  final double borderWidth;
  final double optionHeight;

  final Color? backgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final TextStyle? titleStyle;
  final TextStyle? optionTextStyle;
  final double disabledOpacity;
  final bool showSelectedShadow;

  final double indicatorSize;
  final double indicatorStrokeWidth;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color primary = indicatorColor ?? colors.mainColor;
    final Color selBorder = selectedBorderColor ?? colors.mainColor;
    final Color unselBorder = unselectedBorderColor ?? colors.hint;
    final Color selTextColor = selectedTextColor ?? colors.text;
    final Color unselTextColor = unselectedTextColor ?? colors.hint;
    final Color bgColor = backgroundColor ?? colors.surface;

    final TextStyle effectiveTitleStyle =
        titleStyle ??
        AppTypography.h3_18Medium.copyWith(
          color: colors.titles,
          fontWeight: FontWeight.w600,
        );

    final TextStyle baseOptionStyle =
        optionTextStyle ??
        AppTypography.body16Regular.copyWith(fontWeight: FontWeight.w400);

    final Color shadowColor =
        isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.25);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.trim().isNotEmpty)
            Padding(
              padding: titlePadding,
              child: Text(title, style: effectiveTitleStyle),
            ),
          ...List.generate(options.length, (i) {
            final opt = options[i];
            final bool selected = i == selectedIndex;

            final Color borderColor = selected ? selBorder : unselBorder;
            final Color textColor = selected ? selTextColor : unselTextColor;

            final TextStyle textStyle = baseOptionStyle.copyWith(
              color:
                  opt.enabled
                      ? textColor
                      : textColor.withOpacity(disabledOpacity),
            );

            final List<BoxShadow>? shadows =
                (selected && showSelectedShadow)
                    ? [
                      BoxShadow(
                        color: shadowColor,
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ]
                    : null;

            return Padding(
              padding: EdgeInsets.only(
                bottom: i == options.length - 1 ? 0 : optionSpacing,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(radius),
                  onTap: opt.enabled ? () => onChanged(i) : null,
                  child: Container(
                    height: optionHeight,
                    padding: optionPadding,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: borderColor,
                        width: borderWidth,
                      ),
                      boxShadow: shadows,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(opt.label, style: textStyle)),
                        _RadioIndicator(
                          selected: selected,
                          size: indicatorSize,
                          strokeWidth: indicatorStrokeWidth,
                          selectedColor: primary,
                          unselectedColor: colors.hint,
                          disabled: !opt.enabled,
                          disabledOpacity: disabledOpacity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({
    required this.selected,
    required this.size,
    required this.strokeWidth,
    required this.selectedColor,
    required this.unselectedColor,
    required this.disabled,
    required this.disabledOpacity,
  });

  final bool selected;
  final double size;
  final double strokeWidth;
  final Color selectedColor;
  final Color unselectedColor;
  final bool disabled;
  final double disabledOpacity;

  @override
  Widget build(BuildContext context) {
    final Color ring = selected ? selectedColor : unselectedColor;

    final Color effectiveRing =
        disabled ? ring.withOpacity(disabledOpacity) : ring;
    final Color effectiveDot =
        disabled ? selectedColor.withOpacity(disabledOpacity) : selectedColor;

    final double innerDotSize = size * 0.45;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: effectiveRing, width: strokeWidth),
            ),
          ),
          if (selected)
            Container(
              width: innerDotSize,
              height: innerDotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: effectiveDot,
              ),
            ),
        ],
      ),
    );
  }
}
