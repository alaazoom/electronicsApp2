import 'package:dio/dio.dart';
import 'package:second_hand_electronics_marketplace/core/constants/api_constants.dart';
import 'package:second_hand_electronics_marketplace/features/categories/data/models/category_model.dart';

class CategoryService {
  final Dio dio;

  CategoryService({required this.dio});

  Future<CategoryResponseModel> getCategories({
    bool? isActive,
    int? page,
    int? limit,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (isActive != null) queryParameters['isActive'] = isActive;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final Response response = await dio.get(
        ApiEndpoints.categories,
        queryParameters: queryParameters,
      );

      // We expect the JSON body wrapped inside response.data per Dio architecture
      return CategoryResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load categories',
        );
      } else {
        throw Exception(e.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
