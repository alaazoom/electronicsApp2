import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../auth/data/models/auth_models.dart';
import '../../../../auth/presentation/cubits/auth_cubit.dart';
import 'trust_indicator_card.dart';

class TrustIndicatorsSection extends StatelessWidget {
  const TrustIndicatorsSection({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 113,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TrustIndicatorCard(
              label: "Verified Phone",
              iconSvgPath: AppAssets.verifiedPhoneSvg,
              verified: user.isPhoneVerified,
              onTap:
                  user.isPhoneVerified
                      ? null
                      : () {
                        context.read<AuthCubit>().resendCode(isEmail: false);
                        context.pushNamed(
                          AppRoutes.otp,
                          extra: {'email': '', 'phoneNumber': user.phoneNumber},
                        );
                      },
            ),
            SizedBox(width: AppSizes.paddingXS),
            TrustIndicatorCard(
              label: "Verified Identity",
              iconSvgPath: AppAssets.verifiedIdentityCardSvg,
              verified: user.isIdentityVerified,
              onTap:
                  user.isIdentityVerified
                      ? null
                      : () => context.pushNamed(AppRoutes.verification),
            ),
            SizedBox(width: AppSizes.paddingXS),
            TrustIndicatorCard(
              label: "Verified Email",
              iconSvgPath: AppAssets.verifiedMessageSvg,
              verified: user.isEmailVerified,
              onTap:
                  user.isEmailVerified
                      ? null
                      : () {
                        context.read<AuthCubit>().resendCode(isEmail: true);
                        context.pushNamed(
                          AppRoutes.otp,
                          extra: {'email': user.email, 'phoneNumber': ''},
                        );
                      },
            ),
          ],
        ),
      ),
    );
  }
}
