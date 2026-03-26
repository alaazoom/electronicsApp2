// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class RealTimeRecordingBubble extends StatefulWidget {
//   final VoidCallback onCancel;
//   final Function(String path) onSend;

//   const RealTimeRecordingBubble({
//     super.key,
//     required this.onCancel,
//     required this.onSend,
//   });

//   @override
//   State<RealTimeRecordingBubble> createState() =>
//       _RealTimeRecordingBubbleState();
// }

// class _RealTimeRecordingBubbleState extends State<RealTimeRecordingBubble> {
//   late final AudioRecorder _audioRecorder;

//   StreamSubscription<Amplitude>? _amplitudeSubscription;
//   Timer? _timer;

//   final List<double> _waves = [];
//   int _seconds = 0;
//   String? _filePath;

//   @override
//   void initState() {
//     super.initState();
//     _audioRecorder = AudioRecorder();
//     _startRecording();
//   }

//   Future<void> _startRecording() async {
//     try {
//       final mic = await Permission.microphone.request();
//       if (!mic.isGranted) {
//         debugPrint("❌ Microphone permission denied");
//         return;
//       }

//       final dir = await getApplicationDocumentsDirectory();
//       _filePath =
//           '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

//       await _audioRecorder.start(
//         const RecordConfig(
//           encoder: AudioEncoder.aacLc,
//           bitRate: 128000,
//           sampleRate: 44100,
//         ),
//         path: _filePath!,
//       );

//       _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//         setState(() => _seconds++);
//       });

//       _amplitudeSubscription = _audioRecorder
//           .onAmplitudeChanged(const Duration(milliseconds: 120))
//           .listen((amp) {
//         final v = ((amp.current + 60) / 60).clamp(0.05, 1.0);
//         setState(() {
//           _waves.add(v);
//           if (_waves.length > 40) _waves.removeAt(0);
//         });
//       });
//     } catch (e, s) {
//       debugPrint("🔥 Recording error: $e");
//       debugPrint("$s");
//     }
//   }

//   Future<void> _stopAndSend() async {
//     final path = await _audioRecorder.stop();
//     _cleanup();
//     if (path != null) widget.onSend(path);
//   }

//   Future<void> _cancel() async {
//     final path = await _audioRecorder.stop();
//     if (path != null) {
//       final f = File(path);
//       if (await f.exists()) await f.delete();
//     }
//     _cleanup();
//     widget.onCancel();
//   }

//   void _cleanup() {
//     _timer?.cancel();
//     _amplitudeSubscription?.cancel();
//   }

//   @override
//   void dispose() {
//     _cleanup();
//     _audioRecorder.dispose();
//     super.dispose();
//   }

//   String _formatTime(int s) =>
//       "${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: _cancel,
//             child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Container(
//               height: 50,
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(color: Colors.purple.withOpacity(0.2)),
//               ),
//               child: Row(
//                 children: [
//                   const _BlinkingDot(),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: CustomPaint(
//                       painter: _WavePainter(_waves, Colors.purple),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     _formatTime(_seconds),
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           GestureDetector(
//             onTap: _stopAndSend,
//             child: const CircleAvatar(
//               radius: 24,
//               backgroundColor: Colors.purple,
//               child: Icon(Icons.send, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class _WavePainter extends CustomPainter {
//   final List<double> waves;
//   final Color color;

//   _WavePainter(this.waves, this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 3
//       ..strokeCap = StrokeCap.round;

//     final centerY = size.height / 2;
//     final spacing = size.width / 40;

//     for (int i = 0; i < waves.length; i++) {
//       final x = i * spacing;
//       final h = waves[i] * size.height * 0.8;
//       canvas.drawLine(
//         Offset(x, centerY - h / 2),
//         Offset(x, centerY + h / 2),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_) => true;
// }

// class _BlinkingDot extends StatefulWidget {
//   const _BlinkingDot();

//   @override
//   State<_BlinkingDot> createState() => _BlinkingDotState();
// }

// class _BlinkingDotState extends State<_BlinkingDot>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _c;

//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _c,
//       child: const Icon(Icons.circle, size: 10, color: Colors.red),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RealTimeRecordingBubble extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String path) onSend;

  const RealTimeRecordingBubble({
    super.key,
    required this.onCancel,
    required this.onSend,
  });

  @override
  State<RealTimeRecordingBubble> createState() =>
      _RealTimeRecordingBubbleState();
}

