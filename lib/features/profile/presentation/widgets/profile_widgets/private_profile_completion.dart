import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../configs/theme/app_colors.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/progress_indicator.dart';
import '../../bloc/profile_screen_bloc/profile_bloc.dart';

class PrivateProfileCompletion extends StatelessWidget {
  const PrivateProfileCompletion({
    super.key,
    required this.verificationProgress,
  });

  final double verificationProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
        border: Border.all(color: context.colors.border, width: 0.3),
        boxShadow: [
          BoxShadow(
            color: context.colors.border,
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXS),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Completion',
                  style: AppTypography.body16Regular.copyWith(
                    color: context.colors.titles,
                  ),
                ),
                Text(
                  '${(verificationProgress * 100).toStringAsFixed(1)}%',
                  style: AppTypography.body14Regular.copyWith(
                    color: context.colors.titles,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingS),
            ProgressIndicatorWidget(progressValue: verificationProgress),
            const SizedBox(height: AppSizes.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Profile',
                  style: AppTypography.body14Regular.copyWith(
                    color: context.colors.titles,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await context.pushNamed(AppRoutes.editUserProfile);
                    context.read<ProfileBloc>().add(
                      FetchProfileEvent(isMe: true),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: AppSizes.paddingM,
                    color: context.colors.icons,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
