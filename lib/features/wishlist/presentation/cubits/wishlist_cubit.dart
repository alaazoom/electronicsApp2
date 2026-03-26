import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/wishlist_repository.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository repository;

  WishlistCubit({required this.repository}) : super(WishlistInitial());

  Set<String> wishlistProductIds = {};

  Future<void> fetchWishlist() async {
    emit(WishlistLoading());
    try {
      final items = await repository.getWishlist();
      wishlistProductIds = items.map((e) => e.id).toSet();
      emit(WishlistSuccess(items));
    } catch (e) {
      emit(WishlistFailure(e.toString()));
    }
  }

  Future<void> toggleWishlist(String productId) async {
    final bool isCurrentlyFavorite = wishlistProductIds.contains(productId);

    try {
      if (isCurrentlyFavorite) {
        final success = await repository.removeFromWishlist(productId);
        if (success) {
          wishlistProductIds.remove(productId);
        }
      } else {
        final success = await repository.addToWishlist(productId);
        if (success) {
          wishlistProductIds.add(productId);
        }
      }

      // Refresh the list if we are in success state to update UI
      if (state is WishlistSuccess) {
        final currentItems = (state as WishlistSuccess).wishlistItems;
        if (isCurrentlyFavorite) {
          final updatedItems =
              currentItems.where((item) => item.id != productId).toList();
          emit(WishlistSuccess(updatedItems));
        } else {
          // If we added, we might not have the full product model here easily
          // without fetching from server or state. For now, let's just re-fetch for simplicity
          // or emit current state to trigger UI update for icons
          fetchWishlist();
        }
      } else {
        emit(WishlistSuccess(const []));
        fetchWishlist();
      }
    } catch (e) {
      // Handle error, maybe show temporary toast via UI listening
    }
  }

  bool isFavorite(String productId) {
    return wishlistProductIds.contains(productId);
  }

  void clearWishlist() {
    wishlistProductIds.clear();
    emit(WishlistInitial());
  }
}
