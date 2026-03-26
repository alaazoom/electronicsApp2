import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../configs/theme/theme_exports.dart';
import '../../../../../core/constants/constants_exports.dart';
import '../../../profile_exports.dart';
import '../profile_widgets_exports.dart';

class ReportScreenBodyScaffold extends StatelessWidget {
  const ReportScreenBodyScaffold({
    super.key,
    required List<String> reasons,
    required TextEditingController textController,
  }) : _reasons = reasons,
       _textController = textController;

  final List<String> _reasons;
  final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report User')),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingM,
              0,
              AppSizes.paddingM,
              AppSizes.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.paddingXXS),
                Text(
                  'Help us keep the community safe. Please select the reason that best describes the issue with this user.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSizes.paddingXS),
                ReportReasonSelector(
                  reasons: _reasons,
                  selectedIndex: state.selectedIndex,
                  textController: _textController,
                  onChanged: (value) {
                    context.read<ReportBloc>().add(ReasonSelected(value));
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        state.isLoading
                            ? null
                            : () {
                              context.read<ReportBloc>().add(
                                SubmitReport(
                                  description: _textController.text,
                                  reasonsLength: _reasons.length,
                                ),
                              );
                            },
                    child: const Text("Submit"),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                Center(
                  child: Text(
                    "The reported user will not be notified.",
                    style: AppTypography.label12Regular.copyWith(
                      color: context.colors.titles,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
