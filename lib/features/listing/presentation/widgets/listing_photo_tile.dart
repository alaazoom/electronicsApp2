import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';

class ListingPhotoTile extends StatelessWidget {
  const ListingPhotoTile({
    super.key,
    required this.photo,
    required this.onRemove,
    required this.onTap,
  });

  final ListingPhotoItem photo;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool isError = photo.status == ListingPhotoStatus.tooLarge;
    final bool isUploading = photo.status == ListingPhotoStatus.uploading;
    final double progressValue = photo.progress.clamp(0.0, 1.0);
    final int progressPercent = (progressValue * 100).round();
    // this GestureDetector allows taps on the entire tile except the top-left corner (where the remove button is)
    return GestureDetector(
      onTapUp: (details) {
        if (details.localPosition.dx < 34 && details.localPosition.dy < 34) {
          return;
        }
        onTap();
      },
      child: Container(
        width: 88,
        height: 88,
        margin: const EdgeInsets.only(right: AppSizes.paddingS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(
            color: isError ? colors.error : colors.border,
            width: 1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  photo.path.isEmpty
                      ? Container(color: colors.greyFillButton)
                      : Image.file(
                        File(photo.path),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(color: colors.greyFillButton);
                        },
                      ),
            ),

            Positioned(
              top: 6,
              right: 6,
              child: SvgPicture.asset(
                photo.isMain
                    ? AppAssets.photoMainIcon
                    : AppAssets.photoPinOutlineIcon,
                width: 18,
                height: 18,
              ),
            ),

            Positioned(
              top: 6,
              left: 6,

              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.closeSquareIcon,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            if (isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: CircularProgressIndicator(
                              value: progressValue,
                              strokeWidth: 5,
                              backgroundColor: colors.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.mainColor,
                              ),
                            ),
                          ),
                          Text(
                            '$progressPercent%',
                            style: AppTypography.h2_20SemiBold.copyWith(
                              color: colors.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (isError)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.photoErrorIcon,
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddPhotoTile extends StatelessWidget {
  const AddPhotoTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 88,
        margin: const EdgeInsets.only(right: AppSizes.paddingS),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.plusIcon, width: 28, height: 28),
            const SizedBox(height: 6),
            Text(
              'Add photos',
              style: AppTypography.label10Regular.copyWith(color: colors.hint),
            ),
          ],
        ),
      ),
    );
  }
}

// Tile displayed when there are no photos added yet ( full width )
class AddPhotoEmptyTile extends StatelessWidget {
  const AddPhotoEmptyTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 88,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.plusIcon, width: 28, height: 28),
            const SizedBox(height: 6),
            Text(
              'Add photos',
              style: AppTypography.body14Regular.copyWith(color: colors.hint),
            ),
          ],
        ),
      ),
    );
  }
}
