import 'package:equatable/equatable.dart';

class CurrencyState extends Equatable {
  final String selectedCurrency; // 'ILS', 'USD', 'JOD'

  const CurrencyState({this.selectedCurrency = 'ILS'});

  CurrencyState copyWith({String? selectedCurrency}) {
    return CurrencyState(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
    );
  }

  @override
  List<Object?> get props => [selectedCurrency];
}
