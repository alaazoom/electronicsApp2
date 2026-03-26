import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'report_event.dart';

part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState(selectedIndex: -1, isLoading: false)) {
    on<ReasonSelected>(_onReasonSelected);
    on<SubmitReport>(_onSubmitReport);
  }

  void _onReasonSelected(ReasonSelected event, Emitter<ReportState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  Future<void> _onSubmitReport(
    SubmitReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 5));

    if (state.selectedIndex == -1) {
      emit(
        state.copyWith(isLoading: false, status: ReportStatus.noReasonSelected),
      );
      return;
    }

    if (state.selectedIndex == event.reasonsLength - 1 &&
        event.description.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          status: ReportStatus.missingDescription,
        ),
      );
      return;
    }

    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(isLoading: false, status: ReportStatus.success));
    } catch (_) {
      emit(state.copyWith(isLoading: false, status: ReportStatus.failure));
    }
  }
}
