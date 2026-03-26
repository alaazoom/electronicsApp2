import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Voice/voice_message_bubble_fixed.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/text_message_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_typing%20bar/chat_input_bar_final.dart';

class CustomerServiceChatScreen extends StatelessWidget {
  const CustomerServiceChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(      backgroundColor: AppColors.greyFillButton,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.black),
        centerTitle: true,
        title: Text(
          'Customer Service',
          style: AppTypography.h5_20Medium.copyWith(
            color: AppColors.black,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.neutral10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Today',
                            style: AppTypography.caption12Regular.copyWith(
                              color: AppColors.neutral,
                            ),
                          ),
                        ),
                      ),
                    ),

                    TextMessageBubble(
                      isSender: false,
                      message: "Hi How are you?",
                      time: "9:24",
                      isRead: false, id: 1,
                    ),
                    const SizedBox(height: 12),

                    TextMessageBubble(id: 1,
                      isSender: true,
                      message: "Hi, Can you help me?",
                      time: "9:24",
                      isRead: true,
                    ),
                    const SizedBox(height: 12),

                    TextMessageBubble(id: 1,
                      isSender: false,
                      message: "Hi How are you?",
                      time: "9:24",
                      isRead: false,
                    ),
                    const SizedBox(height: 12),
                                       VoiceMessageBubble1(
  isSender: true,
  audioUrl: 'https://cdn.pixabay.com/download/audio/2022/03/10/audio_1c5f401d51.mp3',
  duration: '0:10',
  time: '09:20',
  isRead: true,
 ),
                    const SizedBox(height: 12),
                                      VoiceMessageBubble1(
  isSender: true,
  audioUrl: 'https://www.soundjay.com/buttons/beep-01a.mp3',
  duration: '0:10',
  time: '09:20',
  isRead: true,
 )
// VoiceMessageBuble1(
//                       isSender: true,
//                       audioUrl: 'https://www.soundjay.com/buttons/beep-01a.mp3',
//                       duration: '0:10',
//                       time: '09:20',
//                       isRead: true,
// )
                    // VoiceMessageBuble1(
                    //   isSender: true,
                    //   audioUrl:
                    //       'https://www.soundjay.com/buttons/beep-01a.mp3',
                    //   duration: '0:30',
                    //   time: '9:24',
                    //   isRead: true,
                    // ),
                  ],
                ),
              ),
            ),
            ChatInputBarFinal(onCancelReply: () {  },),

            // ChatInputBar(
            //   showSuggestions: false,
            //   onSend: (text) => debugPrint('Send: $text'),
            //   onAttach: () => debugPrint('Attach file'),
            //   onCamera: () => debugPrint('Open camera'),
            //   onEmoji: () => debugPrint('Open emoji'),
            // ),
          ],
        ),
      ),
    ) );
  }
}
