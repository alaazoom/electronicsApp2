import 'products_cubit.dart';
import '../../data/repo/products_repo.dart';

class RecommendedProductsCubit extends ProductsCubit {
  RecommendedProductsCubit(ProductsRepository repository) : super(repository);

  @override
  Future<void> fetchProducts({
    int page = 1,
    String? categoryId,
    String? sortBy =
        'viewCount', // Using viewCount as a proxy for recommendation
    String? sortOrder = 'desc',
  }) {
    return super.fetchProducts(
      page: page,
      categoryId: categoryId,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
