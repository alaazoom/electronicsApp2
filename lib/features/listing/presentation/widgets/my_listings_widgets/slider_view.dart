import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';

class SliderView extends StatefulWidget {
  const SliderView({super.key, required this.min, required this.max});

  final double min;
  final double max;

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  late RangeValues _range;

  @override
  void initState() {
    super.initState();
    _range = RangeValues(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_range.start.round()}',
              style: AppTypography.body14Regular.copyWith(
                color: context.colors.text,
              ),
            ),
            Text(
              '${_range.end.round()}',
              style: AppTypography.body14Regular.copyWith(
                color: context.colors.text,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(
            context,
          ).copyWith(thumbColor: context.colors.mainColor),
          child: RangeSlider(
            values: _range,
            min: widget.min,
            max: widget.max,
            divisions: (widget.max - widget.min).round(),
            activeColor: context.colors.mainColor,
            inactiveColor: context.colors.mainColor10,
            onChanged: (newRange) {
              setState(() {
                _range = newRange;
              });
            },
          ),
        ),
      ],
    );
  }
}
