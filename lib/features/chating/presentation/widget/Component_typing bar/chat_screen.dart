import 'package:flutter/material.dart';
import 'chat_input_bar_final.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ReplyMessage? replyingTo;
  final List<Map<String, dynamic>> messages = [
    {
      'type': 'text',
      'isSender': false,
      'message': "Hi, how are you? Is the device still available?",
      'time': "9:24 AM",
      'isRead': true,
    },
    {
      'type': 'image',
      'isSender': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
      'time': '9:24 AM',
    },
    {
      'type': 'voice',
      'isSender': true,
      'audioUrl': 'https://www.soundjay.com/buttons/beep-01a.mp3',
      'duration': '0:10',
      'time': '09:20',
      'isRead': true,
    },
  ];

  void _onReply(ReplyMessage message) {
    setState(() {
      replyingTo = message;
    });
  }

  void _cancelReply() {
    setState(() {
      replyingTo = null;
    });
  }

  void _handleSend(String text) {
    setState(() {
      messages.add({
        'type': 'text',
        'isSender': true,
        'message': text,
        'time': "Now",
        'isRead': false,
        'replyTo': replyingTo != null ? replyingTo!.content : null,
      });
      replyingTo = null; // إغلاق الرد بعد الإرسال
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: const ChatHeader(
            name: 'Ahmad Sami',
            imageUrl:
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150",
            isOnline: true,
            deviceName: "Redmi Note 12",
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildDateDivider("Today"),
                  const TextMessageBubble(
                    isSender: false,
                    message: "Hi, how are you? Is the device still available?",
                    time: "9:24 AM",
                    isRead: true,
                  ),
                  const ImageMessageBubble(
                    isSender: false,
                    imageUrl:
                        'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
                    time: '9:24 AM',
                  ),
                  const VoiceMessageBubble1(
                    isSender: true,
                    audioUrl: 'https://www.soundjay.com/buttons/beep-01a.mp3',
                    duration: '0:10',
                    time: '09:20',
                    isRead: true,
                  ),
                  // مثال على رسالة مرسلة من المستخدم مع إمكانية السحب للرد
                  GestureDetector(
                    onHorizontalDragEnd: (_) {
                      _onReply(
                        ReplyMessage(
                          id: '1',
                          senderName: 'Ahmad Sami',
                          content:
                              "Hi, how are you? Is the device still available?",
                        ),
                      );
                    },
                    child: const TextMessageBubble(
                      isSender: true,
                      message: "I'm good, thanks! Yes it is.",
                      time: "9:25 AM",
                      isRead: true,
                    ),
                  ),
                  const TypingIndicatorBubble(isSender: false),
                ],
              ),
            ),

            ChatInputBarFinal(
              onSend: _handleSend,
              replyingTo: replyingTo,
              onCancelReply: _cancelReply,
              hintText: "Type a message...",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

// --- الودجت التي زودتني بها (مع بعض التعديلات البسيطة لتعمل) ---

class ChatHeader extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isOnline;
  final String deviceName;

  const ChatHeader({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            onBackgroundImageError: (exception, stackTrace) {
              // This is a simple fix for the redefined class in the test file
            },
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isOnline ? "Online • $deviceName" : "Offline",
                style: TextStyle(
                  color: isOnline ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextMessageBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final String time;
  final bool isRead;

  const TextMessageBubble({
    super.key,
    required this.isSender,
    required this.message,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight:
                isSender ? const Radius.circular(0) : const Radius.circular(20),
            bottomLeft:
                isSender ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(color: isSender ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isSender ? Colors.white70 : Colors.grey,
                    fontSize: 10,
                  ),
                ),
                if (isSender) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: isRead ? Colors.white : Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isSender;
  final String imageUrl;
  final String time;

  const ImageMessageBubble({
    super.key,
    required this.isSender,
    required this.imageUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              Positioned(
                bottom: 8,
                right: 8,
                child: Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    backgroundColor: Colors.black26,
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

class VoiceMessageBubble1 extends StatelessWidget {
  final bool isSender;
  final String audioUrl;
  final String duration;
  final String time;
  final bool isRead;

  const VoiceMessageBubble1({
    super.key,
    required this.isSender,
    required this.audioUrl,
    required this.duration,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow,
              color: isSender ? Colors.blue : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 2, color: Colors.grey[400]),
                const SizedBox(height: 4),
                Text("$duration • $time", style: const TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicatorBubble extends StatelessWidget {
  final bool isSender;
  const TypingIndicatorBubble({super.key, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          "Typing...",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        ),
      ),
    );
  }
}
