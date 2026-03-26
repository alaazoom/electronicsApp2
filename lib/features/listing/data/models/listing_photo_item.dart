import 'package:equatable/equatable.dart';

enum ListingPhotoStatus { ready, uploading, error, tooLarge }

class ListingPhotoItem extends Equatable {
  final String id;
  final String path;
  final bool isMain;
  final ListingPhotoStatus status;
  final double progress;
  final int? sizeBytes;

  const ListingPhotoItem({
    required this.id,
    required this.path,
    this.isMain = false,
    this.status = ListingPhotoStatus.ready,
    this.progress = 1.0,
    this.sizeBytes,
  });

  ListingPhotoItem copyWith({
    String? id,
    String? path,
    bool? isMain,
    ListingPhotoStatus? status,
    double? progress,
    int? sizeBytes,
  }) {
    return ListingPhotoItem(
      id: id ?? this.id,
      path: path ?? this.path,
      isMain: isMain ?? this.isMain,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'isMain': isMain,
      'status': status.name,
      'progress': progress,
      'sizeBytes': sizeBytes,
    };
  }

  factory ListingPhotoItem.fromMap(Map<String, dynamic> map) {
    final statusName = map['status'] as String?;
    final ListingPhotoStatus parsedStatus = ListingPhotoStatus.values
        .firstWhere(
          (s) => s.name == statusName,
          orElse: () => ListingPhotoStatus.ready,
        );

    return ListingPhotoItem(
      id: map['id'] as String? ?? '',
      path: map['path'] as String? ?? '',
      isMain: map['isMain'] as bool? ?? false,
      status: parsedStatus,
      progress: (map['progress'] as num?)?.toDouble() ?? 1.0,
      sizeBytes: map['sizeBytes'] as int?,
    );
  }

  @override
  List<Object?> get props => [id, path, isMain, status, progress, sizeBytes];
}
