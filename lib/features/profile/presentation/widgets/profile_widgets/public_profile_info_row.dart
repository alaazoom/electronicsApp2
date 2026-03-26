import 'package:flutter/material.dart';
import '../../../../../core/constants/constants_exports.dart';
import '../../../../../imports.dart';

class PublicProfileInfoRow extends StatelessWidget {
  final String icon;
  final String text;
  final TextStyle? textStyle;

  const PublicProfileInfoRow({
    required this.icon,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingXS),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 14.5, height: 14.5),
          const SizedBox(width: AppSizes.paddingXS),
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
