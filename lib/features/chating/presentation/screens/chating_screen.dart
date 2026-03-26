import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Chat header/chat_header.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Voice/voice_message_bubble_fixed.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/image_message_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/text_message_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/typing_indicator_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_typing%20bar/chat_input_bar_final.dart';

class ChatingScreen extends StatefulWidget {
  const ChatingScreen({super.key});

  @override
  State<ChatingScreen> createState() => _ChatingScreenState();
}

class _ChatingScreenState extends State<ChatingScreen> {
  final List<Widget> _messages = [];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      _buildDateDivider("Today"),
      const SizedBox(height: 20),
      VoiceMessageBubble1(
        isSender: true,
        audioUrl:
            'https://github.com/rafaelreis-hotmart/Audio-Sample/raw/master/sample.mp3',
        duration: '0:10',
        time: '09:20',
        isRead: true,
      ),
      const SizedBox(height: 12),
      TextMessageBubble(
        isSender: true,
        message: "Hi, how are you? Is the device still available?",
        time: "9:24 AM",
        isRead: true,
        id: 1,
      ),
      const SizedBox(height: 12),
      ImageMessageBubble(
        isSender: false,
        imageUrl:
            'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
        time: '9:24 AM',
      ),
      const SizedBox(height: 12),
    ]);
  }

  void _addMessage(Widget message) {
    setState(() {
      _messages.add(message);
      _messages.add(const SizedBox(height: 12));
    });
    _scrollToBottom();
  }

  void _onSend(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = TextMessageBubble(
      isSender: true,
      message: text,
      time: _getCurrentTime(),
      isRead: false,
      id: DateTime.now().millisecondsSinceEpoch,
    );

    _addMessage(userMessage);

    // Simulate auto-reply
    _simulateReply();
  }

  void _simulateReply() async {
    setState(() => _isTyping = true);
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isTyping = false);

    final replyMessage = TextMessageBubble(
      isSender: false,
      message: "أهلاً بك! نعم الجهاز لا يزال متوفراً. هل تود معاينته؟",
      time: _getCurrentTime(),
      isRead: true,
      id: DateTime.now().millisecondsSinceEpoch,
    );

    _addMessage(replyMessage);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.greyFillButton,
      body: SafeArea(
        child: Column(
          children: [
            const ChatHeader(
              name: 'Ahmad Sami',
              imageUrl:
                  "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150",
              isOnline: true,
              deviceName: "Redmi Note 12",
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: AppColors.white),
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  children: [
                    ..._messages,
                    if (_isTyping) ...[
                      TypingIndicatorBubble(isSender: false),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            ChatInputBarFinal(onSend: _onSend, onCancelReply: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: AppTypography.caption12Regular.copyWith(
            color: AppColors.neutral,
          ),
        ),
      ),
    );
  }
}
