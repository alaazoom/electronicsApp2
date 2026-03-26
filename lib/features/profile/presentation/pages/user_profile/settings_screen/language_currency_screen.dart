import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/constants_exports.dart';
import '../../../bloc/settings_screen_bloc/language_currency_bloc/language_currency_bloc.dart';
import '../../../bloc/settings_screen_bloc/language_currency_bloc/language_currency_event.dart';
import '../../../bloc/settings_screen_bloc/language_currency_bloc/language_currency_state.dart';
import '../../../widgets/settings_widgets/language_currency_decorated_tile.dart';

class LanguageCurrencyScreen extends StatelessWidget {
  const LanguageCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageCurrencyBloc(),
      child: BlocBuilder<LanguageCurrencyBloc, LanguageCurrencyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Language & Currency')),
            body: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                children: [
                  LanguageCurrencyDecoratedListTile(
                    title: 'App language',
                    trailingValue: _mapLanguage(state.language),
                    onTap: () async {
                      final result = await context.pushNamed(
                        AppRoutes.language,
                      );

                      if (result != null) {
                        context.read<LanguageCurrencyBloc>().add(
                          UpdateLanguage(result as String),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  LanguageCurrencyDecoratedListTile(
                    title: 'Currency display',
                    trailingValue: state.currency,
                    onTap: () async {
                      final result = await context.pushNamed(
                        AppRoutes.currency,
                      );

                      if (result != null) {
                        context.read<LanguageCurrencyBloc>().add(
                          UpdateCurrency(result as String),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _mapLanguage(String value) {
    switch (value) {
      case 'ar':
        return 'Arabic';
      case 'en':
        return 'English';
      default:
        return 'System';
    }
  }
}
