import 'package:second_hand_electronics_marketplace/core/constants/app_strings.dart';

import '../../data/enums/id_type.dart';

enum VerificationStep { selectType, frontId, backId, selfie, success }

class VerificationStepContent {
  final String title;
  final String subtitle;
  final List<String> guidelines;
  final String cameraTitle;
  final String cameraDesc;
  final String previewTitle;
  final String previewSubtitle;

  const VerificationStepContent({
    required this.title,
    required this.subtitle,
    required this.guidelines,
    this.cameraTitle = "",
    this.cameraDesc = "",
    this.previewTitle = "",
    this.previewSubtitle = "",
  });
}

extension VerificationStepExtension on VerificationStep {
  VerificationStepContent getContent(IdType type) {
    String docName = type.label;

    switch (this) {
      case VerificationStep.frontId:
        return VerificationStepContent(
          title: AppStrings.captureFront + docName,
          subtitle:
              type == IdType.passport
                  ? AppStrings.openPassPhoto
                  : AppStrings.followGuidelines,
          guidelines: [
            AppStrings.placeThe + docName + AppStrings.insideFrame,
            AppStrings.avoidGlare,
            AppStrings.makeDetailsRead,
          ],
          cameraTitle: AppStrings.captureFront + docName,
          cameraDesc:
              AppStrings.placeThe +
              docName +
              AppStrings.insideTheFrameImageClear,
          previewTitle: AppStrings.checkFront + docName,
          previewSubtitle: AppStrings.makeDetailsRead,
        );

      case VerificationStep.backId:
        return VerificationStepContent(
          title: AppStrings.captureBack + docName,
          subtitle: AppStrings.followGuidelines,
          guidelines: [
            AppStrings.flipBack + docName + AppStrings.toTheBack,
            AppStrings.avoidGlare,
            AppStrings.makeSureImageClear,
          ],
          cameraTitle: AppStrings.captureBack + docName,
          cameraDesc: AppStrings.placeThe + docName + AppStrings.insideFrame,
          previewTitle: AppStrings.checkBack + docName,
          previewSubtitle: AppStrings.makeDetailsRead,
        );

      case VerificationStep.selfie:
        return VerificationStepContent(
          title: AppStrings.takeSelfie + docName,
          subtitle: AppStrings.followGuidelines,
          guidelines: [
            AppStrings.holdYour + docName + AppStrings.nearYourFace,
            AppStrings.ensureLightning,
            AppStrings.lookStraight,
          ],
        );

      default:
        return const VerificationStepContent(
          title: "",
          subtitle: "",
          guidelines: [],
        );
    }
  }
}
