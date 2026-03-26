import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/circle_button.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/favorite_button.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/widgets/search_with_filter.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/cubits/location_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/cubits/location_states.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM).copyWith(top: 60),
      decoration: BoxDecoration(
        color: context.colors.mainColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.borderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.location,
                    style: AppTypography.label12Regular.copyWith(
                      color: context.colors.surface,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXXS),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.locationOutlinedIcon,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          context.colors.surface,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: AppSizes.paddingXXS),
                      BlocBuilder<LocationCubit, LocationStates>(
                        builder: (context, state) {
                          if (state is LocationLoaded) {
                            return Text(
                              // بنعرض المدينة والدولة من المودل
                              '${state.location.city}, ${state.location.country}',
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis, // عشان لو النص طويل ما يضرب الديزاين
                              style: AppTypography.body14Regular.copyWith(
                                color: context.colors.surface,
                              ),
                            );
                          }
                          // 2. حالة لسه بيحمل
                          if (state is LocationLoading) {
                            return Text(
                              'جاري التحديد...',
                              style: AppTypography.body14Regular.copyWith(
                                color: context.colors.surface,
                              ),
                            );
                          }
                          // 3. حالة ابتدائية أو إيرور
                          return Text(
                            'الموقع غير محدد', // أو أي نص افتراضي بتفضليه
                            style: AppTypography.body14Regular.copyWith(
                              color: context.colors.surface,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  FavoriteButton(
                    isFavorite: false,
                    size: 40,
                    onTap: () {
                      context.pushNamed(AppRoutes.favorite);
                    },
                    isActive: false,
                  ),
                  const SizedBox(width: AppSizes.paddingXS),
                  Stack(
                    children: [
                      CircleButton(
                        onTap: () {
                          context.pushNamed(AppRoutes.notification);
                        },
                        size: 40,
                        iconPath: AppAssets.notificationIcon,
                      ),
                      //for notification add the red circle to indicated that there is a notification
                      // Positioned(
                      //   right: 10,
                      //   top: 7,
                      //   child: Container(
                      //     width: 8,
                      //     height: 8,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: context.colors.error,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingM),
          SearchWithFilterWidget(),
        ],
      ),
    );
  }
}