class _RealTimeRecordingBubbleState extends State<RealTimeRecordingBubble> {
  late final AudioRecorder _audioRecorder;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  Timer? _timer;

  final List<double> _waves = [];
  int _seconds = 0;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _startRecording();
  }
Future<void> _startRecording() async {
  try {
    // 1. التحقق من الإذن بشكل صريح
    if (!await _audioRecorder.hasPermission()) {
      debugPrint("❌ لم يتم منح إذن الميكروفون");
      return;
    }

    // 2. الحصول على مسار صحيح ومؤكد
    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    // 3. التحقق من الحالة قبل البدء (لتجنب خطأ البدء مرتين)
    if (await _audioRecorder.isRecording()) return;

    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc), 
      path: _filePath!,
    );

    // 4. تشغيل التايمر والموجات
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });

    _amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 120))
        .listen((amp) {
      // تحويل الديسيبل إلى قيمة تناسب الرسم
      final v = ((amp.current + 60) / 60).clamp(0.1, 1.0);
      if (mounted) {
        setState(() {
          _waves.add(v);
          if (_waves.length > 40) _waves.removeAt(0);
        });
      }
    });
  } catch (e) {
    debugPrint("🔥 خطأ أثناء محاولة التسجيل: $e");
  }
}
  // Future<void> _startRecording() async {
  //   try {
  //     if (!await _audioRecorder.hasPermission()) {
  //       debugPrint("❌ No microphone permission");
  //       return;
  //     }

  //     final dir = await getTemporaryDirectory();
  //     _filePath =
  //         '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

  //     await _audioRecorder.start(
  //       const RecordConfig(
  //         encoder: AudioEncoder.aacLc,
  //         bitRate: 128000,
  //         sampleRate: 44100,
  //       ),
  //       path: _filePath!,
  //     );

  //     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //       setState(() => _seconds++);
  //     });

  //     _amplitudeSubscription = _audioRecorder
  //         .onAmplitudeChanged(const Duration(milliseconds: 120))
  //         .listen((amp) {
  //       final v = ((amp.current + 60) / 60).clamp(0.05, 1.0);
  //       setState(() {
  //         _waves.add(v);
  //         if (_waves.length > 40) _waves.removeAt(0);
  //       });
  //     });
  //   } catch (e) {
  //     debugPrint("🔥 Recording error: $e");
  //   }
  // }

  Future<void> _stopAndSend() async {
    final path = await _audioRecorder.stop();
    _cleanup();
    if (path != null) widget.onSend(path);
  }

  Future<void> _cancel() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      final f = File(path);
      if (await f.exists()) await f.delete();
    }
    _cleanup();
    widget.onCancel();
  }

  void _cleanup() {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
  }

  @override
  void dispose() {
    _cleanup();
    _audioRecorder.dispose();
    super.dispose();
  }

  String _formatTime(int s) =>
      "${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: _cancel,
            child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.purple.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const _BlinkingDot(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomPaint(
                      painter: _WavePainter(_waves, Colors.purple),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _stopAndSend,
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.purple,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final List<double> waves;
  final Color color;

  _WavePainter(this.waves, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final spacing = size.width / 40;

    for (int i = 0; i < waves.length; i++) {
      final x = i * spacing;
      final h = waves[i] * size.height * 0.8;
      canvas.drawLine(
        Offset(x, centerY - h / 2),
        Offset(x, centerY + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: const Icon(Icons.circle, size: 10, color: Colors.red),
    );
  }
}
