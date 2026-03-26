import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistSuccess extends WishlistState {
  final List<ProductModel> wishlistItems;

  const WishlistSuccess(this.wishlistItems);

  @override
  List<Object?> get props => [wishlistItems];
}

class WishlistFailure extends WishlistState {
  final String errorMessage;

  const WishlistFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
