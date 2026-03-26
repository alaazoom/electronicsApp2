enum MessageType { text, image, audio, file }

class ReplyMessage {
  final String id;
  final String senderName;
  final String content;
  final String? imageUrl;
  final MessageType type;

  ReplyMessage({
    required this.id,
    required this.senderName,
    required this.content,
    this.imageUrl,
    this.type = MessageType.text,
  });
}
