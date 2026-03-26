import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_popup.dart';
import '../../../../../../core/constants/constants_exports.dart';
import '../../../../../../core/widgets/widgets_exports.dart';
import '../../../../profile_exports.dart';
import '../../../widgets/profile_widgets_exports.dart';

class SendReportScreen extends StatelessWidget {
  SendReportScreen({super.key});

  final TextEditingController _textController = TextEditingController();

  static const _warningIcon = AppAssets.popupWarning;
  static const _successIcon = AppAssets.popupDone;

  final List<String> _reasons = const [
    "Scam or fraudulent behavior",
    "Harassment or abusive behavior",
    "Suspicious activity",
    "Spam or fake account",
    "Impersonation",
    "Other reason",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportBloc(),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show(status: 'Waiting...');
            return;
          }
          EasyLoading.dismiss();
          switch (state.status) {
            case ReportStatus.noReasonSelected:
              ShowStatusPopup(
                context: context,
                icon: _warningIcon,
                title: 'No reason selected',
                description: 'Please select a reason before submitting.',
                primaryText: 'OK',
                primaryColor: Theme.of(context).colorScheme.error,
              );
              break;
            case ReportStatus.missingDescription:
              ShowStatusPopup(
                context: context,
                icon: _warningIcon,
                title: 'Missing description',
                description: 'Please describe the issue in the text field.',
                primaryText: 'OK',
                primaryColor: Theme.of(context).colorScheme.error,
              );
              break;
            case ReportStatus.success:
              ShowStatusPopup(
                context: context,
                icon: _successIcon,
                title: 'Report Submitted',
                description:
                    'Thanks for helping keep our community safe.\nWe’ll review this report shortly.',
                primaryText: 'Back',
              );
              break;
            case ReportStatus.failure:
              ShowStatusPopup(
                context: context,
                icon: _warningIcon,
                title: 'Something went wrong',
                description:
                    'We couldn’t submit your report.\nPlease try again.',
                primaryText: 'Try again',
                secondaryText: 'Cancel',
                onPrimary: () {
                  context.read<ReportBloc>().add(
                    SubmitReport(
                      description: _textController.text,
                      reasonsLength: _reasons.length,
                    ),
                  );
                },
                primaryColor: Theme.of(context).colorScheme.error,
              );
              break;

            default:
              break;
          }
        },
        child: ReportScreenBodyScaffold(
          reasons: _reasons,
          textController: _textController,
        ),
      ),
    );
  }
}

void ShowStatusPopup({
  required BuildContext context,
  required String icon,
  required String title,
  required String description,
  required String primaryText,
  VoidCallback? onPrimary,
  String? secondaryText,
  VoidCallback? onSecondary,
  Color? primaryColor,
}) {
  CustomPopup.show(
    context,
    body: StatusFeedbackWidget(
      iconPath: icon,
      title: title,
      description: description,
    ),
    primaryButtonText: primaryText,
    secondaryButtonText: secondaryText,
    onSecondaryButtonPressed: onSecondary,
    primaryButtonColor: primaryColor,
    onPrimaryButtonPressed:
        onPrimary ?? () => Navigator.of(context, rootNavigator: true).pop(),
  );
}
