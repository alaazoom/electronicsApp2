import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/reply_message_model.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/reply_preview_widget.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';

class ChatInputBarFinal5 extends StatefulWidget {
  final bool showSuggestions;
  final Function(String)? onSend;
  final Function(XFile)? onImageSelected;
  final Function(XFile)? onCameraCapture;
  final Function(PlatformFile)? onFileSelected;

  /// ✅ يُرسَل مسار الملف الصوتي الحقيقي + مدته بالثواني
  final Function(String filePath, int durationSeconds)? onVoiceMessage;

  final VoidCallback? onCancelReply;
  final ReplyMessageModel? replyingTo;
  final int maxLines;
  final int minLines;
  final String hintText;
  final bool enableAnimations;

  const ChatInputBarFinal5({
    super.key,
    this.showSuggestions = true,
    this.onSend,
    this.onImageSelected,
    this.onCameraCapture,
    this.onFileSelected,
    this.onVoiceMessage,
    this.onCancelReply,
    this.replyingTo,
    this.maxLines = 4,
    this.minLines = 1,
    this.hintText = "Write a message...",
    this.enableAnimations = true,
  });

  @override
  State<ChatInputBarFinal5> createState() => _ChatInputBarFinal5State();
}

class _ChatInputBarFinal5State extends State<ChatInputBarFinal5>
    with SingleTickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  late AnimationController _animController;

  // ── تسجيل صوتي حقيقي ──────────────────────────────────────
  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _recordTimer;
  int _recordSeconds = 0;
  String? _recordingPath; // مسار الملف المؤقت

  // ── State ─────────────────────────────────────────────────
  bool _hasText = false;
  bool _isRecording = false;
  bool _isFocused = false;
  bool _showEmojiPicker = false;
  bool _micPermissionDenied = false;

  final List<String> _emojis = [
    '😀','😃','😄','😁','😆','😅','🤣','😂',
    '❤️','🧡','💛','💚','💙','💜','🖤','🤍',
    '👍','👎','👏','🙌','👋','🤝','✋','🤚',
    '🎉','🎊','🎈','🎁','🎀','🎂','🍰','🎃',
    '😍','🥰','😘','😗','😚','😙','🥲','😋',
    '😜','😛','🤪','😝','🤑','🤗','🤭','🤫',
    '🤔','🤐','🤨','😐','😑','😶','😏','😒',
    '🙄','😬','🤥','😌','😔','😪','🤤','😴',
  ];

  // ════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  // Listeners
  // ════════════════════════════════════════════════════════

  void _onTextChanged() {
    if (!mounted) return;
    final has = _controller.text.trim().isNotEmpty;
    if (has != _hasText) {
      setState(() => _hasText = has);
      has ? _animController.forward() : _animController.reverse();
    }
  }

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused) _showEmojiPicker = false;
    });
  }

  // ════════════════════════════════════════════════════════
  // ✅ تسجيل صوتي حقيقي
  // ════════════════════════════════════════════════════════

  Future<bool> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      setState(() => _micPermissionDenied = true);
      if (status.isPermanentlyDenied) openAppSettings();
      return false;
    }
    setState(() => _micPermissionDenied = false);
    return true;
  }

  Future<void> _startRecording() async {
    if (_hasText || _isRecording) return;

    // طلب الصلاحية
    final granted = await _requestMicPermission();
    if (!granted) {
      _showPermissionSnackbar();
      return;
    }

    try {
      // مسار الملف المؤقت
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordingPath = '${dir.path}/voice_$timestamp.m4a';

      // بدء التسجيل الحقيقي
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );

      HapticFeedback.mediumImpact();
      setState(() {
        _isRecording = true;
        _recordSeconds = 0;
      });

      // عداد الوقت
      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _recordSeconds++);
      });

      debugPrint('🎙️ Recording started → $_recordingPath');
    } catch (e) {
      debugPrint('❌ Recording error: $e');
      _showErrorSnackbar('Failed to start recording');
    }
  }

  Future<void> _stopAndSendRecording() async {
    if (!_isRecording) return;

    try {
      _recordTimer?.cancel();
      final duration = _recordSeconds;

      // إيقاف التسجيل الحقيقي والحصول على المسار
      final path = await _audioRecorder.stop();

      HapticFeedback.lightImpact();
      setState(() {
        _isRecording = false;
        _recordSeconds = 0;
      });

      if (path != null && duration > 0) {
        widget.onVoiceMessage?.call(path, duration);
        debugPrint('✅ Voice sent → $path (${duration}s)');
      } else if (duration == 0) {
        // تسجيل قصير جداً — احذف الملف
        if (path != null) File(path).deleteSync();
        debugPrint('⚠️ Recording too short, discarded');
      }
    } catch (e) {
      debugPrint('❌ Stop recording error: $e');
      setState(() => _isRecording = false);
    }
  }

  Future<void> _cancelRecording() async {
    if (!_isRecording) return;
    _recordTimer?.cancel();

    try {
      final path = await _audioRecorder.stop();
      // احذف الملف المؤقت
      if (path != null && File(path).existsSync()) {
        File(path).deleteSync();
      }
    } catch (_) {}

    HapticFeedback.selectionClick();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
      _recordingPath = null;
    });
    debugPrint('❌ Recording cancelled & file deleted');
  }

  void _showPermissionSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Microphone permission is required'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: openAppSettings,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // إرسال نص
  // ════════════════════════════════════════════════════════

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    widget.onSend?.call(text);
    _controller.clear();
  }

  // ════════════════════════════════════════════════════════
  // مرفقات
  // ════════════════════════════════════════════════════════

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null && mounted) {
        widget.onCameraCapture?.call(photo);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ Camera error: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        widget.onImageSelected?.call(image);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ Gallery error: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty && mounted) {
        widget.onFileSelected?.call(result.files.first);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ File error: $e');
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttachmentMenu(
        onCamera: _openCamera,
        onGallery: _pickImage,
        onFile: _pickFile,
        onLocation: () {
          debugPrint('📍 Select location');
          Navigator.pop(context);
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // Build
  // ════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyingTo != null) _buildReplyPreview(),

        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: _isRecording
                    ? _buildRecordingRow()
                    : _buildNormalInputRow(),
              ),
              if (_showEmojiPicker && !_isRecording) _buildEmojiPicker(),
            ],
          ),
        ),
      ],
    );
  }

  // ── شريط معاينة الرد ──────────────────────────────────────
  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            // استخدام نفس ودجت المعاينة للحصول على تصميم متناسق
            child: ReplyPreviewWidget(
              reply: widget.replyingTo!,
              // المستخدم هو دائمًا مرسل الرد الجديد
              isSender: true,
            ),
          ),
          const SizedBox(width: 8),
          // زر الإلغاء
          GestureDetector(
            onTap: widget.onCancelReply,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.hint.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: AppColors.hint),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalInputRow() {
    return Row(
      key: const ValueKey('normal'),
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _IconBtn(
          icon: _showEmojiPicker
              ? Icons.keyboard_alt_outlined
              : Icons.emoji_emotions_outlined,
          onTap: () {
            setState(() => _showEmojiPicker = !_showEmojiPicker);
            if (_showEmojiPicker) _focusNode.unfocus();
          },
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: _isFocused
                    ? Colors.blue.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _hasText
                      ? GestureDetector(
                          key: const ValueKey('clear'),
                          onTap: _controller.clear,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Icons.close,
                                size: 18, color: Colors.grey.shade500),
                          ),
                        )
                      : GestureDetector(
                          key: const ValueKey('attach'),
                          onTap: _showAttachmentMenu,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Icons.attach_file,
                                size: 20, color: Colors.grey.shade500),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildSendMicButton(),
      ],
    );
  }

  Widget _buildSendMicButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _hasText ? Colors.blue : Colors.grey.shade300,
        shape: BoxShape.circle,
        boxShadow: _hasText
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: _hasText
          // ── إرسال نص ──
          ? GestureDetector(
              onTap: _sendMessage,
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 22),
            )
          // ── تسجيل صوت ── اضغط مطولاً
          : GestureDetector(
              onLongPressStart: (_) => _startRecording(),
              onLongPressEnd: (_) => _stopAndSendRecording(),
              onLongPressCancel: _cancelRecording,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.mic_rounded,
                      color: Colors.grey.shade700, size: 24),
                  if (_micPermissionDenied)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildRecordingRow() {
    return Row(
      key: const ValueKey('recording'),
      children: [
        // زر الإلغاء
        GestureDetector(
          onTap: _cancelRecording,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delete_outline,
                color: Colors.red, size: 22),
          ),
        ),
        const SizedBox(width: 12),
        // شريط التسجيل
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.06),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const _PulsingDot(),
                const SizedBox(width: 10),
                Text(
                  _formatDuration(_recordSeconds),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                Text(
                  'Release to send',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _stopAndSendRecording,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded,
                color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiPicker() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: _emojis.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () {
            final text = _controller.text;
            final sel = _controller.selection;
            final start = sel.start < 0 ? text.length : sel.start;
            final end = sel.end < 0 ? text.length : sel.end;
            final newText = text.replaceRange(start, end, _emojis[i]);
            _controller.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(
                  offset: start + _emojis[i].length),
            );
          },
          child: Center(
            child: Text(_emojis[i], style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }

  static String _formatDuration(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}


class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 24, color: Colors.grey.shade600),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _AttachmentMenu extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;
  final VoidCallback onLocation;

  const _AttachmentMenu({
    required this.onCamera,
    required this.onGallery,
    required this.onFile,
    required this.onLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AttachOption(icon: Icons.camera_alt_outlined,
                    label: 'Camera', color: Colors.purple, onTap: onCamera),
                _AttachOption(icon: Icons.image_outlined,
                    label: 'Gallery', color: Colors.blue, onTap: onGallery),
                _AttachOption(icon: Icons.insert_drive_file_outlined,
                    label: 'Files', color: Colors.orange, onTap: onFile),
                _AttachOption(icon: Icons.location_on_outlined,
                    label: 'Location', color: Colors.green, onTap: onLocation),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
