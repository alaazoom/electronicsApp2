import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/products/data/repo/products_repo.dart';
import 'my_listings_state.dart';

class MyListingsCubit extends Cubit<MyListingsState> {
  final ProductsRepository repository;

  MyListingsCubit({required this.repository}) : super(MyListingsInitial());

  Future<void> fetchMyListings({String status = 'All'}) async {
    emit(MyListingsLoading());
    try {
      List<String>? statusList;
      if (status != 'All') {
        statusList = [status.toLowerCase()];
      }

      final listings = await repository.getMyProducts(status: statusList);
      emit(MyListingsSuccess(listings: listings, status: status));
    } catch (e) {
      emit(MyListingsFailure(e.toString()));
    }
  }

  void clearMyListings() {
    emit(MyListingsInitial());
  }
}
