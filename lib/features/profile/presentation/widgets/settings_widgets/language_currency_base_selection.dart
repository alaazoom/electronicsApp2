import 'package:flutter/material.dart';
import '../../../../../../configs/theme/theme_exports.dart';
import '../../../../../../core/constants/constants_exports.dart';

class LanguageCurrencyBaseSelectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const LanguageCurrencyBaseSelectionWidget({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: AppTypography.h3_18Medium.copyWith(
                color: context.colors.titles,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            ...children,
          ],
        ),
      ),
    );
  }
}
