
enum ReplyMessageType {
  text,
  image,
  audio,
  video,
  file,
  location,
  contact,
}

class ReplyMessageModel {
  final String id;
  final String senderName;
  final ReplyMessageType type;

  // للنص
  final String? text;

  // للصورة
  final String? imageUrl;
  final String? imageLocalPath;
  final String? imageCaption;

  // للصوت
  final String? audioUrl;
  final String? audioLocalPath;
  final Duration? audioDuration;

  // للفيديو
  final String? videoUrl;
  final String? videoThumbnailUrl;
  final Duration? videoDuration;

  // للملف
  final String? fileUrl;
  final String? fileName;
  final int? fileSizeInBytes;
  final String? fileExtension;

  const ReplyMessageModel({
    required this.id,
    required this.senderName,
    required this.type,
    this.text,
    this.imageUrl,
    this.imageLocalPath,
    this.imageCaption,
    this.audioUrl,
    this.audioLocalPath,
    this.audioDuration,
    this.videoUrl,
    this.videoThumbnailUrl,
    this.videoDuration,
    this.fileUrl,
    this.fileName,
    this.fileSizeInBytes,
    this.fileExtension,
  });

  String get previewText {
    switch (type) {
      case ReplyMessageType.text:
        return text ?? '';
      case ReplyMessageType.image:
        return imageCaption?.isNotEmpty == true ? imageCaption! : '📷 image';
      case ReplyMessageType.audio:
        return '🎵 voice';
      case ReplyMessageType.video:
        return '🎬 video ';
      case ReplyMessageType.file:
        return '📎 ${fileName ?? "file"}';
      case ReplyMessageType.location:
        return '📍 location ';
      case ReplyMessageType.contact:
        return '👤 contact';
    }
  }

  String get fileSizeFormatted {
    if (fileSizeInBytes == null) return '';
    final kb = fileSizeInBytes! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}
