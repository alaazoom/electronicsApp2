import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/settings_screen_bloc/currency_screen_bloc/currency_bloc.dart';
import '../../../bloc/settings_screen_bloc/currency_screen_bloc/currency_event.dart';
import '../../../bloc/settings_screen_bloc/currency_screen_bloc/currency_state.dart';
import '../../../widgets/settings_widgets/language_currency_base_selection.dart';
import '../../../widgets/settings_widgets/language_currency_section_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrencyBloc(),
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          final bloc = context.read<CurrencyBloc>();
          return LanguageCurrencyBaseSelectionWidget(
            title: 'Currency display',
            subtitle: 'Select your currency',
            children: [
              _currencyTile(context, 'ILS', bloc, state.selectedCurrency),
              _currencyTile(context, 'USD', bloc, state.selectedCurrency),
              _currencyTile(context, 'JOD', bloc, state.selectedCurrency),
            ],
          );
        },
      ),
    );
  }

  Widget _currencyTile(
    BuildContext context,
    String value,
    CurrencyBloc bloc,
    String selectedCurrency,
  ) {
    return LanguageCurrencySelectionTile(
      title: value,
      selected: selectedCurrency == value,
      onTap: () {
        bloc.add(SelectCurrency(value));
        Future.delayed(const Duration(milliseconds: 600), () {
          context.pop(value);
        });
      },
    );
  }
}
