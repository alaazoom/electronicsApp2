import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_media_service.dart';

import 'add_listing_media_state.dart';

class AddListingMediaCubit extends Cubit<AddListingMediaState> {
  AddListingMediaCubit({ListingMediaService? mediaService})
    : _mediaService = mediaService ?? ListingMediaService(),
      super(const AddListingMediaState());

  final ListingMediaService _mediaService;

  void setPhotos(List<ListingPhotoItem> photos) {
    if (_samePhotos(state.photos, photos)) return;
    emit(state.copyWith(photos: List.of(photos)));
  }

  Future<void> addPhotoFromCamera() async {
    if (state.photos.length >= 6) return;
    final result = await _mediaService.pickFromCamera();
    if (result == null) return;
    await _handlePickedPhoto(result);
  }

  Future<void> addPhotoFromGallery() async {
    if (state.photos.length >= 6) return;
    final result = await _mediaService.pickFromGallery();
    if (result == null) return;
    await _handlePickedPhoto(result);
  }

  void removePhoto(String id) {
    final updated = List<ListingPhotoItem>.from(state.photos)
      ..removeWhere((p) => p.id == id);

    if (updated.isNotEmpty && !updated.any((p) => p.isMain)) {
      updated[0] = updated[0].copyWith(isMain: true);
    }

    emit(state.copyWith(photos: updated));
  }

  void setMainPhoto(String id) {
    final updated =
        state.photos.map((p) => p.copyWith(isMain: p.id == id)).toList();
    emit(state.copyWith(photos: updated));
  }

  Future<void> _handlePickedPhoto(PhotoPickResult result) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final tooLarge = _mediaService.isTooLarge(result.sizeBytes);
    final photo = ListingPhotoItem(
      id: id,
      path: result.path,
      status:
          tooLarge ? ListingPhotoStatus.tooLarge : ListingPhotoStatus.uploading,
      progress: tooLarge ? 0.0 : 0.4,
      sizeBytes: result.sizeBytes,
    );

    List<ListingPhotoItem> updated = List.of(state.photos)..add(photo);
    if (updated.length == 1) {
      updated =
          updated
              .map((p) => p.id == id ? p.copyWith(isMain: true) : p)
              .toList();
    }
    emit(state.copyWith(photos: updated));

    if (!tooLarge) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (isClosed) return;
      _updatePhoto(
        id,
        (p) => p.copyWith(status: ListingPhotoStatus.ready, progress: 1.0),
      );
    }
  }

  void _updatePhoto(
    String id,
    ListingPhotoItem Function(ListingPhotoItem) update,
  ) {
    final updated =
        state.photos.map((p) => p.id == id ? update(p) : p).toList();
    emit(state.copyWith(photos: updated));
  }

  bool _samePhotos(List<ListingPhotoItem> a, List<ListingPhotoItem> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
