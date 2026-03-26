import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/add_listing_draft.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_draft_storage.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_submit_service.dart';

import 'add_listing_submit_state.dart';

class AddListingSubmitCubit extends Cubit<AddListingSubmitState> {
  AddListingSubmitCubit({
    ListingSubmitService? submitService,
    ListingDraftStorage? draftStorage,
  }) : _submitService = submitService ?? ListingSubmitService(),
       _draftStorage = draftStorage ?? ListingDraftStorage(),
       super(const AddListingSubmitState());

  final ListingSubmitService _submitService;
  final ListingDraftStorage _draftStorage;

  Future<void> submit(AddListingDraft draft, {required bool canPublish}) async {
    if (!canPublish) return;
    emit(
      state.copyWith(
        status: AddListingSubmitStatus.submitting,
        errorMessage: '',
      ),
    );

    final result = await _submitService.submitListing(draft);

    switch (result.type) {
      case ListingSubmitResultType.success:
        await _draftStorage.clearDraft();
        emit(
          state.copyWith(
            status: AddListingSubmitStatus.success,
            errorMessage: '',
          ),
        );
        break;
      case ListingSubmitResultType.offline:
        emit(
          state.copyWith(
            status: AddListingSubmitStatus.offline,
            errorMessage: result.message ?? '',
          ),
        );
        break;
      case ListingSubmitResultType.unauthorized:
        emit(
          state.copyWith(
            status: AddListingSubmitStatus.failure,
            errorMessage: result.message ?? 'You need to log in again.',
          ),
        );
        break;
      case ListingSubmitResultType.validation:
        emit(
          state.copyWith(
            status: AddListingSubmitStatus.failure,
            errorMessage:
                result.message ??
                'Please check the listing details and try again.',
          ),
        );
        break;
      case ListingSubmitResultType.uploadError:
        emit(
          state.copyWith(
            status: AddListingSubmitStatus.failure,
            errorMessage:
                result.message ??
                'Image upload failed. Please try again later.',
          ),
        );
        break;
      case ListingSubmitResultType.failure:
        emit(
          state.copyWith(
            status: AddListingSubmitStatus.failure,
            errorMessage: result.message ?? 'Failed to submit listing.',
          ),
        );
        break;
    }
  }

  void reset() {
    emit(state.copyWith(status: AddListingSubmitStatus.idle, errorMessage: ''));
  }
}
