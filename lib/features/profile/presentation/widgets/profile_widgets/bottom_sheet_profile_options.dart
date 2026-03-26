import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import '../../../../../configs/theme/app_colors.dart';
import '../../../../../configs/theme/app_typography.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/app_sizes.dart';
enum ProfileOptionType { report, photo }

void showProfileOptionsSheet(
  BuildContext context, {
  required ProfileOptionType type,
  VoidCallback? onTakePhoto,
  VoidCallback? onPickGallery,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.bottomSheetRadiusTop),
      ),
    ),
    builder:
        (_) => _ProfileOptionsSheet(
          type: type,
          onTakePhoto: onTakePhoto,
          onPickGallery: onPickGallery,
        ),
  );
}

class _ProfileOptionsSheet extends StatelessWidget {
  final ProfileOptionType type;
  final VoidCallback? onTakePhoto;
  final VoidCallback? onPickGallery;

  const _ProfileOptionsSheet({
    required this.type,
    this.onTakePhoto,
    this.onPickGallery,
  });
  @override
  Widget build(BuildContext context) {
    final options = _getOptions(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingM,
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(
            context,
            type == ProfileOptionType.report ? 'Options' : 'Photo Options',
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children:
                  options
                      .map(
                        (o) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSizes.paddingM,
                          ),
                          child: o,
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getOptions(BuildContext context) {
    if (type == ProfileOptionType.report) {
      // ثلاث نقاط → Report
      return [
        InkWell(
          onTap: () {
            context.pop();
            context.goNamed(AppRoutes.reportUser);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Report',
              style: AppTypography.body14Regular.copyWith(
                color: context.colors.titles,
              ),
            ),
          ),
        ),
      ];
    } else {
      return [
        _buildOption(
          context,
          label: 'Take Photo',
          iconPath: AppAssets.cameraIcon,
          onTap: () {
            context.pop();
            onTakePhoto?.call();
          },
        ),
        _buildOption(
          context,
          label: 'Choose from Gallery',
          iconPath: AppAssets.galleryIcon,
          onTap: () {
            context.pop();
            onPickGallery?.call();
          },
        ),
      ];
    }
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius10),
          border: Border.all(color: context.colors.border, width: 0.3),
        ),
        child: Center(
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: AppSizes.paddingS),
            leading: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: context.colors.mainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXS),
                child: SvgPicture.asset(iconPath, width: 16, height: 16),
              ),
            ),
            title: Text(
              label,
              style: AppTypography.body16Regular.copyWith(
                color: context.colors.titles,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Row(
      children: [
        const Spacer(),
        Text(
          title,
          style: AppTypography.body16Medium.copyWith(
            color: context.colors.titles,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.icons, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.close, size: 11),
          ),
        ),
      ],
    );
  }
}
