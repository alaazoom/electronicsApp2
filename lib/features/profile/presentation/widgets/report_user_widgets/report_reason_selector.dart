import 'package:flutter/material.dart';
import '../../../../../configs/theme/app_colors.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/widgets/custom_textfield.dart';

class ReportReasonSelector extends StatelessWidget {
  const ReportReasonSelector({
    super.key,
    required this.reasons,
    required this.selectedIndex,
    required this.onChanged,
    required this.textController,
  });

  final List<String> reasons;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(reasons.length, (index) {
        final widgets = <Widget>[
          RadioListTile<int>(
            value: index,
            groupValue: selectedIndex,
            activeColor: context.colors.mainColor,
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              reasons[index],
              style: AppTypography.body16Regular.copyWith(
                color: context.colors.titles,
              ),
            ),
            onChanged: (int? value) => onChanged(value!),
          ),
        ];

        if (selectedIndex == reasons.length - 1 &&
            index == reasons.length - 1) {
          widgets.add(
            CustomTextField(
              controller: textController,
              hintText: "Please describe the issue..",
              maxLines: 5,
              maxLength: 500,
            ),
          );
        }
        return Column(children: widgets);
      }),
    );
  }
}
