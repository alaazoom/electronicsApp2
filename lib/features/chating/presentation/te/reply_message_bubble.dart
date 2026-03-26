import 'dart:io';
import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/chat_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Voice/voice_message_bubble_fixed.dart';
import 'reply_message_model.dart';
import 'reply_preview_widget.dart';

enum ReplyBubbleContentType4 { text, image, audio }

class ReplyMessageBubble4 extends StatelessWidget {
  // ── الرسالة المردود عليها ─────────────────────────────────
  final ReplyMessageModel replyTo;
  final VoidCallback? onReplyTap;

  // ── نوع محتوى الرد ────────────────────────────────────────
  final ReplyBubbleContentType4 contentType;

  // نص
  final String? message;

  // صورة
  final String? imageUrl;
  final String? imageLocalPath;
  final String? imageCaption;

  // صوت — فقط audioUrl و duration (يُعرض بـ VoiceMessageBubble1)
  final String? audioUrl;
  final String? audioDurationLabel; // مثال: '0:10'

  final bool isSender;
  final String time;
  final bool isRead;
  final bool isDelivered;

  const ReplyMessageBubble4({
    super.key,
    required this.isSender,
    required this.replyTo,
    required this.contentType,
    required this.time,
    required this.isRead,
    this.isDelivered = false,
    this.onReplyTap,
    // نص
    this.message,
    // صورة
    this.imageUrl,
    this.imageLocalPath,
    this.imageCaption,
    // صوت
    this.audioUrl,
    this.audioDurationLabel,
  }) : assert(
          contentType != ReplyBubbleContentType4.audio ||
              audioUrl != null,
          'audioUrl مطلوب عند contentType == audio',
        );

  @override
  Widget build(BuildContext context) {
    // لما النوع صوت، نعرضها بشكل مختلف —
    // VoiceMessageBubble1 عندها Align داخلي، فنحتاج نتعامل معها كـ block مستقل
    if (contentType == ReplyBubbleContentType4.audio) {
      return _buildAudioReplyBubble();
    }

    return ChatBubbleBase(
      isSender: isSender,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildReplyPreview(),
          const SizedBox(height: 8),
          _buildContent(context),
          const SizedBox(height: 6),
          _buildFooter(),
        ],
      ),
    );
  }

  // حالة الصوت — wrapper خاص يجمع:
  // [معاينة الرسالة المردود عليها] فوق [VoiceMessageBubble1]
  Widget _buildAudioReplyBubble() {
  return Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Container(
        decoration: BoxDecoration(
          color: isSender ? AppColors.mainColor.withOpacity(0.08) : AppColors.secondaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── معاينة الرسالة المردود عليها ──────────────
            GestureDetector(
              onTap: onReplyTap,
              child: ReplyPreviewWidget(
                reply: replyTo,
                isSender: isSender,
              ),
            ),
            const SizedBox(height: 6),

            // ── VoiceMessageBubble1 داخل نفس الكونتينر ─────
            VoiceMessageBubble1(
              isSender: isSender,
              audioUrl: audioUrl!,
              duration: audioDurationLabel ?? '0:00',
              time: time,
              isRead: isRead,
            ),
          ],
        ),
      ),
    ),
  );
}

  // Widget _buildAudioReplyBubble() {
  //   return Align(
  //     alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
  //     child: ConstrainedBox(
  //       constraints: const BoxConstraints(maxWidth: 280),
  //       child: Column(
  //         crossAxisAlignment:
  //             isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // ── معاينة الرسالة المردود عليها ──────────────
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 10),
  //             child: GestureDetector(
  //               onTap: onReplyTap,
  //               child: ReplyPreviewWidget(
  //                 reply: replyTo,
  //                 isSender: isSender,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 4),

  //           // ── VoiceMessageBubble1 كما هي ─────────────────
  //           // تحتوي على الـ Align + Container + الـ content كاملة
  //           VoiceMessageBubble1(
  //             isSender: isSender,
  //             audioUrl: audioUrl!,
  //             duration: audioDurationLabel ?? '0:00',
  //             time: time,
  //             isRead: isRead,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // معاينة الرسالة المردود عليها (للنص والصورة)
  Widget _buildReplyPreview() {
    return GestureDetector(
      onTap: onReplyTap,
      child: ReplyPreviewWidget(
        reply: replyTo,
        isSender: isSender,
      ),
    );
  }

  // محتوى الرد (نص / صورة)
  Widget _buildContent(BuildContext context) {
    switch (contentType) {
      case ReplyBubbleContentType4.text:
        return Text(
          message ?? '',
          style: AppTypography.body14Regular.copyWith(color: AppColors.text),
        );
      case ReplyBubbleContentType4.image:
        return _buildImageContent(context);
      case ReplyBubbleContentType4.audio:
        return const SizedBox.shrink(); 
    }
  }

  Widget _buildImageContent(BuildContext context) {
    final isLocal = imageLocalPath != null && imageLocalPath!.isNotEmpty;
    final path = isLocal ? imageLocalPath : imageUrl;

    if (path == null) return _imagePlaceholder();

    final ImageProvider imageProvider =
        isLocal ? FileImage(File(path)) : NetworkImage(path);

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _showFullScreenImage(context, imageProvider),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: imageProvider,
              width: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder(),
            ),
          ),
        ),
        if (imageCaption?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            imageCaption!,
            style: AppTypography.body14Regular.copyWith(color: AppColors.text),
          ),
        ],
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, ImageProvider imageProvider) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __) => Scaffold(
        backgroundColor: Colors.black.withOpacity(0.85),
        body: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: InteractiveViewer(
              child: Image(image: imageProvider),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 220,
      height: 140,
      color: AppColors.hint.withOpacity(0.15),
      child: Icon(Icons.image_outlined, color: AppColors.hint, size: 36),
    );
  }

  // فوتر (وقت + حالة) — للنص والصورة فقط
  // الصوت عنده footer داخلي في VoiceMessageBubble1
  Widget _buildFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          time,
          style: AppTypography.label10Regular.copyWith(
            color: AppColors.hint,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isSender) ...[
          const SizedBox(width: 4),
          _StatusIcon(isRead: isRead, isDelivered: isDelivered),
        ],
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final bool isRead;
  final bool isDelivered;

  const _StatusIcon({required this.isRead, required this.isDelivered});

  @override
  Widget build(BuildContext context) {
    if (isRead) return Icon(Icons.done_all, size: 14, color: AppColors.success);
    if (isDelivered) return Icon(Icons.done_all, size: 14, color: AppColors.hint);
    return Icon(Icons.done, size: 14, color: AppColors.hint);
  }
}
