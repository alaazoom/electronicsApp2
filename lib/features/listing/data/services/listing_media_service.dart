import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoPickResult {
  final String path;
  final int sizeBytes;
  const PhotoPickResult({required this.path, required this.sizeBytes});
}

class ListingMediaService {
  static const int maxSizeBytes = 5 * 1024 * 1024;
  final ImagePicker _picker = ImagePicker();

  Future<PhotoPickResult?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image == null) return null;
    final size = await File(image.path).length();
    return PhotoPickResult(path: image.path, sizeBytes: size);
  }

  Future<PhotoPickResult?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return null;
    final size = await File(image.path).length();
    return PhotoPickResult(path: image.path, sizeBytes: size);
  }

  bool isTooLarge(int sizeBytes) => sizeBytes > maxSizeBytes;
}
