import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

// تم نقل ReplyMessage لملف منفصل لتسهيل الاستخدام
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

enum MessageType { text, image, audio, file }

class ChatInputBarFinal1 extends StatefulWidget {
  final bool showSuggestions;
  final Function(String)? onSend;
  final Function(XFile)? onImageSelected;
  final Function(XFile)? onCameraCapture;
  final Function(PlatformFile)? onFileSelected;
  final VoidCallback? onAttach;
  final VoidCallback? onCamera;
  final VoidCallback? onEmoji;
  final Function(String)? onVoiceMessage;
  final Function(ReplyMessage)? onReply;
  final ReplyMessage? replyingTo;
  final VoidCallback? onCancelReply;
  final int maxLines;
  final int minLines;
  final String hintText;
  final bool enableAnimations;

  const ChatInputBarFinal1({
    super.key,
    this.showSuggestions = true,
    this.onSend,
    this.onImageSelected,
    this.onCameraCapture,
    this.onFileSelected,
    this.onAttach,
    this.onCamera,
    this.onEmoji,
    this.onVoiceMessage,
    this.onReply,
    this.replyingTo,
    this.onCancelReply,
    this.maxLines = 4,
    this.minLines = 1,
    this.hintText = "Write a message...",
    this.enableAnimations = true,
  });

  @override
  State<ChatInputBarFinal1> createState() => _ChatInputBarFinal1State();
}

class _ChatInputBarFinal1State extends State<ChatInputBarFinal1>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  late AnimationController _animationController;

  bool _hasText = false;
  bool _isRecording = false;
  bool _isFocused = false;
  bool _showEmojiPicker = false;
  bool _suggestionsShownOnce = false; // للتحكم في ظهور الاقتراحات أول مرة فقط

  Timer? _timer;
  int _seconds = 0;

  final List<String> _emojis = [
    '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂',
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍',
    '👍', '👎', '👏', '🙌', '👋', '🤝', '✋', '🤚',
    '🎉', '🎊', '🎈', '🎁', '🎀', '🎂', '🍰', '🎃',
    '😍', '🥰', '😘', '😗', '😚', '😙', '🥲', '😋',
    '😜', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭',
    '🤫', '🤔', '🤐', '🤨', '😐', '😑', '😶', '😏',
    '😒', '🙄', '😬', '🤥', '😌', '😔', '😪', '🤤',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);
  }

  void _onTextChanged() {
    if (!mounted) return;
    final newHasText = _controller.text.trim().isNotEmpty;
    
    // إذا بدأ المستخدم بالكتابة لأول مرة، نحدد أن الاقتراحات ظهرت ولن تظهر ثانية
    if (newHasText && !_suggestionsShownOnce) {
      setState(() {
        _suggestionsShownOnce = true;
      });
    }

    if (newHasText != _hasText) {
      setState(() => _hasText = newHasText);
      if (widget.enableAnimations) {
        if (_hasText) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused) {
        _showEmojiPicker = false;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        widget.onCameraCapture?.call(photo);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ خطأ في فتح الكاميرا: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        widget.onImageSelected?.call(image);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ خطأ في اختيار الصورة: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        widget.onFileSelected?.call(result.files.first);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ خطأ في اختيار الملف: $e');
    }
  }

  Future<void> _startRecording() async {
    if (_hasText) return;
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });
    debugPrint('🎙️ بدء التسجيل الصوتي');
    
    // ملاحظة: لتسجيل الصوت فعلياً تحتاج لمكتبة مثل record أو flutter_sound
    // المسار المقترح لحفظ الملفات الصوتية:
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/voice_record_${DateTime.now().millisecondsSinceEpoch}.m4a';
    debugPrint('📂 سيتم حفظ الملف في: $path');
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() => _isRecording = false);
    widget.onVoiceMessage?.call('$_seconds');
    debugPrint('✅ تم إرسال الرسالة الصوتية ($_seconds sec)');
  }

  void _cancelRecording() {
    _timer?.cancel();
    setState(() => _isRecording = false);
    debugPrint('❌ تم إلغاء التسجيل');
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
    debugPrint('📤 تم إرسال: $text');
  }

  void _clearText() {
    _controller.clear();
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentMenu(),
    );
  }

  Widget _buildAttachmentMenu() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.purple,
                  onTap: _openCamera,
                ),
                _buildAttachmentOption(
                  icon: Icons.image,
                  label: 'Gallery',
                  color: Colors.blue,
                  onTap: _pickImage,
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.orange,
                  onTap: _pickFile,
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.green,
                  onTap: () {
                    debugPrint('📍 اختيار الموقع');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // إظهار الاقتراحات فقط إذا لم تظهر من قبل ولم يبدأ المستخدم بالكتابة
        if (widget.showSuggestions && !_suggestionsShownOnce && !_hasText)
          _buildSuggestions(),
          
        if (widget.replyingTo != null) _buildReplyPreview(),

        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputRow(),
              if (_showEmojiPicker) _buildSimpleEmojiPicker(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    // هنا يمكنك وضع الودجت الخاص بالاقتراحات
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildSuggestionChip("Is it available?"),
            _buildSuggestionChip("What is the price?"),
            _buildSuggestionChip("Where are you located?"),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        onPressed: () {
          _controller.text = text;
          _onTextChanged();
        },
        backgroundColor: Colors.blue.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: const Border(left: BorderSide(color: Colors.blue, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.replyingTo!.senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.replyingTo!.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.grey),
            onPressed: widget.onCancelReply,
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            setState(() => _showEmojiPicker = !_showEmojiPicker);
            if (_showEmojiPicker) {
              _focusNode.unfocus();
            }
          },
          icon: Icon(
            _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
            size: 24,
            color: Colors.grey[600],
          ),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isFocused
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
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
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                // زر الملفات يظهر دائماً أو عند عدم وجود نص حسب رغبتك
                // هنا جعلته يظهر بلون أزرق بدلاً من الأحمر
                IconButton(
                  icon: const Icon(Icons.attach_file, size: 20, color: Colors.blue),
                  onPressed: _showAttachmentMenu,
                  tooltip: 'Attach file',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        _buildSendButton(),
      ],
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _hasText ? _sendMessage : null,
      onLongPress: _hasText ? null : _startRecording,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _hasText ? Colors.blue : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          _hasText ? Icons.send_rounded : Icons.mic_rounded,
          color: _hasText ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSimpleEmojiPicker() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
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
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller.text += _emojis[index];
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
              _onTextChanged();
            },
            child: Center(
              child: Text(
                _emojis[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }
}
