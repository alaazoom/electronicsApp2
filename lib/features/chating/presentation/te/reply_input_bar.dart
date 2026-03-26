
import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'reply_message_model.dart';

class ReplyInputBar extends StatelessWidget {
  final ReplyMessageModel replyTo;
  final VoidCallback onCancel;

  const ReplyInputBar({
    super.key,
    required this.replyTo,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.mainColor20, width: 1),
        ),
      ),
      child: Row(
        children: [
          // أيقونة الرد
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.reply, size: 18, color: AppColors.mainColor),
          ),

          const SizedBox(width: 10),

          // معاينة الرسالة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  replyTo.senderName,
                  style: AppTypography.label12Medium.copyWith(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                _buildPreviewContent(),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // زر الإلغاء
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.hint.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: AppColors.hint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    switch (replyTo.type) {
      case ReplyMessageType.image:
        return _mediaRow(Icons.image_outlined, replyTo.previewText);
      case ReplyMessageType.audio:
        return _mediaRow(Icons.mic_outlined, replyTo.previewText);
      case ReplyMessageType.video:
        return _mediaRow(Icons.videocam_outlined, replyTo.previewText);
      case ReplyMessageType.file:
        return _mediaRow(Icons.attach_file, replyTo.previewText);
      default:
        return Text(
          replyTo.previewText,
          style: AppTypography.body14Regular.copyWith(color: AppColors.hint),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  Widget _mediaRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.hint),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: AppTypography.label12Regular.copyWith(color: AppColors.hint),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
