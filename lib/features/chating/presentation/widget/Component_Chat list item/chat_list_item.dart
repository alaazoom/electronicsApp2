import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_shadows.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Chat list item/device_info_row.dart';

class ChatListItem extends StatelessWidget {
  final String name;
  final String lastMsg;
  final String time;
  final int unread;
  final String productName;
  final String imageUrl;
  final bool isSelected;
  final bool isPinned;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatListItem({
    super.key,
    required this.name,
    required this.lastMsg,
    required this.time,
    this.unread = 0,
    this.productName = '',
    this.imageUrl = '',
    this.isSelected = false,
    required this.isPinned,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadows.card,
          border: Border.all(
            color: isSelected ? AppColors.mainColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            // محتوى العنصر
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            imageBuilder:
                                (context, imageProvider) => CircleAvatar(
                                  radius: 24,
                                  backgroundImage: imageProvider,
                                ),
                            placeholder:
                                (context, url) => const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.placeholders,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => const CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                    'assets/images/profile pic.png',
                                  ),
                                  backgroundColor: AppColors.placeholders,
                                ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: AppTypography.body16Medium.copyWith(
                                      color: AppColors.titles,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),

                                if (unread > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      unread.toString(),
                                      style: AppTypography.label10Regular
                                          .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Text(
                              lastMsg,
                              style: AppTypography.body14Regular.copyWith(
                                color: AppColors.text,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              time,
                              style: AppTypography.label12Regular.copyWith(
                                color: AppColors.hint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (productName.isNotEmpty)
                    ProductInfoRow(
                      productName: productName,
                      imageUrl: imageUrl,
                    ),
                ],
              ),
            ),

            if (isPinned)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.warning20,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.push_pin,
                    size: 14,
                    color: AppColors.warning,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
