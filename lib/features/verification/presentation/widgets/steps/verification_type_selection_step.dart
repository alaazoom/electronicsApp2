import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_radio_button_item.dart';
import 'package:second_hand_electronics_marketplace/features/verification/data/enums/id_type.dart';

class VerificationTypeSelectionStep extends StatelessWidget {
  final IdType? selectedIdType;
  final ValueChanged<IdType> onTypeSelected;
  final VoidCallback onContinue;

  const VerificationTypeSelectionStep({
    super.key,
    required this.selectedIdType,
    required this.onTypeSelected,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.selectYourIdType,
            style: AppTypography.h3_18Regular.copyWith(
              color: context.colors.text,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),

          _buildRadioOption(IdType.idCard),
          const SizedBox(height: AppSizes.paddingM),
          _buildRadioOption(IdType.passport),
          const SizedBox(height: AppSizes.paddingM),
          _buildRadioOption(IdType.driverLicense),

          SizedBox(height: AppSizes.paddingL),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedIdType != null ? onContinue : null,
              child: Text(AppStrings.continueText),
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
        ],
      ),
    );
  }

  Widget _buildRadioOption(IdType type) {
    return CustomRadioButtonItem(
      label: type.label,
      isSelected: selectedIdType == type,
      onTap: () => onTypeSelected(type),
    );
  }
}
