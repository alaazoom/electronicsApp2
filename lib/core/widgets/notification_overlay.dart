import 'package:flutter/material.dart';

import 'app_notification.dart';
import 'notification_card.dart';

class NotificationOverlay {
  static void show(BuildContext context, AppNotification notification) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (_) => _NotificationPreview(
            notification: notification,
            onClose: () => entry.remove(),
          ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }
}

class _NotificationPreview extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onClose;

  const _NotificationPreview({
    required this.notification,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: NotificationCard(
          notification: notification,
          onTap: onClose, // preview فقط
        ),
      ),
    );
  }
}
