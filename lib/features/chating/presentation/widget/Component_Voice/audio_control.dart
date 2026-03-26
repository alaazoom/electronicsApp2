import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';

class VerticalAudioControl extends StatefulWidget {
  final VoidCallback? onTap; 

  const VerticalAudioControl({super.key, this.onTap});

  @override
  State<VerticalAudioControl> createState() => _VerticalAudioControlState();
}

class _VerticalAudioControlState extends State<VerticalAudioControl> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggle() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _animationController.forward() : _animationController.reverse();
    });
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPlaying ? AppColors.mainColor : AppColors.white,
            border: Border.all(
              color: isPlaying ? AppColors.mainColor : AppColors.border.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isPlaying 
                    ? AppColors.mainColor.withOpacity(0.3) 
                    : Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
              size: 28,
              color: isPlaying ? Colors.white : AppColors.titles,
            ),
          ),
        ),
      ),
    );
  }
}