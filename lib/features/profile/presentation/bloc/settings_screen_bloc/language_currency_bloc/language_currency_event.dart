import 'package:equatable/equatable.dart';

abstract class LanguageCurrencyEvent extends Equatable {
  const LanguageCurrencyEvent();

  @override
  List<Object?> get props => [];
}

class UpdateLanguage extends LanguageCurrencyEvent {
  final String language;
  const UpdateLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class UpdateCurrency extends LanguageCurrencyEvent {
  final String currency;
  const UpdateCurrency(this.currency);

  @override
  List<Object?> get props => [currency];
}
