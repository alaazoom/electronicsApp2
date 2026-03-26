import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import '../../data/repo/products_repo.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository repository;

  ProductsCubit(this.repository) : super(ProductsInitial());

  // تخزين المنتجات عشان لو حبينا نعمل Pagination مستقبلاً
  List<ProductModel> allProducts = [];

  Future<void> fetchProducts({
    int page = 1,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    emit(ProductsLoading()); // إظهار الشيمر أو دائرة التحميل في الـ UI
    try {
      final products = await repository.getAllProducts(
        page: page,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      allProducts = products;
      emit(ProductsLoaded(allProducts)); // إرسال الداتا للواجهة
    } catch (e) {
      emit(ProductsError(e.toString())); // إرسال رسالة الخطأ للواجهة
    }
  }
}
