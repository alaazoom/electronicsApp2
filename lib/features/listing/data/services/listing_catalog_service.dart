import 'package:dio/dio.dart';
import 'package:second_hand_electronics_marketplace/core/constants/api_constants.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_field_config.dart';

class ListingCatalogService {
  ListingCatalogService([Dio? dio])
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiEndpoints.baseUrl,
              receiveDataWhenStatusError: true,
              connectTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;
  List<ListingCategoryConfig>? _categoriesCache;

  Future<List<ListingCategoryConfig>> getCategories({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _categoriesCache != null) {
      return _categoriesCache!;
    }

    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final rawCategories = _extractCategoryList(response.data);
      final activeCategories =
          rawCategories
              .where((category) => _isCategoryActive(category))
              .toList();

      final categories = await Future.wait(
        activeCategories.map(_buildCategoryConfig),
      );

      _categoriesCache = categories;
      return categories;
    } on DioException catch (e) {
      final message =
          (e.response?.data is Map<String, dynamic>)
              ? (e.response?.data[ApiKeys.message]?.toString() ??
                  'Failed to load categories')
              : 'Failed to load categories';
      throw Exception(message);
    } catch (_) {
      throw Exception('Failed to load categories');
    }
  }

  ListingCategoryConfig? getCategoryConfig(
    String categoryId,
    List<ListingCategoryConfig> categories,
  ) {
    if (categoryId.trim().isEmpty) return null;
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  List<Map<String, dynamic>> _extractCategoryList(dynamic payload) {
    if (payload is! Map<String, dynamic>) return const [];
    final data = payload[ApiKeys.data];

    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (data is Map<String, dynamic>) {
      final nested = data[ApiKeys.data];
      if (nested is List) {
        return nested
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    return const [];
  }

  bool _isCategoryActive(Map<String, dynamic> category) {
    final value = category['isActive'];
    if (value is bool) return value;
    return true;
  }

  Future<ListingCategoryConfig> _buildCategoryConfig(
    Map<String, dynamic> category,
  ) async {
    final id = category[ApiKeys.id]?.toString() ?? '';
    final name = category['name']?.toString() ?? '';
    final icon = _resolveCategoryIcon(name);

    if (id.isEmpty) {
      return ListingCategoryConfig(
        id: id,
        name: name,
        icon: icon,
        fields: const [],
      );
    }

    try {
      final detailsResponse = await _dio.get(ApiEndpoints.categoryById(id));
      final detailsPayload = detailsResponse.data;
      final details =
          detailsPayload is Map<String, dynamic>
              ? (detailsPayload[ApiKeys.data] is Map
                  ? Map<String, dynamic>.from(
                    detailsPayload[ApiKeys.data] as Map,
                  )
                  : null)
              : null;

      final attributes =
          details?['attributes'] is List
              ? details!['attributes'] as List<dynamic>
              : const <dynamic>[];

      final fields = _mapAttributes(attributes);
      return ListingCategoryConfig(
        id: id,
        name: name,
        icon: icon,
        fields: fields,
      );
    } catch (_) {
      return ListingCategoryConfig(
        id: id,
        name: name,
        icon: icon,
        fields: const [],
      );
    }
  }

  List<ListingFieldConfig> _mapAttributes(List<dynamic> attributes) {
    return attributes.whereType<Map>().map((raw) {
      final attribute = Map<String, dynamic>.from(raw);
      final attributeId = attribute[ApiKeys.id]?.toString() ?? '';
      final attributeName = attribute['name']?.toString() ?? '';
      final rawType = attribute[ApiKeys.type]?.toString() ?? 'text';
      final body =
          attribute['body'] is Map
              ? Map<String, dynamic>.from(attribute['body'] as Map)
              : <String, dynamic>{};

      return ListingFieldConfig(
        key: attributeId,
        attributeId: attributeId,
        label: attributeName,
        required: attribute['isRequired'] == true,
        type: _mapFieldType(rawType),
        options: _mapOptions(rawType, body),
        hint: _mapHint(rawType, body),
        legacyKey: _legacyKey(attributeName),
      );
    }).toList();
  }

  ListingFieldType _mapFieldType(String rawType) {
    switch (rawType) {
      case 'number':
        return ListingFieldType.number;
      case 'select':
      case 'toggle':
      case 'checkboxes':
        return ListingFieldType.selection;
      default:
        return ListingFieldType.text;
    }
  }

  List<String> _mapOptions(String rawType, Map<String, dynamic> body) {
    if (rawType == 'select') {
      final options = body['options'];
      if (options is List) {
        return options.map((e) => e.toString()).toList();
      }
    }

    if (rawType == 'toggle') {
      return const ['true', 'false'];
    }

    if (rawType == 'checkboxes') {
      final values = body['checkboxes'];
      if (values is List) {
        final result = <String>[];
        for (final item in values.whereType<Map>()) {
          result.addAll(item.keys.map((k) => k.toString()));
        }
        return result;
      }
    }

    return const [];
  }

  String _mapHint(String rawType, Map<String, dynamic> body) {
    final directHint = body['text']?.toString();
    if (directHint != null && directHint.trim().isNotEmpty) return directHint;

    if (rawType == 'textarea') {
      final textareaHint = body['textarea']?.toString();
      if (textareaHint != null && textareaHint.trim().isNotEmpty) {
        return textareaHint;
      }
    }

    if (rawType == 'datepicker') {
      return 'Select date';
    }

    return '';
  }

  String _legacyKey(String name) {
    return name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  String _resolveCategoryIcon(String name) {
    final normalized = name.trim().toLowerCase();
    if (normalized.contains('phone')) return AppAssets.smartPhoneCatIcon;
    if (normalized.contains('tablet')) return AppAssets.tabletCatIcon;
    if (normalized.contains('laptop')) return AppAssets.laptopCatIcon;
    if (normalized.contains('gaming')) return AppAssets.gameCatIcon;
    if (normalized.contains('camera')) return AppAssets.cameraCatIcon;
    if (normalized.contains('audio')) return AppAssets.headphoneCatIcon;
    if (normalized.contains('watch')) return AppAssets.smartWatchCatIcon;
    if (normalized.contains('network')) return AppAssets.routerCatIcon;
    if (normalized.contains('tv') || normalized.contains('monitor')) {
      return AppAssets.tvCatIcon;
    }
    if (normalized.contains('home')) return AppAssets.plugCatIcon;
    return AppAssets.aiChipCatIcon;
  }

  List<String> getCountryOptions() {
    return const ['Palestine', 'Jordan', 'Egypt', 'Lebanon', 'Saudi Arabia'];
  }

  List<String> getCityOptions(String country) {
    final c = country.toLowerCase();
    if (c.contains('palestine')) {
      return const ['Gaza', 'Ramallah', 'Hebron', 'Nablus'];
    }
    if (c.contains('jordan')) {
      return const ['Amman', 'Irbid', 'Zarqa'];
    }
    if (c.contains('egypt')) {
      return const ['Cairo', 'Alexandria', 'Giza'];
    }
    if (c.contains('lebanon')) {
      return const ['Beirut', 'Tripoli', 'Sidon'];
    }
    return const ['City 1', 'City 2', 'City 3'];
  }
}
