part of 'report_bloc.dart';

enum ReportStatus {
  initial,
  noReasonSelected,
  missingDescription,
  success,
  failure,
}

class ReportState extends Equatable {
  final int selectedIndex;
  final bool isLoading;
  final ReportStatus status;

  const ReportState({
    required this.selectedIndex,
    required this.isLoading,
    this.status = ReportStatus.initial,
  });

  ReportState copyWith({
    int? selectedIndex,
    bool? isLoading,
    ReportStatus? status,
  }) {
    return ReportState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? ReportStatus.initial,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, isLoading, status];
}
