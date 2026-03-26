import 'package:flutter/material.dart';
import '../../configs/theme/theme_exports.dart';
import '../constants/constants_exports.dart';
import 'custom_textfield.dart';

class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hintText;

  const CustomPasswordTextField({
    super.key,
    required this.controller,
    required this.validator,
    this.label = AppStrings.password,
    this.hintText = AppStrings.enterPassword,
  });

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hintText: widget.hintText,
      isRequired: true,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _isObscure,
      suffix: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: Icon(
            _isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: context.colors.icons,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}
