import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';

class ProductInfoRow extends StatelessWidget {
  final String productName;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ProductInfoRow({
    super.key,
    required this.productName,
    this.imageUrl,
    this.onTap,
  });

  static const String defaultImage =
      'https://images.unsplash.com/photo-1546868831-d1be1c46ad0a?q=80&w=150';

  String get _validImage {
    if (imageUrl == null ||
        imageUrl!.trim().isEmpty ||
        imageUrl == 'null' ||
        !imageUrl!.startsWith('http')) {
      return defaultImage;
    }
    return imageUrl!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 20, color: AppColors.border.withOpacity(0.5)),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neutralWithoutTransparent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8),
                //   child: Image.network(
                //     _validImage,
                //     width: 40,
                //     height: 40,
                //     fit: BoxFit.cover,
                //     errorBuilder: (_, __, ___) => Container(
                //       width: 40,
                //       height: 40,
                //       color: AppColors.neutralWithoutTransparent,
                //       child: Icon(Icons.image_not_supported,
                //           size: 20, color: AppColors.icons),
                //     ),
                //   ),
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _validImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: AppColors.neutralWithoutTransparent.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 20,
                          color: AppColors.icons,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 40,
                        height: 40,
                        color: AppColors.neutralWithoutTransparent.withOpacity(
                          0.1,
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    productName,
                    style: AppTypography.body14Regular.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.titles,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.icons.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
