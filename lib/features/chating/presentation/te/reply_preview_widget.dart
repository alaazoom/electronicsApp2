
import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'reply_message_model.dart';

class ReplyPreviewWidget extends StatelessWidget {
  final ReplyMessageModel reply;
  final bool isSender;

  const ReplyPreviewWidget({
    super.key,
    required this.reply,
    required this.isSender,
  });

  Color get _accentColor =>
      isSender ? AppColors.mainColor : AppColors.secondaryColor;

  Color get _bgColor =>
      isSender ? AppColors.mainColor5 : AppColors.secondaryColor5;

  Color get _borderColor =>
      isSender ? AppColors.mainColor20 : AppColors.secondaryColor20;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              color: _accentColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (reply.type) {
      case ReplyMessageType.text:
        return _buildTextPreview();
      case ReplyMessageType.image:
        return _buildImagePreview();
      case ReplyMessageType.audio:
        return _buildAudioPreview();
      case ReplyMessageType.video:
        return _buildVideoPreview();
      case ReplyMessageType.file:
        return _buildFilePreview();
      default:
        return _buildDefaultPreview();
    }
  }

  Widget _buildSenderName() {
    return Text(
      reply.senderName,
      style: AppTypography.label10Medium.copyWith(
        color: _accentColor,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTextPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSenderName(),
        const SizedBox(height: 2),
        Text(
          reply.text ?? '',
          style: AppTypography.body14Regular.copyWith(
            color: AppColors.text,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSenderName(),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.image_outlined,
                      size: 14, color: AppColors.hint),
                  const SizedBox(width: 4),
                  Text(
                    reply.imageCaption?.isNotEmpty == true
                        ? reply.imageCaption!
                        : 'image',
                    style: AppTypography.label12Regular.copyWith(
                      color: AppColors.hint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _buildImageThumbnail(),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail() {
    final url = reply.imageUrl ?? reply.imageLocalPath;
    if (url == null) {
      return Container(
        width: 48,
        height: 48,
        color: AppColors.hint.withOpacity(0.2),
        child: Icon(Icons.image_outlined, color: AppColors.hint, size: 20),
      );
    }
    return Image.network(
      url,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 48,
        height: 48,
        color: AppColors.hint.withOpacity(0.2),
        child: Icon(Icons.broken_image_outlined, color: AppColors.hint, size: 20),
      ),
    );
  }

  Widget _buildAudioPreview() {
    final duration = reply.audioDuration;
    final durationText = duration != null
        ? '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
        : '';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mic, size: 30, color: _accentColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSenderName(),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'voice message',
                    style: AppTypography.label12Regular.copyWith(
                      color: AppColors.hint,
                    ),
                  ),
                  if (durationText.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      '• $durationText',
                      style: AppTypography.label10Regular.copyWith(
                        color: AppColors.hint,
                      ),
                    ),
                  ],
               ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSenderName(),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.videocam_outlined, size: 14, color: AppColors.hint),
                  const SizedBox(width: 4),
                  Text(
                    'video',
                    style: AppTypography.label12Regular.copyWith(
                      color: AppColors.hint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: reply.videoThumbnailUrl != null
                  ? Image.network(
                      reply.videoThumbnailUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _videoPlaceholder(),
                    )
                  : _videoPlaceholder(),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _videoPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.black12,
      child: Icon(Icons.videocam_outlined, color: AppColors.hint, size: 20),
    );
  }

  Widget _buildFilePreview() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(_fileIcon(reply.fileExtension), size: 18, color: _accentColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSenderName(),
              const SizedBox(height: 2),
              Text(
                reply.fileName ?? 'file',
                style: AppTypography.label12Regular.copyWith(
                  color: AppColors.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (reply.fileSizeFormatted.isNotEmpty)
                Text(
                  reply.fileSizeFormatted,
                  style: AppTypography.label10Regular.copyWith(
                    color: AppColors.hint,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _fileIcon(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Widget _buildDefaultPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSenderName(),
        const SizedBox(height: 2),
        Text(
          reply.previewText,
          style: AppTypography.label12Regular.copyWith(color: AppColors.hint),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
