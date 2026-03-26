import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:second_hand_electronics_marketplace/core/constants/api_constants.dart';

import '../models/product_model.dart';

class ProductsRepository {
  final Dio dio;

  ProductsRepository({required this.dio});

  Future<List<ProductModel>> getAllProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    log(
      'Fetching products with categoryId: $categoryId, sortBy: $sortBy, sortOrder: $sortOrder',
    );
    try {
      // تمرير الـ Parameters اللي شفناها في الـ Swagger
      final response = await dio.get(
        '/products',
        options: Options(extra: {'noToken': true}),
        queryParameters: {
          'page': page,
          'limit': limit,
          if (categoryId != null) 'categoryIds': [categoryId],
          if (sortBy != null) 'sortBy': sortBy,
          if (sortOrder != null) 'sortOrder': sortOrder,
        },
      );

      // الفحص والتأكد من نجاح الطلب
      if (response.data['success'] == true) {
        // لاحظي المسار: response -> data الأولى -> data الثانية (المصفوفة)
        List<dynamic> productsList = response.data['data']['data'];

        return productsList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'حدث خطأ غير معروف');
      }
    } catch (e) {
      // التعامل مع أخطاء Dio
      if (e is DioException) {
        throw Exception(
          e.response?.data['message'] ?? 'خطأ في الاتصال بالخادم',
        );
      }
      throw Exception(e.toString());
    }
  }

  Future<List<ProductModel>> getMyProducts({
    int page = 1,
    int limit = 10,
    List<String>? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    log('Fetching my products with status: $status');
    try {
      final response = await dio.get(
        ApiEndpoints.getMyProducts,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null && status.isNotEmpty) 'status': status,
          if (sortBy != null) 'sortBy': sortBy,
          if (sortOrder != null) 'sortOrder': sortOrder,
        },
      );

      if (response.data['success'] == true) {
        // The structure for my products seems to be response -> data -> data (list)
        List<dynamic> productsList = response.data['data']['data'];
        return productsList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch my products',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Network error');
      }
      rethrow;
    }
  }
}
