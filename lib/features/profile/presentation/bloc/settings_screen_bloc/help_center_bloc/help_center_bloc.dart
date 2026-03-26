import 'package:flutter_bloc/flutter_bloc.dart';
import 'help_center_event.dart';
import 'help_center_state.dart';

class HelpCenterBloc extends Bloc<HelpCenterEvent, HelpCenterState> {
  HelpCenterBloc() : super(const HelpCenterState()) {
    on<LoadHelpCenter>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(milliseconds: 300));

      emit(state.copyWith(isLoading: false));
    });

    on<TapContactItem>((event, emit) {});
  }
}
