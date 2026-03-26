import '../constants/constants_exports.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  welcome,
  underReview,
  success,
  rejected,
  newMessage,
  listing,
  phoneVerified,
  identityVerified,
  emailVerified,
  deleted,
}

extension NotificationTypeX on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.welcome:
        return AppAssets.welcomeSvg;
      case NotificationType.underReview:
        return AppAssets.underReviewAndResubmittedSvg;
      case NotificationType.success:
        return AppAssets.successAndApprovedSvg;
      case NotificationType.rejected:
        return AppAssets.rejectedSvg;
      case NotificationType.newMessage:
        return AppAssets.newMsgAndReplySvg;
      case NotificationType.listing:
        return AppAssets.listingAndNewItemSvg;
      case NotificationType.phoneVerified:
        return AppAssets.phoneVerifiedSvg;
      case NotificationType.identityVerified:
        return AppAssets.identityVerifiedSvg;
      case NotificationType.emailVerified:
        return AppAssets.emailVerifiedSvg;
      case NotificationType.deleted:
        return AppAssets.deletedSvg;
    }
  }
}
