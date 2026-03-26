import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/features/profile/presentation/widgets/profile_widgets/public_profile_info_row.dart';

import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../data/models/profile_view_data.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileViewData profile;
  final ProfileType type;

  const ProfileHeader({super.key, required this.profile, required this.type});

  static const double _avatarSizePublic = 90;
  static const double _avatarSizePrivate = 150;
  static const double _onlineIndicatorSize = 15;

  static const double _borderRadius = 10;
  static const double _topBorderWidth = 5;
  static const double _sideBorderWidth = 1;

  Border _buildBorder(Color color) {
    return Border(
      top: BorderSide(color: color, width: _topBorderWidth),
      left: BorderSide(color: color, width: _sideBorderWidth),
      right: BorderSide(color: color, width: _sideBorderWidth),
      bottom: BorderSide(color: color, width: _sideBorderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.label12Regular.copyWith(
      color: context.colors.titles,
    );
    final privateTextStyle = AppTypography.body14Regular.copyWith(
      color: context.colors.titles,
    );
    final avatarSize =
        type == ProfileType.public ? _avatarSizePublic : _avatarSizePrivate;

    Widget avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundImage:
              profile.avatar.isNotEmpty ? NetworkImage(profile.avatar) : null,
          child:
              profile.avatar.isEmpty
                  ? SvgPicture.asset(
                    AppAssets.profileOutlineIcon,
                    fit: BoxFit.contain,
                  )
                  : null,
        ),

        if (profile.isOnline && type == ProfileType.public)
          Positioned(
            bottom: avatarSize * 0.15,
            right: avatarSize * 0.15,
            child: Container(
              width: _onlineIndicatorSize,
              height: _onlineIndicatorSize,
              decoration: BoxDecoration(
                color: context.colors.success,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );

    if (type == ProfileType.public) {
      // public layout: avatar + info side by side
      return Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          border: _buildBorder(context.colors.secondaryColor),
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: avatar,
            ),
            const SizedBox(width: AppSizes.paddingXS),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: AppTypography.h3_18Regular.copyWith(
                    color: context.colors.titles,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                PublicProfileInfoRow(
                  icon: AppAssets.locationOutlinedIcon,
                  text: profile.location ?? 'Gaza',
                  textStyle: textStyle,
                ),
                PublicProfileInfoRow(
                  icon: AppAssets.profileOutlineIcon,
                  text: profile.bio ?? 'I love Electronics',
                  textStyle: textStyle,
                ),
                PublicProfileInfoRow(
                  icon: AppAssets.calendarIcon,
                  text: 'Member Since ${profile.memberSince}',
                  textStyle: textStyle,
                ),
                if (profile.lastSeen != null)
                  PublicProfileInfoRow(
                    icon: AppAssets.timeCircleIcon,
                    text: 'Last Seen ${profile.lastSeen}',
                    textStyle: textStyle,
                  ),
                if (profile.responseTime != null)
                  PublicProfileInfoRow(
                    icon: AppAssets.chatOutlineIcon,
                    text: profile.responseTime!,
                    textStyle: textStyle,
                  ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          avatar,
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            profile.name,
            style: AppTypography.h3_18Medium.copyWith(
              color: context.colors.titles,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          _centeredRow(
            PublicProfileInfoRow(
              icon: AppAssets.locationOutlinedIcon,
              text: profile.location ?? 'Gaza',
              textStyle: privateTextStyle,
            ),
          ),
          _centeredRow(
            PublicProfileInfoRow(
              icon: AppAssets.profileOutlineIcon,
              text: profile.bio ?? 'I love Electronics',
              textStyle: privateTextStyle,
            ),
          ),
          _centeredRow(
            PublicProfileInfoRow(
              icon: AppAssets.calendarIcon,
              text: 'Member Since ${profile.memberSince}',
              textStyle: privateTextStyle,
            ),
          ),
          if (profile.responseTime != null)
            _centeredRow(
              PublicProfileInfoRow(
                icon: AppAssets.chatOutlineIcon,
                text: profile.responseTime!,
                textStyle: privateTextStyle,
              ),
            ),
        ],
      );
    }
  }

  Widget _centeredRow(Widget child) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [child]);
}
