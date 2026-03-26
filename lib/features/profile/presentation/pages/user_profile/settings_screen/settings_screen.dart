import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../configs/theme/app_colors.dart';
import '../../../../../../core/constants/constants_exports.dart';
import '../../../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../widgets/settings_widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingM,
          AppSizes.paddingM,
          AppSizes.paddingM,
          AppSizes.paddingL,
        ),
        child: Column(
          children: [
            SettingsTile(
              title: 'Notifications',
              icon: AppAssets.notificationIcon,
              iconColor: context.colors.mainColor,
              onTap: () {
                context.goNamed(AppRoutes.notificationSettings);
              },
            ),
            const SizedBox(height: AppSizes.paddingS),

            SettingsTile(
              title: 'Change Password',
              icon: AppAssets.shieldDoneIcon,
              iconColor: context.colors.mainColor,
              onTap: () {
               // context.goNamed(AppRoutes.changePassword);
              },
            ),
            const SizedBox(height: AppSizes.paddingS),

            SettingsTile(
              title: 'Language & Currency',
              icon: AppAssets.languageCircleIcon,
              iconColor: context.colors.mainColor,
              onTap: () {
                context.goNamed(AppRoutes.languageCurrency);
              },
            ),
            const SizedBox(height: AppSizes.paddingS),

            SettingsTile(
              title: 'Help Center',
              icon: AppAssets.customerSupportIcon,
              iconColor: context.colors.mainColor,
              onTap: () {
                context.goNamed(AppRoutes.helpCenter);
              },
            ),
            const SizedBox(height: AppSizes.paddingS),

            SettingsTile(
              title: 'Log out',
              icon: AppAssets.logoutIcon,
              iconColor: context.colors.error,
              textColor: context.colors.error,
              showArrow: false,
              onTap: () async {
                await context.read<AuthCubit>().logout();
                context.goNamed(AppRoutes.login);              },
            ),
          ],
        ),
      ),
    );
  }
}
