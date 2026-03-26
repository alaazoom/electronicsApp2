import 'package:equatable/equatable.dart';

class LanguageState extends Equatable {
  final String selectedLanguage; // 'system', 'ar', 'en'

  const LanguageState({this.selectedLanguage = 'system'});

  LanguageState copyWith({String? selectedLanguage}) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [selectedLanguage];
}
