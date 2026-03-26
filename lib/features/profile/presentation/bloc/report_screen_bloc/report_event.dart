part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class ReasonSelected extends ReportEvent {
  final int index;

  const ReasonSelected(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitReport extends ReportEvent {
  final String description;
  final int reasonsLength;

  const SubmitReport({required this.description, required this.reasonsLength});

  @override
  List<Object?> get props => [description, reasonsLength];
}
