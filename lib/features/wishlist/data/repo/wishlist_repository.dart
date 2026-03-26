import 'package:second_hand_electronics_marketplace/features/products/data/models/product_model.dart';
import '../services/wishlist_service.dart';

class WishlistRepository {
  final WishlistService service;

  WishlistRepository({required this.service});

  Future<List<ProductModel>> getWishlist() async {
    final response = await service.getWishlist();
    // Assuming structure is { success: true, data: [...] }
    final List<dynamic> list = response['data'] ?? [];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<bool> addToWishlist(String productId) async {
    return await service.addToWishlist(productId);
  }

  Future<bool> removeFromWishlist(String productId) async {
    return await service.removeFromWishlist(productId);
  }
}
