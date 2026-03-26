import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../configs/theme/theme_exports.dart';
import '../constants/constants_exports.dart';

class CountryPickerPrefix extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CountryPickerPrefix({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: CountryCodePicker(
        onChanged: (country) {
          onChanged(country.dialCode ?? AppStrings.palestineDialCode);
        },
        initialSelection: AppStrings.palestineIsoCode,
        favorite: [AppStrings.palestineDialCode, AppStrings.palestineIsoCode],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
        padding: EdgeInsets.zero,
        textStyle: AppTypography.body14Regular.copyWith(
          color: context.colors.mainColor,
        ),
        flagWidth: 22,
      ),
    );
  }
}
