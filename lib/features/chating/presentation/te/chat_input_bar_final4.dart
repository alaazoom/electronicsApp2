import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/te/reply_message_model.dart';


class ChatInputBarFinal4 extends StatefulWidget {
  final bool showSuggestions;
  final Function(String)? onSend;
  final Function(XFile)? onImageSelected;
  final Function(XFile)? onCameraCapture;
  final Function(PlatformFile)? onFileSelected;
  final Function(int secondsDuration)? onVoiceMessage;
  final VoidCallback? onCancelReply;                  
  final ReplyMessageModel? replyingTo;
  final int maxLines;
  final int minLines;
  final String hintText;
  final bool enableAnimations;

  const ChatInputBarFinal4({
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
  State<ChatInputBarFinal4> createState() => _ChatInputBarFinal4State();
}

class _ChatInputBarFinal4State extends State<ChatInputBarFinal4>
    with SingleTickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  late AnimationController _animController;
  late Animation<double> _sendBtnAnim;

  // ── State ─────────────────────────────────────────────────
  bool _hasText = false;
  bool _isRecording = false;
  bool _isFocused = false;
  bool _showEmojiPicker = false;

  // ── تسجيل صوتي ────────────────────────────────────────────
  Timer? _recordTimer;
  int _recordSeconds = 0;

  // ── إيموجي ────────────────────────────────────────────────
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
    _sendBtnAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
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

 
  void _startRecording() {
    if (_hasText || _isRecording) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _recordSeconds++);
    });
    debugPrint("Recording started 🎙️");
  }

  void _stopAndSendRecording() {
    if (!_isRecording) return;
    _recordTimer?.cancel();
    final duration = _recordSeconds;
    HapticFeedback.lightImpact();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
    widget.onVoiceMessage?.call(duration);
    debugPrint("✅ Voice message sent — Duration: ${duration} seconds");
  }

  void _cancelRecording() {
    _recordTimer?.cancel();
    HapticFeedback.selectionClick();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
    debugPrint("❌ Recording cancelled");
  }


  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    widget.onSend?.call(text);
    _controller.clear();
  }

  
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
          debugPrint('📍Select location');
          Navigator.pop(context);
        },
      ),
    );
  }


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
                child: _isRecording
                    ? _buildRecordingRow()
                    : _buildNormalInputRow(),
              ),
              if (_showEmojiPicker && !_isRecording)
                _buildEmojiPicker(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyPreview() {
    final reply = widget.replyingTo!;
    
    String displayContent = '';
    if (reply.type == ReplyMessageType.text) {
      displayContent = reply.text ?? '';
    } else if (reply.type == ReplyMessageType.image) {
      displayContent = reply.imageCaption ?? 'Image message';
    } else if (reply.type == ReplyMessageType.audio) {
      displayContent = 'Voice message';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          left: const BorderSide(color: Colors.blue, width: 4),
        ),
      ),
      child: Row(
        children: [
          // أيقونة الرد
          const Icon(Icons.reply, size: 18, color: Colors.blue),
          const SizedBox(width: 10),
          // محتوى الرد
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reply.senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (reply.type == ReplyMessageType.image)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.image_outlined,
                            size: 13, color: Colors.grey),
                      ),
                    if (reply.type == ReplyMessageType.audio)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.mic_outlined,
                            size: 13, color: Colors.grey),
                      ),
                    Flexible(
                      child: Text(
                        displayContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onCancelReply,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // ── صف الإدخال العادي ─────────────────────────────────────
  Widget _buildNormalInputRow() {
    return Row(
      key: const ValueKey('normal'),
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // زر الإيموجي
        _IconBtn(
          icon: _showEmojiPicker
              ? Icons.keyboard_alt_outlined
              : Icons.emoji_emotions_outlined,
          onTap: () {
            setState(() => _showEmojiPicker = !_showEmojiPicker);
            if (_showEmojiPicker) _focusNode.unfocus();
          },
        ),

        // حقل الإدخال
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
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
          ? GestureDetector(
              onTap: _sendMessage,
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 22),
            )
          : GestureDetector(
              onLongPressStart: (_) => _startRecording(),
              onLongPressEnd: (_) => _stopAndSendRecording(),
              onLongPressCancel: _cancelRecording,
              child: Icon(Icons.mic_rounded,
                  color: Colors.grey.shade700, size: 24),
            ),
    );
  }

  Widget _buildRecordingRow() {
    return Row(
      key: const ValueKey('recording'),
      children: [
        GestureDetector(
          onTap: _cancelRecording,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.delete_outline, color: Colors.red, size: 22),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.06),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                _PulsingDot(),
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
"← Slide to send",                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // زر الإرسال
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
            final newText = text.replaceRange(
              sel.start < 0 ? text.length : sel.start,
              sel.end < 0 ? text.length : sel.end,
              _emojis[i],
            );
            _controller.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(
                offset: (sel.start < 0 ? text.length : sel.start) + 2,
              ),
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
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(_ctrl);
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
                _AttachOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'camera',
                  color: Colors.purple,
                  onTap: onCamera,
                ),
                _AttachOption(
                  icon: Icons.image_outlined,
                  label: 'Gallery',
                  color: Colors.blue,
                  onTap: onGallery,
                ),
                _AttachOption(
                  icon: Icons.insert_drive_file_outlined,
                  label: 'Files',
                  color: Colors.orange,
                  onTap: onFile,
                ),
                _AttachOption(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  color: Colors.green,
                  onTap: onLocation,
                ),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
