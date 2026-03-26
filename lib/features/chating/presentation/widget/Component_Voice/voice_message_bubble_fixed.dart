import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender ? const Color(0x1A2563EB) : const Color(0x1A10B981);
    final themeColor = isSender ? const Color(0xFF2563EB) : const Color(0xFF10B981);

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: _VoiceMessageContent(
          isSender: isSender,
          audioUrl: audioUrl,
          themeColor: themeColor,
          duration: duration,
          time: time,
          isRead: isRead,
        ),
      ),
    );
  }
}

class _VoiceMessageContent extends StatefulWidget {
  final bool isSender;
  final String audioUrl;
  final Color themeColor;
  final String duration;
  final String time;
  final bool isRead;

  const _VoiceMessageContent({
    required this.isSender,
    required this.audioUrl,
    required this.themeColor,
    required this.duration,
    required this.time,
    required this.isRead,
  });

  @override
  State<_VoiceMessageContent> createState() => _VoiceMessageContentState();
}

class _VoiceMessageContentState extends State<_VoiceMessageContent> {
  late final PlayerController _waveController;
  bool isPlaying = false;
  bool isInitialized = false;
  bool isLoading = true;
  bool hasError = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _waveController = PlayerController();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      if (widget.audioUrl.isEmpty) {
        _setError('الرابط فارغ');
        return;
      }

      final path = await _resolveAudioPath(widget.audioUrl);

      if (!mounted) return;

      await _waveController.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: 35,
        volume: 1.0,
      );

      _waveController.onCurrentDurationChanged.listen((duration) {
        if (mounted) {
          setState(() {
            currentPosition = Duration(milliseconds: duration);
          });
        }
      });

      _waveController.onPlayerStateChanged.listen((state) {
        if (mounted) {
          if (state == PlayerState.stopped || state == PlayerState.paused) {
            setState(() => isPlaying = false);
          } else if (state == PlayerState.playing) {
            setState(() => isPlaying = true);
          }
        }
      });

      _waveController.getDuration().then((duration) {
        if (mounted) {
          setState(() {
            totalDuration = Duration(milliseconds: duration.toInt());
          });
        }
      });

      if (mounted) {
        setState(() {
          isInitialized = true;
          isLoading = false;
          hasError = false;
        });
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الملف الصوتي: $e');
      _setError('فشل تحميل الملف الصوتي');
    }
  }

  Future<String> _resolveAudioPath(String source) async {
    final trimmed = source.trim();
    final uri = Uri.tryParse(trimmed);
    final isRemote = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    if (isRemote) {
      final file = await DefaultCacheManager().getSingleFile(trimmed);
      return file.path;
    }

    if (trimmed.startsWith('file://')) {
      return Uri.parse(trimmed).toFilePath();
    }

    if (await File(trimmed).exists()) {
      return trimmed;
    }

    throw Exception('Audio file not found: $trimmed');
  }

  void _setError(String message) {
    if (mounted) {
      setState(() {
        isLoading = false;
        hasError = true;
        isInitialized = true;
      });
    }
    debugPrint('⚠️ $message');
  }

  void _togglePlay() async {
    if (!isInitialized || hasError) return;

    try {
      if (isPlaying) {
        await _waveController.pausePlayer();
        if (mounted) setState(() => isPlaying = false);
      } else {
        await _waveController.startPlayer();
        if (mounted) setState(() => isPlaying = true);
      }
    } catch (e) {
      debugPrint('❌ خطأ في التشغيل: $e');
      _setError('فشل في تشغيل الملف');
    }
  }

  Future<void> _resetAudio() async {
    try {
      await _waveController.stopPlayer();
      if (mounted) {
        setState(() {
          isPlaying = false;
          currentPosition = Duration.zero;
        });
      }
    } catch (e) {
      debugPrint('❌ خطأ في إعادة التعيين: $e');
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _togglePlay,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: hasError
                    ? Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      )
                    : isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.themeColor,
                              ),
                            ),
                          )
                        : Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: widget.themeColor,
                            size: 28,
                          ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isInitialized && !hasError)
                    AudioFileWaveforms(
                      size: const Size(double.infinity, 30),
                      playerController: _waveController,
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: widget.themeColor.withOpacity(0.3),
                        liveWaveColor: widget.themeColor,
                        waveThickness: 3,
                        spacing: 4,
                        waveCap: StrokeCap.round,
                      ),
                    )
                  else if (hasError)
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
"Download error",                        style: TextStyle(
                          fontSize: 12,
                          color: widget.themeColor,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 30,
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: widget.themeColor.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.themeColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDuration(currentPosition),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.time,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(width: 4),
              if (widget.isSender)
                Icon(
                  widget.isRead ? Icons.done_all : Icons.done,
                  size: 15,
                  color: widget.isRead ? Colors.blue : Colors.grey,
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
