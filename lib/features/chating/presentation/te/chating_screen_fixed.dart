import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/chat_input_bar_final5.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/reply_message_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/reply_message_bubble0.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/reply_message_model.dart';

import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Chat header/chat_header.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Voice/voice_message_bubble_fixed.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/text_message_bubble.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_chat bubbles/typing_indicator_bubble.dart';
import 'package:second_hand_electronics_marketplace/imports.dart';

// نموذج بيانات لإدارة حالة كل رسالة على حدة
class _MessageData {
  final ReplyMessageModel model;
  double? uploadProgress; // للصور والملفات

  _MessageData({required this.model, this.uploadProgress});
}

class ChatingScreen1 extends StatefulWidget {
  const ChatingScreen1({super.key});

  @override
  State<ChatingScreen1> createState() => _ChatingScreen1State();
}

class _ChatingScreen1State extends State<ChatingScreen1> {
  // الرسالة المحددة للرد عليها حالياً (null = لا يوجد رد نشط)
  ReplyMessageModel? _activeReply;

  // حالة "جاري الكتابة" للطرف الآخر (للمحاكاة)
  bool _isOtherUserTyping = false;

  // ── حالة مشغل الصوت ──────────────────────────────────────
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingAudioId;
  bool _isPlayerPlaying = false;
  double _currentAudioProgress = 0.0;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _listenToPlayer();
  }

  @override
  void dispose() {
    _cleanupAudioPlayer();
    super.dispose();
  }

  final List<_MessageData> _messages = [];

  String _formatDuration(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _listenToPlayer() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlayerPlaying = state.playing;
        if (state.processingState == ProcessingState.completed) {
          _audioPlayer.stop();
          _playingAudioId = null;
          _currentAudioProgress = 0.0;
        }
      });
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      final duration = _audioPlayer.duration ?? Duration.zero;
      if (duration > Duration.zero && mounted) {
        setState(() {
          _currentAudioProgress =
              position.inMilliseconds / duration.inMilliseconds;
        });
      }
    });
  }

  void _cleanupAudioPlayer() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
  }

  // ── تشغيل الرد ────────────────────────────────────────────
  void _startReply(ReplyMessageModel message) {
    setState(() => _activeReply = message);
  }

  // ── إلغاء الرد ────────────────────────────────────────────
  void _cancelReply() {
    setState(() => _activeReply = null);
  }

  // ── إظهار خيارات الرسالة (رد / حذف) ──────────────────────
  void _showMessageOptions(_MessageData messageData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              // أظهر خيار النسخ فقط للرسائل النصية
              if (messageData.model.type == ReplyMessageType.text &&
                  messageData.model.text != null)
                ListTile(
                  leading: const Icon(Icons.copy_all_outlined),
                  title: const Text('Copy'),
                  onTap: () {
                    Navigator.pop(context);
                    Clipboard.setData(
                      ClipboardData(text: messageData.model.text!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  _startReply(messageData.model);
                },
              ),
              // أظهر خيار الحذف فقط لرسائل المرسل
              if (messageData.model.senderName == 'you')
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete for me',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteMessage(messageData);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // ── حذف رسالة ─────────────────────────────────────────────
  void _deleteMessage(_MessageData messageData) {
    setState(() {
      _messages.remove(messageData);
    });
  }

  // ── إرسال الرسالة ─────────────────────────────────────────
  void _onSend(String text) {
    if (text.trim().isEmpty) return;

    final messageData = _MessageData(
      model: ReplyMessageModel(
        id: 'local_txt_${DateTime.now().millisecondsSinceEpoch}',
        senderName: 'you',
        type: ReplyMessageType.text,
        text: text,
      ),
    );

    setState(() => _messages.add(messageData));
    _cancelReply(); // امسح الرد بعد الإرسال
    _simulateReceivingMessage();
  }

  // ── إرسال صورة ───────────────────────────────────────────
  void _onImageSelected(XFile imageFile) {
    final messageData = _MessageData(
      model: ReplyMessageModel(
        id: 'local_img_${DateTime.now().millisecondsSinceEpoch}',
        senderName: 'you',
        type: ReplyMessageType.image,
        imageLocalPath: imageFile.path,
      ),
      uploadProgress: 0.0,
    );

    setState(() => _messages.add(messageData));
    _cancelReply();
    _simulateUpload(messageData.model.id);
  }

  // ── محاكاة رفع الصورة ─────────────────────────────────────
  void _simulateUpload(String messageId) async {
    // Find the message in the list
    final index = _messages.indexWhere((m) => m.model.id == messageId);
    if (index == -1) return;

    // Simulate progress
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() {
        _messages[index].uploadProgress = i / 10.0;
      });
    }

    // Simulate receiving a response after upload
    _simulateReceivingMessage();
  }

  // ── إرسال صورة من الكاميرا ────────────────────────────────
  void _onCameraCapture(XFile imageFile) {
    // This is identical to _onImageSelected
    _onImageSelected(imageFile);
  }

  // ── إرسال ملف ───────────────────────────────────────────
  void _onFileSelected(PlatformFile file) {
    final fileSizeInBytes = file.size;
    String fileSizeFormatted;
    if (fileSizeInBytes < 1024) {
      fileSizeFormatted = '$fileSizeInBytes B';
    } else if (fileSizeInBytes < 1024 * 1024) {
      fileSizeFormatted = '${(fileSizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      fileSizeFormatted =
          '${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    final messageData = _MessageData(
      model: ReplyMessageModel(
        id: 'local_file_${DateTime.now().millisecondsSinceEpoch}',
        senderName: 'you',
        type: ReplyMessageType.file,
        fileName: file.name,
        fileSizeInBytes: file.size,
        fileExtension: file.extension,
      ),
    );

    setState(() => _messages.add(messageData));
    _cancelReply();
    _simulateReceivingMessage();
  }

  // ── محاكاة استلام رسالة ───────────────────────────────────
  void _simulateReceivingMessage() {
    // 1. إظهار مؤشر الكتابة
    setState(() => _isOtherUserTyping = true);

    // 2. الانتظار لبضع ثوان
    Future.delayed(const Duration(seconds: 2), () {
      // 3. إخفاء المؤشر وإضافة رسالة مستلمة
      if (!mounted) return;
      setState(() {
        _isOtherUserTyping = false;
        _messages.add(
          _MessageData(
            model: ReplyMessageModel(
              id: 'remote_${DateTime.now().millisecondsSinceEpoch}',
              senderName: 'Ahmad',
              type: ReplyMessageType.text,
              text: 'Okay, I will check it.',
            ),
          ),
        );
      });
    });
  }

  // ── تشغيل/إيقاف الصوت ───────────────────────────────────
  void _onPlayPauseAudio(_MessageData messageData) async {
    final isCurrentlyPlaying = _playingAudioId == messageData.model.id;

    if (isCurrentlyPlaying && _isPlayerPlaying) {
      await _audioPlayer.pause();
    } else {
      // إذا كانت هناك أغنية أخرى تعمل، أوقفها
      if (_playingAudioId != null && !isCurrentlyPlaying) {
        await _audioPlayer.stop();
      }

      // حدد الرسالة الصوتية الجديدة
      setState(() {
        _playingAudioId = messageData.model.id;
        _currentAudioProgress = 0.0;
      });

      try {
        // قم بتحميل وتشغيل الصوت من المسار المحلي أو الرابط
        final source =
            messageData.model.audioLocalPath != null
                ? AudioSource.file(messageData.model.audioLocalPath!)
                : AudioSource.uri(Uri.parse(messageData.model.audioUrl!));
        await _audioPlayer.setAudioSource(source);
        _audioPlayer.play();
      } catch (e) {
        debugPrint("Error playing audio: $e");
        // إعادة تعيين الحالة عند حدوث خطأ
        setState(() {
          _playingAudioId = null;
        });
      }
    }
  }

  // ── خلفية السحب للرد ─────────────────────────────────────
  Widget _buildSwipeActionBackground(bool isSender) {
    return Container(
      // لون خلفية خفيف للإشارة إلى وجود إجراء
      color: AppColors.mainColor.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Icon(Icons.reply, color: AppColors.mainColor),
    );
  }

  // ── بناء ويدجت الرسالة من البيانات ────────────────────────
  Widget _buildMessageWidget(_MessageData messageData) {
    final model = messageData.model;
    final isSender = model.senderName == 'you';

    final bubble = ReplyMessageBubble3(
      isSender: isSender,
      time: _getCurrentTime(), // Ideally, time should be in the model
      isRead: false, // Same for isRead status
      isDelivered: messageData.uploadProgress == 1.0,
      contentType: model.type.toBubbleContentType(),
      replyTo: isSender ? _activeReply : null, // Simplified logic
      // Pass data from model
      message: model.text,
      imageUrl: model.imageUrl,
      imageLocalPath: model.imageLocalPath,
      imageCaption: model.imageCaption,
      audioDuration: model.audioDuration,
      fileName: model.fileName,
      fileSize: model.fileSizeFormatted,

      // Audio specific props
      isAudioPlaying: _playingAudioId == model.id && _isPlayerPlaying,
      audioProgress: _playingAudioId == model.id ? _currentAudioProgress : 0.0,
      onAudioPlayPause:
          model.type == ReplyMessageType.audio
              ? () => _onPlayPauseAudio(messageData)
              : null,
      // Pass state from MessageData
      uploadProgress: messageData.uploadProgress,
    );

    return Dismissible(
      key: ValueKey(model.id),
      direction:
          isSender ? DismissDirection.endToStart : DismissDirection.startToEnd,
      background: _buildSwipeActionBackground(isSender),
      confirmDismiss: (direction) async {
        _startReply(model);
        HapticFeedback.lightImpact();
        return false; // منع الحذف والعودة للمكان الأصلي
      },
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(messageData),
        child: bubble,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.greyFillButton,
        body: SafeArea(
          child: Column(
            children: [
              // ── هيدر المحادثة ──────────────────────────────
              const ChatHeader(
                name: 'Ahmad Sami',
                imageUrl:
                    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150",
                isOnline: true,
                deviceName: "Redmi Note 12",
              ),

              // ── قائمة الرسائل ──────────────────────────────
              Expanded(
                child: Container(
                  color: AppColors.white,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    children: [
                      _buildDateDivider("Today"),
                      const SizedBox(height: 20),

                      // ── رسالة صوتية ──────────────────────
                      Dismissible(
                        key: const ValueKey('msg_voice_001'),
                        direction: DismissDirection.endToStart,
                        background: _buildSwipeActionBackground(true),
                        confirmDismiss: (direction) async {
                          _startReply(
                            const ReplyMessageModel(
                              id: 'msg_voice_001',
                              senderName: 'you',
                              type: ReplyMessageType.audio,
                              audioDuration: Duration(seconds: 10),
                            ),
                          );
                          HapticFeedback.lightImpact();
                          return false;
                        },
                        child: GestureDetector(
                          onLongPress:
                              () => _startReply(
                                const ReplyMessageModel(
                                  id: 'msg_voice_001',
                                  senderName: 'you',
                                  type: ReplyMessageType.audio,
                                  audioDuration: Duration(seconds: 10),
                                ),
                              ),
                          child: VoiceMessageBubble1(
                            isSender: true,
                            audioUrl:
                                'https://github.com/rafaelreis-hotmart/Audio-Sample/raw/master/sample.mp3',
                            duration: '0:10',
                            time: '09:20',
                            isRead: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── رسالة نصية ───────────────────────
                      Dismissible(
                        key: const ValueKey('msg_001'),
                        direction: DismissDirection.endToStart,
                        background: _buildSwipeActionBackground(true),
                        confirmDismiss: (direction) async {
                          _startReply(
                            const ReplyMessageModel(
                              id: 'msg_001',
                              senderName: 'you',
                              type: ReplyMessageType.text,
                              text:
                                  'Hi, how are you? Is the device still available?',
                            ),
                          );
                          HapticFeedback.lightImpact();
                          return false;
                        },
                        child: GestureDetector(
                          onLongPress:
                              () => _startReply(
                                const ReplyMessageModel(
                                  id: 'msg_001',
                                  senderName: 'you',
                                  type: ReplyMessageType.text,
                                  text:
                                      'Hi, how are you? Is the device still available?',
                                ),
                              ),
                          child: TextMessageBubble(
                            isSender: true,
                            message:
                                'Hi, how are you? Is the device still available?',
                            time: '9:24 AM',
                            isRead: true,
                            id: 1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── رسالة صورة ───────────────────────
                      Dismissible(
                        key: const ValueKey('msg_002'),
                        direction: DismissDirection.startToEnd,
                        background: _buildSwipeActionBackground(false),
                        confirmDismiss: (direction) async {
                          _startReply(
                            const ReplyMessageModel(
                              id: 'msg_002',
                              senderName: 'Ahmad',
                              type: ReplyMessageType.image,
                              imageUrl:
                                  'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
                            ),
                          );
                          HapticFeedback.lightImpact();
                          return false;
                        },
                        child: GestureDetector(
                          onLongPress:
                              () => _startReply(
                                const ReplyMessageModel(
                                  id: 'msg_002',
                                  senderName: 'Ahmad',
                                  type: ReplyMessageType.image,
                                  imageUrl:
                                      'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
                                ),
                              ),
                          child: ReplyMessageBubble3(
                            isSender: false,
                            contentType: ReplyBubbleContentType.image,
                            imageUrl:
                                'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
                            imageCaption: 'This is the device in question.',
                            time: '9:24 AM',
                            isRead: true,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── رد على صورة بنص ──────────────────
                      ReplyMessageBubble3(
                        isSender: false,
                        time: '10:45 PM',
                        isRead: false,
                        isDelivered: true,
                        contentType: ReplyBubbleContentType.text,
                        message:
                            "Could you send clearer photos from the other side?",
                        replyTo: const ReplyMessageModel(
                          id: 'msg_002',
                          senderName: 'you',
                          type: ReplyMessageType.image,
                          imageUrl:
                              'https://images.unsplash.com/photo-1521939094609-93aba1af40d7',
                          imageCaption: 'laptop photos',
                        ),
                      ),
                      ReplyMessageBubble4(
                        isSender: true,
                        time: '09:20',
                        isRead: true,
                        contentType: ReplyBubbleContentType4.audio,
                        audioUrl:
                            'https://github.com/rafaelreis-hotmart/Audio-Sample/raw/master/sample.mp3',
                        audioDurationLabel: '0:10',
                        replyTo: const ReplyMessageModel(
                          id: 'msg_voice_001',
                          senderName: 'you',
                          type: ReplyMessageType.audio,
                          audioDuration: Duration(seconds: 10),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── رد على صوت بصورة ─────────────────
                      ReplyMessageBubble3(
                        time: '11:00 PM',
                        isRead: true,
                        contentType: ReplyBubbleContentType.image,
                        imageUrl:
                            'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b',
                        imageCaption: "Payment receipt",
                        replyTo: const ReplyMessageModel(
                          id: 'msg_003',
                          senderName: 'Ahmad',
                          type: ReplyMessageType.audio,
                          audioDuration: Duration(seconds: 42),
                        ),
                        isSender: false,
                      ),

                      const SizedBox(height: 12),

                      // ── رد بصوت على نص ───────────────────
                      ReplyMessageBubble3(
                        isSender: true,
                        time: '09:20',
                        isRead: true,
                        contentType: ReplyBubbleContentType.audio,
                        audioDuration: const Duration(seconds: 10),
                        audioProgress: 0.0,
                        isAudioPlaying: false,
                        onAudioPlayPause: () {},
                        replyTo: const ReplyMessageModel(
                          id: 'msg_voice_001',
                          senderName: 'you',
                          type: ReplyMessageType.audio,
                          audioDuration: Duration(seconds: 10),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── مؤشر الكتابة ─────────────────────
                      ..._messages.map((data) => _buildMessageWidget(data)),
                      if (_isOtherUserTyping)
                        TypingIndicatorBubble(isSender: false),
                    ],
                  ),
                ),
              ),

              // ── شريط الرد (يظهر فقط عند اختيار رسالة للرد) ──
              ChatInputBarFinal5(
                replyingTo: _activeReply,
                onCancelReply: _cancelReply,
                onSend: _onSend,
                onImageSelected: _onImageSelected,
                onCameraCapture: _onCameraCapture,
                onFileSelected: _onFileSelected,
                onVoiceMessage: (filePath, durationSeconds) {
                  final messageData = _MessageData(
                    model: ReplyMessageModel(
                      id: 'local_aud_${DateTime.now().millisecondsSinceEpoch}',
                      senderName: 'you',
                      type: ReplyMessageType.audio,
                      audioDuration: Duration(seconds: durationSeconds),
                      audioLocalPath: filePath,
                    ),
                  );

                  setState(() {
                    _messages.add(messageData);
                  });
                  _cancelReply();
                  _simulateReceivingMessage();
                },
              ),
              // ── شريط الإدخال ───────────────────────────────
              // ChatInputBarFinal4(
              //   onCancelReply: _cancelReply,
              //   // مرر _activeReply لـ ChatInputBarFinal إذا كان يقبله
              //   // activeReply: _activeReply,
              // ),
            ],
          ),
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

extension on ReplyMessageType {
  ReplyBubbleContentType toBubbleContentType() {
    switch (this) {
      case ReplyMessageType.text:
        return ReplyBubbleContentType.text;
      case ReplyMessageType.image:
        return ReplyBubbleContentType.image;
      case ReplyMessageType.audio:
        return ReplyBubbleContentType.audio;
      case ReplyMessageType.file:
        return ReplyBubbleContentType.file;
      default:
        return ReplyBubbleContentType.text; // Fallback
    }
  }
}
