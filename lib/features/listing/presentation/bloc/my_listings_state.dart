import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';

abstract class MyListingsState extends Equatable {
  const MyListingsState();

  @override
  List<Object?> get props => [];
}

class MyListingsInitial extends MyListingsState {}

class MyListingsLoading extends MyListingsState {}

class MyListingsSuccess extends MyListingsState {
  final List<ProductModel> listings;
  final String status;

  const MyListingsSuccess({required this.listings, required this.status});

  @override
  List<Object?> get props => [listings, status];
}

class MyListingsFailure extends MyListingsState {
  final String message;

  const MyListingsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
