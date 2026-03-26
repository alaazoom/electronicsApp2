import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/repos/countries_service.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/cubits/countries_states.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesService _service;

  CountriesCubit(this._service) : super(CountriesInitial());

  Future<void> fetchCountries() async {
    emit(CountriesLoading());
    try {
      final countries = await _service.getActiveCountries();
      emit(CountriesLoaded(countries));
    } catch (e) {
      emit(CountriesError(e.toString()));
    }
  }
}
