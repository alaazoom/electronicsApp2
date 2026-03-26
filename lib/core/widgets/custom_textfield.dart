import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/field_label.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final bool isRequired;
  final int maxLines;
  final int? maxLength;
  final String? helperText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Widget? suffix;
  final TextInputAction textInputAction;
  final bool readOnly;
  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.isRequired = false,
    this.maxLines = 1,
    this.maxLength,
    this.helperText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefix,
    this.onChanged,
    this.obscureText = false,
    this.suffix,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,

  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  int _currentLength = 0;
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _currentLength = widget.controller!.text.length;
      widget.controller!.addListener(_updateLength);
    }
  }

  void _updateLength() {
    if (mounted) {
      setState(() {
        _currentLength = widget.controller!.text.length;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateLength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          FieldLabel(label: widget.label!, isRequired: widget.isRequired),
        if (widget.label != null && widget.label!.isNotEmpty)
          const SizedBox(height: AppSizes.paddingXS),
        Stack(
          children: [
            TextFormField(
              textInputAction: widget.textInputAction,
              obscureText: widget.obscureText,
              controller: widget.controller,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              onChanged: (val) {
                setState(() {
                  _currentLength = val.length;
                });
                widget.onChanged?.call(val);
              },
              style: AppTypography.body16Regular.copyWith(color: colors.text),
              decoration: InputDecoration(
                hintText: widget.hintText,
                helperText: widget.helperText,
                counterText: "",
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffix,
                errorMaxLines: 3,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              readOnly:  widget.readOnly,
            ),

            if (widget.maxLength != null)
              Positioned(
                bottom:
                    widget.helperText != null
                        ? AppSizes.paddingXL
                        : AppSizes.paddingXS,
                right: AppSizes.paddingM,
                child: Container(
                  color: Colors.transparent,
                  child: Text(
                    "($_currentLength/${widget.maxLength})",
                    style: AppTypography.label10Regular.copyWith(
                      color: colors.hint,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
