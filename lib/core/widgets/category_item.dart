import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.iconPath,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام اللون الأزرق للهوية البصرية كما في التصميم
    final backgroundColor =
        isSelected ? context.colors.mainColor : context.colors.neutral5;
    final iconColor =
        isSelected ? context.colors.surface : context.colors.icons;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: _buildIcon(context, iconColor),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  isSelected
                      ? AppTypography.body14Medium.copyWith(
                        color: context.colors.text,
                      )
                      : AppTypography.label12Regular.copyWith(
                        color: context.colors.text,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    if (iconPath.isEmpty) {
      return Icon(Icons.category_outlined, color: iconColor, size: 24);
    }

    if (iconPath.startsWith('http')) {
      final bool isSvg = iconPath.toLowerCase().contains('.svg');
      if (isSvg) {
        return SvgPicture.network(
          iconPath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          placeholderBuilder: (context) => const _LoadingWidget(),
          errorBuilder:
              (context, error, stackTrace) => Image.network(
                iconPath,
                width: 24,
                height: 24,
                color: iconColor,
                errorBuilder:
                    (_, __, ___) => Icon(
                      Icons.category_outlined,
                      color: iconColor,
                      size: 24,
                    ),
              ),
        );
      } else {
        return Image.network(
          iconPath,
          width: 24,
          height: 24,
          color: iconColor,
          errorBuilder:
              (_, __, ___) =>
                  Icon(Icons.category_outlined, color: iconColor, size: 24),
          loadingBuilder:
              (context, child, loadingProgress) =>
                  loadingProgress == null ? child : const _LoadingWidget(),
        );
      }
    }

    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        errorBuilder:
            (_, __, ___) =>
                Icon(Icons.category_outlined, color: iconColor, size: 24),
      );
    } else {
      return Image.asset(
        iconPath,
        width: 24,
        height: 24,
        color: iconColor,
        errorBuilder:
            (_, __, ___) =>
                Icon(Icons.category_outlined, color: iconColor, size: 24),
      );
    }
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
