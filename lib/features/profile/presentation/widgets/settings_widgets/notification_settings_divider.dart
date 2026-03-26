import 'package:flutter/material.dart';
import '../../../../../../configs/theme/theme_exports.dart';

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(width: 326, height: 1, color: context.colors.border),
    );
  }
}
