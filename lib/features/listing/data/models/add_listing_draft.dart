import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/location_model.dart';
import 'listing_photo_item.dart';

class AddListingDraft extends Equatable {
  final String title;
  final String categoryId;
  final String category;
  final String condition;
  final String price;
  final bool negotiable;
  final List<ListingPhotoItem> photos;
  final Map<String, String> attributes;
  final String description;
  final LocationModel? location;
  final bool confirmNotStolen;

  const AddListingDraft({
    this.title = '',
    this.categoryId = '',
    this.category = '',
    this.condition = '',
    this.price = '',
    this.negotiable = false,
    this.photos = const [],
    this.attributes = const {},
    this.description = '',
    this.location,
    this.confirmNotStolen = false,
  });

  AddListingDraft copyWith({
    String? title,
    String? categoryId,
    String? category,
    String? condition,
    String? price,
    bool? negotiable,
    List<ListingPhotoItem>? photos,
    Map<String, String>? attributes,
    String? description,
    LocationModel? location,
    bool? confirmNotStolen,
  }) {
    return AddListingDraft(
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      price: price ?? this.price,
      negotiable: negotiable ?? this.negotiable,
      photos: photos ?? this.photos,
      attributes: attributes ?? this.attributes,
      description: description ?? this.description,
      location: location ?? this.location,
      confirmNotStolen: confirmNotStolen ?? this.confirmNotStolen,
    );
  }

  bool get isEmpty {
    return title.isEmpty &&
        categoryId.isEmpty &&
        category.isEmpty &&
        condition.isEmpty &&
        price.isEmpty &&
        !negotiable &&
        photos.isEmpty &&
        attributes.isEmpty &&
        description.isEmpty &&
        location == null &&
        !confirmNotStolen;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categoryId': categoryId,
      'category': category,
      'condition': condition,
      'price': price,
      'negotiable': negotiable,
      'photos': photos.map((p) => p.toMap()).toList(),
      'attributes': attributes,
      'description': description,
      'location': location?.toMap(),
      'confirmNotStolen': confirmNotStolen,
    };
  }

  factory AddListingDraft.fromMap(Map<String, dynamic> map) {
    return AddListingDraft(
      title: map['title'] as String? ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      category:
          map['category'] as String? ?? map['categoryName'] as String? ?? '',
      condition: map['condition'] as String? ?? '',
      price: map['price']?.toString() ?? '',
      negotiable: map['negotiable'] as bool? ?? false,
      photos:
          (map['photos'] as List<dynamic>? ?? [])
              .map((e) => ListingPhotoItem.fromMap(e as Map<String, dynamic>))
              .toList(),
      attributes: (map['attributes'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      description: map['description'] as String? ?? '',
      location:
          map['location'] != null
              ? LocationModel.fromMap(map['location'] as Map<String, dynamic>)
              : null,
      confirmNotStolen: map['confirmNotStolen'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    title,
    categoryId,
    category,
    condition,
    price,
    negotiable,
    photos,
    attributes,
    description,
    location,
    confirmNotStolen,
  ];
}
