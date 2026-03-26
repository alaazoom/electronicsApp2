import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_textfield.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/labeled_checkbox.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_field_config.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_state.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_select_field.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_selection_sheet.dart';

class MoreDetailsStep extends StatelessWidget {
  const MoreDetailsStep({
    super.key,
    required this.descriptionController,
    required this.attributeControllers,
    required this.onOpenLocation,
  });

  final TextEditingController descriptionController;
  final Map<String, TextEditingController> attributeControllers;
  final VoidCallback onOpenLocation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<AddListingDraftCubit, AddListingDraftState>(
      builder: (context, state) {
        final draftCubit = context.read<AddListingDraftCubit>();
        final fields =
            state.selectedCategoryConfig?.fields ?? <ListingFieldConfig>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'More Details',
              style: AppTypography.h3_18Medium.copyWith(color: colors.titles),
            ),
            const SizedBox(height: AppSizes.paddingM),
            ...fields.map((field) {
              if (field.type == ListingFieldType.selection) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
                  child: ListingSelectField(
                    label: field.label,
                    value: state.draft.attributes[field.key] ?? '',
                    isRequired: field.required,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder:
                            (_) => FractionallySizedBox(
                              heightFactor: 0.9,
                              child: ListingSelectionSheet(
                                title: field.label,
                                options: field.options,
                                selectedValue:
                                    state.draft.attributes[field.key] ?? '',
                                onSelected:
                                    (value) => draftCubit.updateAttribute(
                                      field.key,
                                      value,
                                    ),
                              ),
                            ),
                      );
                    },
                  ),
                );
              }

              final controller =
                  attributeControllers[field.key] ??
                  (attributeControllers[field.key] = TextEditingController(
                    text: state.draft.attributes[field.key] ?? '',
                  ));

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
                child: CustomTextField(
                  label: field.label,
                  isRequired: field.required,
                  hintText:
                      field.hint.isEmpty
                          ? 'Enter ${field.label.toLowerCase()}'
                          : field.hint,
                  controller: controller,
                  keyboardType:
                      field.type == ListingFieldType.number
                          ? TextInputType.number
                          : TextInputType.text,
                  onChanged:
                      (value) => draftCubit.updateAttribute(field.key, value),
                ),
              );
            }),
            CustomTextField(
              label: 'Description',
              hintText:
                  'Mention usage time, defects, accessories included, and reason for selling',
              controller: descriptionController,
              maxLines: 4,
              maxLength: 500,
              onChanged: draftCubit.updateDescription,
            ),
            const SizedBox(height: AppSizes.paddingM),
            ListingSelectField(
              label: 'Location',
              value: state.draft.location?.address ?? '',
              isRequired: true,
              placeholder: 'Where the listing is available',
              onTap: onOpenLocation,
            ),
            const SizedBox(height: AppSizes.paddingM),
            LabeledCheckbox(
              value: state.draft.confirmNotStolen,
              onChanged: (v) => draftCubit.toggleConfirmNotStolen(v ?? false),
              label: 'I confirm this item is not stolen or prohibited',
              showRequiredStar: true,
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
