import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<SelectLanguage>((event, emit) {
      emit(state.copyWith(selectedLanguage: event.languageCode));
    });
  }
}
