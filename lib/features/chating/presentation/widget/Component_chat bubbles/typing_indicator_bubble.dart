import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/chat_bubble.dart';

class TypingIndicatorBubble extends ChatBubbleBase {
  TypingIndicatorBubble({
    super.key,
    required super.isSender,
  }) : super(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(
                //   'Typing   ', 
                //   style: AppTypography.body14Regular.copyWith(
                //     color: isSender ? AppColors.white : AppColors.text,
                //   ),
                // ),
                _AnimatedTypingDots(
                  dotColor: isSender ? AppColors.white : AppColors.mainColor,
                ),
              ],
            ),
          ),
        );
}

// النقاط المتحركة مع تأثير بسيط
class _AnimatedTypingDots extends StatefulWidget {
  final Color dotColor;

  const _AnimatedTypingDots({required this.dotColor});

  @override
  _AnimatedTypingDotsState createState() => _AnimatedTypingDotsState();
}

class _AnimatedTypingDotsState extends State<_AnimatedTypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_controller.value - delay).clamp(0.0, 1.0);
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Transform.translate(
                offset: Offset(0, -animationValue * 2.0), // حركة صعود ونزول
                child: Opacity(
                  opacity: 0.5 + (animationValue * 0.5), // تغيير في الشفافية
                  child: Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: widget.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}