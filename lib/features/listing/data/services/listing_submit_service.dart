import 'dart:io';

import 'package:dio/dio.dart';
import 'package:second_hand_electronics_marketplace/core/constants/api_constants.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/add_listing_draft.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';

enum ListingSubmitResultType {
  success,
  offline,
  unauthorized,
  validation,
  uploadError,
  failure,
}

class ListingSubmitResult {
  const ListingSubmitResult({required this.type, this.message});

  final ListingSubmitResultType type;
  final String? message;
}

class ListingSubmitService {
  ListingSubmitService([Dio? dio])
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

  Future<ListingSubmitResult> submitListing(AddListingDraft draft) async {
    final parsedPrice = _parsePrice(draft.price);
    if (parsedPrice == null) {
      return const ListingSubmitResult(
        type: ListingSubmitResultType.validation,
        message: 'Please enter a valid price.',
      );
    }

    final condition = _normalizeCondition(draft.condition);
    if (condition.isEmpty) {
      return const ListingSubmitResult(
        type: ListingSubmitResultType.validation,
        message: 'Please select a valid condition.',
      );
    }

    final readyPhotos =
        draft.photos
            .where((p) => p.status == ListingPhotoStatus.ready)
            .toList();
    final imageFiles = await _buildImageFiles(readyPhotos);
    if (imageFiles.isEmpty) {
      return const ListingSubmitResult(
        type: ListingSubmitResultType.validation,
        message: 'At least one image is required for a product listing.',
      );
    }

    final payload = <String, dynamic>{
      ApiKeys.title: draft.title.trim(),
      ApiKeys.categoryId: draft.categoryId,
      ApiKeys.condition: condition,
      ApiKeys.price: parsedPrice,
      ApiKeys.isNegotiable: draft.negotiable,
      ApiKeys.images: imageFiles,
    };

    int attributeIndex = 0;
    draft.attributes.forEach((attributeId, value) {
      final normalizedValue = value.trim();
      if (attributeId.trim().isEmpty || normalizedValue.isEmpty) return;
      payload['${ApiKeys.attributes}[$attributeIndex][${ApiKeys.attributeId}]'] =
          attributeId;
      payload['${ApiKeys.attributes}[$attributeIndex][${ApiKeys.value}]'] =
          normalizedValue;
      attributeIndex++;
    });

    try {
      final response = await _dio.post(
        ApiEndpoints.createPendingProduct,
        data: FormData.fromMap(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const ListingSubmitResult(type: ListingSubmitResultType.success);
      }

      return ListingSubmitResult(
        type: ListingSubmitResultType.failure,
        message:
            _extractErrorMessage(response.data) ?? 'Failed to submit listing.',
      );
    } on DioException catch (e) {
      if (_isOfflineError(e)) {
        return const ListingSubmitResult(type: ListingSubmitResultType.offline);
      }

      final statusCode = e.response?.statusCode ?? 0;
      final message = _extractErrorMessage(e.response?.data);

      if (statusCode == 401 || statusCode == 403) {
        return ListingSubmitResult(
          type: ListingSubmitResultType.unauthorized,
          message: message ?? 'You are not allowed to perform this action.',
        );
      }

      if (statusCode == 400) {
        return ListingSubmitResult(
          type: ListingSubmitResultType.validation,
          message:
              message ?? 'Please review your listing details and try again.',
        );
      }

      if (statusCode == 502) {
        return ListingSubmitResult(
          type: ListingSubmitResultType.uploadError,
          message: message ?? 'Image upload failed. Please try again later.',
        );
      }

      return ListingSubmitResult(
        type: ListingSubmitResultType.failure,
        message: message ?? 'Failed to submit listing. Please try again.',
      );
    } catch (_) {
      return const ListingSubmitResult(
        type: ListingSubmitResultType.failure,
        message: 'Failed to submit listing. Please try again.',
      );
    }
  }

  Future<List<MultipartFile>> _buildImageFiles(
    List<ListingPhotoItem> photos,
  ) async {
    final files = <MultipartFile>[];
    for (final photo in photos) {
      final file = File(photo.path);
      if (!await file.exists()) continue;
      files.add(
        await MultipartFile.fromFile(
          photo.path,
          filename:
              file.uri.pathSegments.isEmpty ? null : file.uri.pathSegments.last,
        ),
      );
    }
    return files;
  }

  double? _parsePrice(String rawPrice) {
    final normalized = rawPrice.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  String _normalizeCondition(String input) {
    final normalized = input.trim().toLowerCase().replaceAll(' ', '_');
    switch (normalized) {
      case 'new':
      case 'like_new':
      case 'good':
      case 'fair':
      case 'poor':
        return normalized;
      default:
        return '';
    }
  }

  bool _isOfflineError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data[ApiKeys.message];
      if (message is String && message.trim().isNotEmpty) return message;
      if (message is List && message.isNotEmpty) {
        return message.map((e) => e.toString()).join(', ');
      }

      final fields = data['fields'];
      if (fields is List && fields.isNotEmpty) {
        final firstField = fields.first;
        if (firstField is Map<String, dynamic>) {
          final fieldMessage = firstField[ApiKeys.message];
          if (fieldMessage is String && fieldMessage.trim().isNotEmpty) {
            return fieldMessage;
          }
        }
      }
    }

    return null;
  }
}
