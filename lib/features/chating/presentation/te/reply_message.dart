enum MessageType { text, image, audio, file }

class ReplyMessage {
  final String id;
  final String senderName;
  final String content; 
  final String? mediaUrl; 
  final MessageType type;

  ReplyMessage({
    required this.id,
    required this.senderName,
    required this.content,
    this.mediaUrl,
    this.type = MessageType.text,
  });

  static String getMessageDescription(MessageType type, String content) {
    switch (type) {
      case MessageType.image:
        return "📷 Photo";
      case MessageType.audio:
        return "🎤 Voice Message";
      case MessageType.file:
        return "📁 File";
      default:
        return content;
    }
  }
}
