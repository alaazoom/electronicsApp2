import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/chat_bubble.dart';

class ImageMessageBubble extends ChatBubbleBase {
  ImageMessageBubble({
    super.key,
    required super.isSender,
    required String imageUrl,
    required String time,
  }) : super(
         child: Column(
           crossAxisAlignment:
               isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
           children: [
             Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(8),
                 boxShadow: [
                   BoxShadow(
                     color: AppColors.black.withOpacity(0.1),
                     blurRadius: 4,
                     offset: const Offset(0, 2),
                   ),
                 ],
               ),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(8),
                 child: Image.network(
                   imageUrl,
                   width: 200,
                   height: 150,
                   fit: BoxFit.cover,
                   loadingBuilder: (context, child, loadingProgress) {
                     if (loadingProgress == null) return child;
                     return SizedBox(
                       width: 200,
                       height: 150,
                       child: Center(
                         child: CircularProgressIndicator(
                           strokeWidth: 2,
                           value:
                               loadingProgress.expectedTotalBytes != null
                                   ? loadingProgress.cumulativeBytesLoaded /
                                       loadingProgress.expectedTotalBytes!
                                   : null,
                           color: AppColors.mainColor,
                           backgroundColor: AppColors.mainColor10,
                         ),
                       ),
                     );
                   },
                   errorBuilder: (context, error, stackTrace) {
                     return Container(
                       width: 200,
                       height: 150,
                       color: AppColors.placeholders,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.broken_image,
                             color: AppColors.icons,
                             size: 40,
                           ),
                           const SizedBox(height: 8),
                           Text(
                             'فشل تحميل الصورة',
                             style: AppTypography.body16Regular.copyWith(
                               color: AppColors.hint,
                             ),
                           ),
                         ],
                       ),
                     );
                   },
                 ),
               ),
             ),
             const SizedBox(height: 6),
             Text(
               time,
               style: AppTypography.label10Regular.copyWith(
                 color: AppColors.hint,
               ),
             ),
           ],
         ),
       );
}
