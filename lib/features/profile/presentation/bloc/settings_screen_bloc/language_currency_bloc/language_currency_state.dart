import 'package:equatable/equatable.dart';

class LanguageCurrencyState extends Equatable {
  final String language;
  final String currency;

  const LanguageCurrencyState({
    this.language = 'system',
    this.currency = 'ILS',
  });

  LanguageCurrencyState copyWith({String? language, String? currency}) {
    return LanguageCurrencyState(
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [language, currency];
}
