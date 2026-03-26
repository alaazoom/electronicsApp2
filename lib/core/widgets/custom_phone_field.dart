import 'package:flutter/material.dart';
import '../constants/constants_exports.dart';
import 'country_picker_prefix.dart';
import 'custom_textfield.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String> onCountryChanged;
  final String label;
  final String hintText;

  const CustomPhoneField({
    super.key,
    required this.controller,
    required this.validator,
    required this.onCountryChanged,
    this.label = AppStrings.phoneNumber,
    this.hintText = AppStrings.enterPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hintText: hintText,
      isRequired: true,
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.phone,
      prefix: CountryPickerPrefix(onChanged: onCountryChanged),
    );
  }
}
