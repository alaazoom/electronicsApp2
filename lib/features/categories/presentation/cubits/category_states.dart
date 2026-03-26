import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/features/categories/data/models/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final CategoryResponseModel response;

  const CategorySuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CategoryFailure extends CategoryState {
  final String errorMessage;

  const CategoryFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
