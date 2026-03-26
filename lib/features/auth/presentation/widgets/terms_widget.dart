import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/constants/constants_exports.dart';

class TermsWidget extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final VoidCallback onTermsTapped;

  const TermsWidget({
    super.key,
    required this.onChanged,
    required this.onTermsTapped,
  });

  @override
  State<TermsWidget> createState() => _TermsWidgetState();
}

class _TermsWidgetState extends State<TermsWidget> {
  bool _isTermsAccepted = false;

  void _toggleTerms() {
    setState(() {
      _isTermsAccepted = !_isTermsAccepted;
    });
    widget.onChanged(_isTermsAccepted);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 19,
          height: 19,
          child: Checkbox(
            value: _isTermsAccepted,
            activeColor: context.colors.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: BorderSide(color: context.colors.hint, width: 1.5),
            onChanged: (val) {
              _toggleTerms();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.iAgreeTo,
                  style: AppTypography.label12Regular.copyWith(
                    color: context.colors.hint,
                    height: 1.5,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _toggleTerms,
                ),
                TextSpan(
                  text: AppStrings.termsAndPrivacy,
                  style: AppTypography.label12Regular.copyWith(
                    color: context.colors.hint,
                    decoration: TextDecoration.underline,
                    decorationColor: context.colors.hint,
                  ),
                  recognizer:
                      TapGestureRecognizer()..onTap = widget.onTermsTapped,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
