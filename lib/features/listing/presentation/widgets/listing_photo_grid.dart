import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_photo_tile.dart';

class ListingPhotoGrid extends StatelessWidget {
  const ListingPhotoGrid({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    required this.onSetMain,
  });

  final List<ListingPhotoItem> photos;
  final VoidCallback onAddPhoto;
  final ValueChanged<String> onRemovePhoto;
  final ValueChanged<String> onSetMain;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photos.isEmpty)
          AddPhotoEmptyTile(onTap: onAddPhoto)
        else
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (photos.length < 6) AddPhotoTile(onTap: onAddPhoto),
                ...photos.map(
                  (photo) => ListingPhotoTile(
                    photo: photo,
                    onRemove: () => onRemovePhoto(photo.id),
                    onTap: () => onSetMain(photo.id),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSizes.paddingXS),
        if (photos.isEmpty)
          Text(
            'Add up to 6 photos. Max size 5 MB per image.',
            style: AppTypography.label12Regular.copyWith(color: colors.hint),
          )
        else
          Text(
            'Tap a photo to set it as main.',
            style: AppTypography.label12Regular.copyWith(color: colors.hint),
          ),
      ],
    );
  }
}
