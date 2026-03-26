import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
class ChatSubtitleRow extends StatelessWidget {
  final bool isOnline;

  const ChatSubtitleRow({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        isOnline ? AppColors.success : AppColors.neutral;

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isOnline ? 'Online' : 'Offline',
          style: AppTypography.label12Regular.copyWith(
            color: statusColor,
          ),
        ),
      ],
    );
  }
}
