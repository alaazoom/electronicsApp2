import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/categories/data/services/category_service.dart';
import 'package:second_hand_electronics_marketplace/features/categories/presentation/cubits/category_states.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService categoryService;

  CategoryCubit({required this.categoryService}) : super(CategoryInitial());

  Future<void> fetchCategories({
    bool? isActive,
    int? page,
    int? limit = 100,
  }) async {
    emit(CategoryLoading());

    try {
      final response = await categoryService.getCategories(
        isActive: isActive,
        page: page,
        limit: limit,
      );
      emit(CategorySuccess(response));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
