import 'package:second_hand_electronics_marketplace/core/constants/api_constants.dart';

class CategoryIconModel {
  final String id;
  final String url;
  final String type;
  final String fileName;

  CategoryIconModel({
    required this.id,
    required this.url,
    required this.type,
    required this.fileName,
  });

  factory CategoryIconModel.fromJson(Map<String, dynamic> json) {
    return CategoryIconModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      url: json[ApiKeys.url]?.toString() ?? '',
      type: json[ApiKeys.type]?.toString() ?? '',
      fileName: json[ApiKeys.fileName]?.toString() ?? '',
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final bool isActive;
  final CategoryIconModel? icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      name: json[ApiKeys.name]?.toString() ?? '',
      isActive: json[ApiKeys.isActive] ?? false,
      icon:
          json[ApiKeys.icon] != null
              ? CategoryIconModel.fromJson(json[ApiKeys.icon])
              : null,
    );
  }
}

class CategoryMetaModel {
  final int total;
  final int page;
  final int lastPage;

  CategoryMetaModel({
    required this.total,
    required this.page,
    required this.lastPage,
  });

  factory CategoryMetaModel.fromJson(Map<String, dynamic> json) {
    return CategoryMetaModel(
      total: json[ApiKeys.total] ?? 0,
      page: json[ApiKeys.page] ?? 1,
      lastPage: json[ApiKeys.lastPage] ?? 1,
    );
  }
}

class CategoryResponseModel {
  final List<CategoryModel> data;
  final CategoryMetaModel? meta;

  CategoryResponseModel({required this.data, this.meta});

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return CategoryResponseModel(data: []);

    final Map<String, dynamic>? dataObj =
        json[ApiKeys.data] as Map<String, dynamic>?;
    if (dataObj == null) {
      return CategoryResponseModel(data: []);
    }

    final List<dynamic>? listData = dataObj[ApiKeys.data] as List<dynamic>?;
    final List<CategoryModel> parsedList =
        listData != null
            ? listData
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [];

    final Map<String, dynamic>? metaObj =
        dataObj[ApiKeys.meta] as Map<String, dynamic>?;
    final CategoryMetaModel? parsedMeta =
        metaObj != null ? CategoryMetaModel.fromJson(metaObj) : null;

    return CategoryResponseModel(data: parsedList, meta: parsedMeta);
  }
}
