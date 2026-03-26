import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_currency_event.dart';
import 'language_currency_state.dart';

class LanguageCurrencyBloc
    extends Bloc<LanguageCurrencyEvent, LanguageCurrencyState> {
  LanguageCurrencyBloc() : super(const LanguageCurrencyState()) {
    on<UpdateLanguage>((event, emit) {
      emit(state.copyWith(language: event.language));
    });

    on<UpdateCurrency>((event, emit) {
      emit(state.copyWith(currency: event.currency));
    });
  }
}
