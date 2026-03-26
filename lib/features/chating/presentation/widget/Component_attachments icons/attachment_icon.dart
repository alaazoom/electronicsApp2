import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';

class AttachmentButtons extends StatelessWidget {
  final VoidCallback onAttach;
  final VoidCallback onCamera;

  const AttachmentButtons({
    super.key,
    required this.onAttach,
    required this.onCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: -0.8,
          child: IconButton(
            onPressed: onAttach,
            icon: Icon(
              Icons.attach_file,
              size: 20,
              color: AppColors.icons, 
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 12),

        IconButton(
          onPressed: onCamera,
          icon: Icon(
            Icons.camera_alt_outlined,
            size: 20,
            color: AppColors.icons, 
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
