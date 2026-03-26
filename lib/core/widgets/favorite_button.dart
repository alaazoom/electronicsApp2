import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/circle_button.dart';

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback? onTap;
  final double size;
  final bool
  isActive; //if you dont need to change the button state, this set to false

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    this.onTap,
    required this.size,
    this.isActive = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  void _toggleFavorite() {
    if (widget.isActive) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      onTap: _toggleFavorite,
      size: widget.size,
      iconPath: _isFavorite ? AppAssets.favIcon : AppAssets.unfavIcon,
      iconColor: _isFavorite ? context.colors.error : context.colors.icons,
    );
  }
}
