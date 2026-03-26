import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();
  @override
  List<Object?> get props => [];
}

class SelectCurrency extends CurrencyEvent {
  final String currencyCode;
  const SelectCurrency(this.currencyCode);

  @override
  List<Object?> get props => [currencyCode];
}
