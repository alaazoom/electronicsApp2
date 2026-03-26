import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_textfield.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/labeled_checkbox.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_state.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_media_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_condition_chips.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_photo_grid.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_price_field.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_select_field.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/photo_tips_list.dart';

class BasicDetailsStep extends StatelessWidget {
  const BasicDetailsStep({
    super.key,
    required this.titleController,
    required this.priceController,
    required this.onOpenCategory,
    required this.onOpenPhotoOptions,
    required this.onOpenTips,
  });

  final TextEditingController titleController;
  final TextEditingController priceController;
  final VoidCallback onOpenCategory;
  final VoidCallback onOpenPhotoOptions;
  final VoidCallback onOpenTips;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AddListingDraftCubit, AddListingDraftState>(
      builder: (context, state) {
        final draftCubit = context.read<AddListingDraftCubit>();
        final mediaCubit = context.read<AddListingMediaCubit>();
        final hasPhotoError = state.draft.photos.any(
          (p) => p.status == ListingPhotoStatus.tooLarge,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Details',
              style: AppTypography.h3_18Medium.copyWith(color: colors.titles),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Row(
              children: [
                Text(
                  'Photos',
                  style: AppTypography.body14Regular.copyWith(
                    color: colors.titles,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: AppTypography.body14Regular.copyWith(
                    color: colors.error,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onOpenTips,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.infoCircleIcon,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tips',
                        style: AppTypography.body14Regular.copyWith(
                          color: colors.hint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingS),
            ListingPhotoGrid(
              photos: state.draft.photos,
              onAddPhoto: onOpenPhotoOptions,
              onRemovePhoto: mediaCubit.removePhoto,
              onSetMain: mediaCubit.setMainPhoto,
            ),
            if (hasPhotoError) ...[
              const SizedBox(height: AppSizes.paddingXS),
              Text(
                'Please upload an image smaller than 5 MB.',
                style: AppTypography.label12Regular.copyWith(
                  color: colors.error,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.paddingM),
            CustomTextField(
              label: 'Title',
              isRequired: true,
              hintText: 'iPhone 11 Pro 256GB',
              controller: titleController,
              onChanged: draftCubit.updateTitle,
            ),
            const SizedBox(height: AppSizes.paddingM),
            ListingSelectField(
              label: 'Category',
              value: state.draft.category,
              isRequired: true,
              helperText:
                  state.draft.category.isNotEmpty
                      ? 'Fields will be customized based on category'
                      : null,
              onTap: onOpenCategory,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Condition',
              style: AppTypography.body14Regular.copyWith(color: colors.titles),
            ),
            const SizedBox(height: AppSizes.paddingS),
            ListingConditionChips(
              conditions: const ['New', 'Like New', 'Good', 'Fair', 'Poor'],
              selected: state.draft.condition,
              onSelected: draftCubit.updateCondition,
            ),
            const SizedBox(height: AppSizes.paddingM),
            ListingPriceField(
              controller: priceController,
              onChanged: draftCubit.updatePrice,
            ),
            const SizedBox(height: AppSizes.paddingM),
            LabeledCheckbox(
              value: state.draft.negotiable,
              onChanged: (v) => draftCubit.toggleNegotiable(v ?? false),
              label: 'Price is negotiable',
              labelStyle: AppTypography.body14Regular.copyWith(
                color: colors.text,
              ),
            ),
          ],
        );
      },
    );
  }
}

void showPhotoTipsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSizes.bottomSheetRadiusTop),
      ),
    ),
    builder:
        (_) => SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingM,
              AppSizes.paddingM,
              AppSizes.paddingM,
              0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 24, height: 24),
                      Expanded(
                        child: Text(
                          'Photo tips',
                          textAlign: TextAlign.center,
                          style: AppTypography.body16Medium.copyWith(
                            color: context.colors.titles,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          AppAssets.closeSquareIcon,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  PhotoTipsList(
                    tips: const [
                      'Take photos of the device while it’s turned on',
                      'Show ports, screen, and any defects clearly',
                      'Avoid using images from the internet',
                      'Good photos help your item sell faster',
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
