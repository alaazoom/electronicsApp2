import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

class RecordingBar extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String path) onFinish;

  const RecordingBar({
    super.key,
    required this.onCancel,
    required this.onFinish,
  });

  @override
  State<RecordingBar> createState() => _RecordingBarState();
}

class _RecordingBarState extends State<RecordingBar> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  String? _path;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
    _startRecording();
  }

  void _startRecording() async {
    _path = 'voice_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(
      toFile: _path,
      codec: Codec.aacMP4,
    );

    setState(() => _isRecording = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _stopRecording() async {
    await _recorder.stopRecorder();
    _timer?.cancel();
    widget.onFinish(_path!);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onCancel,
          ),

          // 🎵 Fake Wave (رح نحولها real بعد شوي)
          Expanded(
            child: Row(
              children: List.generate(
                20,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 3,
                  height: (i % 2 == 0 ? 12 : 24),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          Text(
            _formatTime(_seconds),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(width: 8),

          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.green,
            onPressed: _stopRecording,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return "$m:$r";
  }
}
