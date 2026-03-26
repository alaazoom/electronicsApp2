import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';

class AddListingMediaState extends Equatable {
  final List<ListingPhotoItem> photos;

  const AddListingMediaState({this.photos = const []});

  AddListingMediaState copyWith({List<ListingPhotoItem>? photos}) {
    return AddListingMediaState(photos: photos ?? this.photos);
  }

  @override
  List<Object?> get props => [photos];
}
