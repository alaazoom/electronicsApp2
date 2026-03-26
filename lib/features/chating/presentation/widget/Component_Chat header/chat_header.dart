import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_shadows.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Chat list item/device_info_row.dart';
import 'chat_subtitle_row.dart';

class ChatHeader extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isOnline;
  final String deviceName;

  const ChatHeader({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ⬅️ Back
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: AppColors.icons,
                onPressed: () => context.pop(),
              ),

              // 👤 Avatar
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    imageBuilder:
                        (context, imageProvider) => CircleAvatar(
                          radius: 20,
                          backgroundImage: imageProvider,
                        ),
                    placeholder:
                        (context, url) => const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.neutral10,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    errorWidget:
                        (context, url, error) => const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            'assets/images/profile pic.png',
                          ),
                        ),
                  ),
                  // if (isOnline)
                  //   Positioned(
                  //     right: 0,
                  //     bottom: 0,
                  //     child: Container(
                  //       width: 10,
                  //       height: 10,
                  //       decoration: BoxDecoration(
                  //         color: AppColors.success,
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //           color: AppColors.white,
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),

              const SizedBox(width: 10),

              // 📄 Name + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.h3_18Medium.copyWith(
                        color: AppColors.titles,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ChatSubtitleRow(isOnline: isOnline),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: const Icon(Icons.call, size: 20),
                color: AppColors.icons,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, size: 20),
                color: AppColors.icons,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                color: AppColors.icons,
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(
                child: ProductInfoRow(
                  productName: deviceName,
                  imageUrl: imageUrl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
