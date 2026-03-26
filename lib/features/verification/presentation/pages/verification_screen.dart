import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/widgets_exports.dart';
import 'package:second_hand_electronics_marketplace/features/verification/data/models/verification_content.dart';
import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../../../../core/widgets/progress_indicator.dart';
import '../../data/enums/id_type.dart';
import '../../data/models/verification_form_data.dart';
import '../../services/verification_service.dart';
import '../widgets/steps/verification_success_step.dart';
import '../widgets/steps/verification_type_selection_step.dart';
import '../widgets/verification_instruction_view.dart';
import 'verification_camera_screen.dart';
import 'verification_preview_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final VerificationService _verificationService = VerificationService();
  final VerificationFormData _formData = VerificationFormData();

  VerificationStep currentStep = VerificationStep.selectType;

  int get totalSteps {
    return _formData.idType == IdType.passport ? 3 : 4;
  }

  int get currentStepNumber {
    switch (currentStep) {
      case VerificationStep.selectType:
        return 1;
      case VerificationStep.frontId:
        return 2;
      case VerificationStep.backId:
        return 3;
      case VerificationStep.selfie:
        return _formData.idType == IdType.passport ? 3 : 4;
      case VerificationStep.success:
        return totalSteps;
    }
  }

  double get progressValue {
    return currentStepNumber / totalSteps;
  }

  void nextStep() {
    setState(() {
      switch (currentStep) {
        case VerificationStep.selectType:
          currentStep = VerificationStep.frontId;
          break;

        case VerificationStep.frontId:
          if (_formData.idType == IdType.passport) {
            currentStep = VerificationStep.selfie;
          } else {
            currentStep = VerificationStep.backId;
          }
          break;

        case VerificationStep.backId:
          currentStep = VerificationStep.selfie;
          break;

        case VerificationStep.selfie:
          currentStep = VerificationStep.success;
          break;

        case VerificationStep.success:
          context.pop();
          break;
      }
    });
  }

  void prevStep() {
    if (currentStep == VerificationStep.selectType) {
      context.pop();
      return;
    }
    setState(() {
      switch (currentStep) {
        case VerificationStep.frontId:
          currentStep = VerificationStep.selectType;
          break;

        case VerificationStep.backId:
          currentStep = VerificationStep.frontId;
          break;

        case VerificationStep.selfie:
          if (_formData.idType == IdType.passport) {
            currentStep = VerificationStep.frontId;
          } else {
            currentStep = VerificationStep.backId;
          }
          break;

        default:
          break;
      }
    });
  }

  Future<bool> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      _showPermissionDialog();
      return false;
    }
    return status.isGranted;
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(AppStrings.cameraPermTitle),
            content: const Text(AppStrings.cameraPermTitle),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text(AppStrings.openSettings),
              ),
            ],
          ),
    );
  }

  Future<void> _handleIdCardCapture({
    required String cameraTitle,
    required String cameraDescription,
    required String previewTitle,
    required String previewSubtitle,
    required Function(String) onValidated,
  }) async {
    if (!await _checkCameraPermission()) return;
    if (!mounted) return;

    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VerificationCameraScreen(
              title: cameraTitle,
              description: cameraDescription,
            ),
      ),
    );

    if (imagePath != null) {
      if (!mounted) return;
      final isConfirmed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => VerificationPreviewScreen(
                imagePath: imagePath,
                title: previewTitle,
                subtitle: previewSubtitle,
              ),
        ),
      );

      if (isConfirmed == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => const Center(child: CircularProgressIndicator()),
        );

        // 1. Validation
        final isValid = await _verificationService.validateIdCard(imagePath);

        // 2. Compression (if valid)
        String finalPath = imagePath;
        if (isValid) {
          final compressedPath = await _verificationService.compressImage(
            imagePath,
          );
          if (compressedPath != null) finalPath = compressedPath;
        }

        if (!mounted) return;
        Navigator.pop(context); // Hide Loading

        if (isValid) {
          onValidated(finalPath);
        } else {
          NotificationToast.show(
            context,
            AppStrings.pleaseTryAgain,
            AppStrings.pleaseEnsureIdClear,
            ToastType.error,
          );
        }
      }
    }
  }

  Future<void> _handleSelfieCapture({
    required Function(String) onValidated,
  }) async {
    if (!await _checkCameraPermission()) return;
    if (!mounted) return;

    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const VerificationCameraScreen(
              title: "Take a Selfie",
              description: "Hold your ID and look at the camera.",
              cameraLensDirection: CameraLensDirection.front,
            ),
      ),
    );

    if (imagePath != null) {
      if (!mounted) return;
      final isConfirmed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => VerificationPreviewScreen(
                imagePath: imagePath,
                title: "Check your Selfie",
                subtitle: "Is your face and ID clear?",
              ),
        ),
      );

      if (isConfirmed == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => const Center(child: CircularProgressIndicator()),
        );

        // 1. Validation
        final isValid = await _verificationService.validateSelfie(imagePath);

        // 2. Compression (if valid)
        String finalPath = imagePath;
        if (isValid) {
          final compressedPath = await _verificationService.compressImage(
            imagePath,
          );
          if (compressedPath != null) finalPath = compressedPath;
        }

        if (!mounted) return;
        Navigator.pop(context); // Hide Loading

        if (isValid) {
          onValidated(finalPath);
        } else {
          NotificationToast.show(
            context,
            AppStrings.pleaseTryAgain,
            "Face validation failed. Please ensure good lighting and look straight at the camera.",
            ToastType.error,
          );
        }
      }
    }
  }

  Widget _buildCaptureStep(VerificationStep step) {
    final content = step.getContent(_formData.idType ?? IdType.idCard);
    void onImageValidated(String path) {
      setState(() {
        if (step == VerificationStep.frontId) _formData.frontIdPath = path;
        if (step == VerificationStep.backId) _formData.backIdPath = path;
        if (step == VerificationStep.selfie) _formData.selfiePath = path;
      });
      print("✅ ${step.name} Validated & Saved: $path");
      nextStep();
    }

    VoidCallback onTakePictureAction;
    if (step == VerificationStep.selfie) {
      onTakePictureAction =
          () => _handleSelfieCapture(onValidated: onImageValidated);
    } else {
      onTakePictureAction =
          () => _handleIdCardCapture(
            cameraTitle: content.cameraTitle,
            cameraDescription: content.cameraDesc,
            previewTitle: content.previewTitle,
            previewSubtitle: content.previewSubtitle,
            onValidated: onImageValidated,
          );
    }

    return VerificationInstructionView(
      content: content,
      onTakePicture: onTakePictureAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.identityVerification)),
      body: Column(
        children: [
          if (currentStep != VerificationStep.success)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ProgressIndicatorWidget(
                      progressValue: progressValue,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  RichText(
                    text: TextSpan(
                      style: AppTypography.label12Regular,
                      children: [
                        TextSpan(
                          text: "$currentStepNumber",
                          style: TextStyle(color: context.colors.mainColor),
                        ),
                        TextSpan(
                          text: " / $totalSteps",
                          style: TextStyle(color: context.colors.icons),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSizes.paddingL),

          Expanded(child: _buildCurrentStepBody()),
        ],
      ),
    );
  }

  Widget _buildCurrentStepBody() {
    switch (currentStep) {
      case VerificationStep.selectType:
        return VerificationTypeSelectionStep(
          selectedIdType: _formData.idType,
          onTypeSelected: (IdType value) {
            setState(() => _formData.idType = value);
          },
          onContinue: nextStep,
        );

      case VerificationStep.frontId:
      case VerificationStep.backId:
      case VerificationStep.selfie:
        return _buildCaptureStep(currentStep);

      case VerificationStep.success:
        return VerificationSuccessStep();
    }
  }
}
