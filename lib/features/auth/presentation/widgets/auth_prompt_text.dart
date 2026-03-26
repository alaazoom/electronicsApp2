import 'package:flutter/material.dart';
import '../../../../configs/theme/theme_exports.dart';

class AuthPromptText extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onTap;

  const AuthPromptText({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: AppTypography.body16Regular.copyWith(
            color: context.colors.text,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: AppTypography.body16Medium.copyWith(
              color: context.colors.text,
            ),
          ),
        ),
      ],
    );
  }
}
