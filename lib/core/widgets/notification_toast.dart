import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_shadows.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';

enum ToastType { error, warning, success }

class NotificationToast extends StatelessWidget {
  final String title;
  final String msg;
  final ToastType type;

  const NotificationToast({
    super.key,
    required this.title,
    required this.msg,
    required this.type,
  });

  static void show(
    BuildContext context,
    String title,
    String msg,
    ToastType type,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (context) => _ToastAnimationWrapper(
            onDismiss: () => entry.remove(),
            child: NotificationToast(title: title, msg: msg, type: type),
          ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Color statusColor =
        type == ToastType.error
            ? colors.error
            : (type == ToastType.warning ? colors.warning : colors.success);

    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: context.shadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 8, color: statusColor),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 12,
                    bottom: 12,
                    left: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTypography.body14Medium.copyWith(
                          color: colors.titles,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        msg,
                        style: AppTypography.label12Regular.copyWith(
                          color: colors.hint,
                        ),
                      ),
                    ],
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

class _ToastAnimationWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const _ToastAnimationWrapper({required this.child, required this.onDismiss});

  @override
  State<_ToastAnimationWrapper> createState() => _State();
}

class _State extends State<_ToastAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _offset,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onDismiss(),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
