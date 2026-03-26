import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/add_photo_widget.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/bottom_sheet_header.dart';

class AddPhotoOptionsSheet extends StatelessWidget {
  const AddPhotoOptionsSheet({
    super.key,
    required this.onTakePhoto,
    required this.onPickGallery,
  });

  final VoidCallback onTakePhoto;
  final VoidCallback onPickGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingM,
        AppSizes.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(
            title: 'Add photo',
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: AppSizes.paddingM),
          AddPhotoWidget(
            iconPath: AppAssets.cameraIcon,
            title: 'Take photo',
            onTap: onTakePhoto,
          ),
          const SizedBox(height: AppSizes.paddingM),
          AddPhotoWidget(
            iconPath: AppAssets.galleryIcon,
            title: 'Choose from Gallery',
            onTap: onPickGallery,
          ),
        ],
      ),
    );
  }
}
