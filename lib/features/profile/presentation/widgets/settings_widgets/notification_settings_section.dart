import 'package:flutter/material.dart';
import '../../../../../../configs/theme/theme_exports.dart';
import '../../../../../../core/constants/constants_exports.dart';
import 'notification_settings_divider.dart';

class SettingsSection extends StatelessWidget {
  final List<Widget> children;

  const SettingsSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingS),
      decoration: BoxDecoration(
        color: context.colors.greyFillButton,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
      ),
      child: Column(
        children:
            children
                .expand(
                  (e) => [
                    e,
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingXXS),
                      child: const SettingsDivider(),
                    ),
                  ],
                )
                .toList()
              ..removeLast(),
      ),
    );
  }
}
