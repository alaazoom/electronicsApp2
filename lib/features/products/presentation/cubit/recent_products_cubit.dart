import 'products_cubit.dart';
import '../../data/repo/products_repo.dart';

class RecentProductsCubit extends ProductsCubit {
  RecentProductsCubit(ProductsRepository repository) : super(repository);

  @override
  Future<void> fetchProducts({
    int page = 1,
    String? categoryId,
    String? sortBy = 'createdAt',
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
