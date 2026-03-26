import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/settings_screen_bloc/language_screen_bloc/language_bloc.dart';
import '../../../bloc/settings_screen_bloc/language_screen_bloc/language_event.dart';
import '../../../bloc/settings_screen_bloc/language_screen_bloc/language_state.dart';
import '../../../widgets/settings_widgets/language_currency_base_selection.dart';
import '../../../widgets/settings_widgets/language_currency_section_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageBloc(),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          final bloc = context.read<LanguageBloc>();
          return LanguageCurrencyBaseSelectionWidget(
            title: 'App language',
            subtitle: 'Select your app language',
            children: [
              _languageTile(
                context,
                'Follow system language',
                'system',
                bloc,
                state.selectedLanguage,
              ),
              _languageTile(
                context,
                'Arabic',
                'ar',
                bloc,
                state.selectedLanguage,
              ),
              _languageTile(
                context,
                'English',
                'en',
                bloc,
                state.selectedLanguage,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _languageTile(
    BuildContext context,
    String title,
    String value,
    LanguageBloc bloc,
    String selectedLanguage,
  ) {
    return LanguageCurrencySelectionTile(
      title: title,
      selected: selectedLanguage == value,
      onTap: () {
        bloc.add(SelectLanguage(value));
        Future.delayed(const Duration(milliseconds: 600), () {
          context.pop(value);
        });
      },
    );
  }
}
