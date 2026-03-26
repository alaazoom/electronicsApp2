import 'package:dio/dio.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/country_model.dart';

class CountriesService {
  final Dio _dio;
  CountriesService(this._dio);

  Future<List<CountryModel>> getActiveCountries() async {
    try {
      final response = await _dio.get('/countries'); // عدلي الرابط لو بيلزم

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        final allCountries = data.map((e) => CountryModel.fromJson(e)).toList();

        // نرجع بس الدول المفعلة
        return allCountries.where((country) => country.isActive).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load countries');
      }
    } catch (e) {
      rethrow;
    }
  }
}
