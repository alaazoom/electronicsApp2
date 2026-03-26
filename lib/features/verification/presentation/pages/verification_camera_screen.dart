import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/features/verification/presentation/widgets/camera_overlay_painter.dart';

import '../../../../core/constants/app_sizes.dart';

class VerificationCameraScreen extends StatefulWidget {
  final String title;
  final String description;
  final CameraLensDirection cameraLensDirection;
  const VerificationCameraScreen({
    super.key,
    required this.title,
    required this.description,
    this.cameraLensDirection = CameraLensDirection.back,
  });

  @override
  State<VerificationCameraScreen> createState() =>
      _VerificationCameraScreenState();
}

class _VerificationCameraScreenState extends State<VerificationCameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == widget.cameraLensDirection,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture ||
        _controller == null ||
        !_controller!.value.isInitialized)
      return;

    try {
      setState(() => _isTakingPicture = true);

      final image = await _controller!.takePicture();

      if (mounted) {
        Navigator.pop(context, image.path);
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) setState(() => _isTakingPicture = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),

                CustomPaint(painter: CameraOverlayPainter()),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingL),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.title,
                            style: AppTypography.body16Medium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.description,
                            style: AppTypography.body14Regular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const Spacer(),

                        if (_isTakingPicture)
                          CircularProgressIndicator(color: Colors.white)
                        else
                          GestureDetector(
                            onTap: _takePicture,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
