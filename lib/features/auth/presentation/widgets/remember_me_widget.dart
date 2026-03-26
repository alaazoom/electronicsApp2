import 'package:flutter/material.dart';
import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/constants/constants_exports.dart';

class RememberMeWidget extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final VoidCallback onForgotPasswordTapped;

  const RememberMeWidget({
    super.key,
    required this.onChanged,
    required this.onForgotPasswordTapped,
  });

  @override
  State<RememberMeWidget> createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<RememberMeWidget> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 19,
          height: 19,
          child: Checkbox(
            value: _rememberMe,
            activeColor: context.colors.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: BorderSide(color: context.colors.hint, width: 1.5),
            onChanged: (val) {
              setState(() {
                _rememberMe = val ?? false;
              });
              widget.onChanged(_rememberMe);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.rememberMe,
                style: AppTypography.body14Regular.copyWith(
                  color: context.colors.text,
                ),
              ),
              GestureDetector(
                onTap: widget.onForgotPasswordTapped,
                child: Text(
                  AppStrings.forgotPassword,
                  style: AppTypography.body14Medium.copyWith(
                    color: context.colors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
