import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';

 class ChatBubbleBase extends StatelessWidget {
  final bool isSender;
  final Widget child;
  final String? timestamp;

  const ChatBubbleBase({
    super.key,
    required this.isSender,
    required this.child,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isSender
        ? AppColors.mainColor10  
        : AppColors.secondaryColor10; 

    final textColor = isSender ? AppColors.text : AppColors.text;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: AppTypography.body14Regular.copyWith(color: textColor),
                child: child,
              ),
              
              if (timestamp != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    timestamp!,
                    style: AppTypography.label10Regular.copyWith(
                      color: AppColors.hint,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}