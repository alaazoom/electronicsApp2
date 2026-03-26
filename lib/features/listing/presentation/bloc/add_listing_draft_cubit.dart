import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/add_listing_draft.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_field_config.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_photo_item.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_catalog_service.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_draft_storage.dart';
import 'package:second_hand_electronics_marketplace/features/location/data/models/location_model.dart';

import 'add_listing_draft_state.dart';

class AddListingDraftCubit extends Cubit<AddListingDraftState> {
  AddListingDraftCubit({
    ListingCatalogService? catalogService,
    ListingDraftStorage? draftStorage,
  }) : _catalogService = catalogService ?? ListingCatalogService(),
       _draftStorage = draftStorage ?? ListingDraftStorage(),
       super(AddListingDraftState.initial());

  final ListingCatalogService _catalogService;
  final ListingDraftStorage _draftStorage;

  ListingCategoryConfig? get selectedCategoryConfig =>
      state.selectedCategoryConfig;

  List<ListingCategoryConfig> get categories => state.categories;

  Future<void> loadDraft() async {
    emit(
      state.copyWith(
        isLoadingDraft: true,
        isLoadingCategories: true,
        categoriesErrorMessage: '',
      ),
    );

    final draftFuture = _draftStorage.readDraft();

    List<ListingCategoryConfig> loadedCategories = const [];
    String categoriesError = '';
    try {
      loadedCategories = await _catalogService.getCategories();
    } catch (e) {
      categoriesError = _cleanErrorMessage(e);
    }

    final storedDraft = await draftFuture;
    var draft = storedDraft ?? const AddListingDraft();
    draft = _normalizeDraftCategory(draft, loadedCategories);
    final selected = _catalogService.getCategoryConfig(
      draft.categoryId,
      loadedCategories,
    );
    draft = _migrateLegacyAttributes(draft, selected);

    _emitDraft(
      draft,
      categories: loadedCategories,
      selectedCategoryConfig: selected,
      isLoadingDraft: false,
      isLoadingCategories: false,
      categoriesErrorMessage: categoriesError,
    );
  }

  Future<void> reloadCategories() async {
    emit(state.copyWith(isLoadingCategories: true, categoriesErrorMessage: ''));

    try {
      final loadedCategories = await _catalogService.getCategories(
        forceRefresh: true,
      );
      var draft = _normalizeDraftCategory(state.draft, loadedCategories);
      final selected = _catalogService.getCategoryConfig(
        draft.categoryId,
        loadedCategories,
      );
      draft = _migrateLegacyAttributes(draft, selected);

      _emitDraft(
        draft,
        categories: loadedCategories,
        selectedCategoryConfig: selected,
        isLoadingCategories: false,
        categoriesErrorMessage: '',
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCategories: false,
          categoriesErrorMessage: _cleanErrorMessage(e),
        ),
      );
    }
  }

  void setStep(AddListingStep step) {
    emit(state.copyWith(step: step));
  }

  void nextStep() {
    if (!state.canProceed) return;
    emit(state.copyWith(step: AddListingStep.more));
  }

  void prevStep() {
    emit(state.copyWith(step: AddListingStep.basic));
  }

  void updateTitle(String value) {
    _emitDraft(state.draft.copyWith(title: value));
  }

  void updateCategory(ListingCategoryConfig category) {
    _emitDraft(
      state.draft.copyWith(
        categoryId: category.id,
        category: category.name,
        attributes: const {},
      ),
      selectedCategoryConfig: category,
    );
  }

  void updateCondition(String value) {
    _emitDraft(state.draft.copyWith(condition: value));
  }

  void updatePrice(String value) {
    _emitDraft(state.draft.copyWith(price: value));
  }

  void toggleNegotiable(bool value) {
    _emitDraft(state.draft.copyWith(negotiable: value));
  }

  void updateDescription(String value) {
    _emitDraft(state.draft.copyWith(description: value));
  }

  void updateAttribute(String key, String value) {
    final updated = Map<String, String>.from(state.draft.attributes);
    updated[key] = value;
    _emitDraft(state.draft.copyWith(attributes: updated));
  }

  void updateLocation(LocationModel location) {
    _emitDraft(state.draft.copyWith(location: location));
  }

  void toggleConfirmNotStolen(bool value) {
    _emitDraft(state.draft.copyWith(confirmNotStolen: value));
  }

  void updatePhotos(List<ListingPhotoItem> photos) {
    if (_samePhotos(state.draft.photos, photos)) return;
    _emitDraft(state.draft.copyWith(photos: photos));
  }

  Future<void> saveDraft() async {
    if (state.draft.isEmpty) return;
    try {
      await _draftStorage.writeDraft(state.draft);
    } catch (_) {}
  }

  void resetAfterSubmit() {
    emit(
      AddListingDraftState.initial().copyWith(
        categories: state.categories,
        selectedCategoryConfig: null,
      ),
    );
  }

  void _emitDraft(
    AddListingDraft draft, {
    List<ListingCategoryConfig>? categories,
    ListingCategoryConfig? selectedCategoryConfig,
    bool? isLoadingDraft,
    bool? isLoadingCategories,
    String? categoriesErrorMessage,
  }) {
    final effectiveCategories = categories ?? state.categories;
    final effectiveCategoryConfig =
        draft.categoryId.trim().isEmpty
            ? null
            : (selectedCategoryConfig ??
                _catalogService.getCategoryConfig(
                  draft.categoryId,
                  effectiveCategories,
                ));

    final computed = _computeFlags(draft, effectiveCategoryConfig);
    emit(
      state.copyWith(
        draft: draft,
        categories: effectiveCategories,
        selectedCategoryConfig: effectiveCategoryConfig,
        isLoadingDraft: isLoadingDraft ?? state.isLoadingDraft,
        isLoadingCategories: isLoadingCategories ?? state.isLoadingCategories,
        categoriesErrorMessage:
            categoriesErrorMessage ?? state.categoriesErrorMessage,
        canProceed: computed.canProceed,
        canPublish: computed.canPublish,
      ),
    );
  }

  ({bool canProceed, bool canPublish}) _computeFlags(
    AddListingDraft draft,
    ListingCategoryConfig? categoryConfig,
  ) {
    final hasValidPhoto = draft.photos.any(
      (p) => p.status == ListingPhotoStatus.ready,
    );
    final hasPhotoError = draft.photos.any(
      (p) =>
          p.status == ListingPhotoStatus.tooLarge ||
          p.status == ListingPhotoStatus.error,
    );

    final basicReady =
        hasValidPhoto &&
        !hasPhotoError &&
        draft.title.trim().isNotEmpty &&
        draft.categoryId.trim().isNotEmpty &&
        draft.condition.trim().isNotEmpty &&
        draft.price.trim().isNotEmpty;

    final requiredFields =
        categoryConfig?.fields.where((f) => f.required).toList() ?? const [];

    final requiredOk = requiredFields.every(
      (f) => (draft.attributes[f.key] ?? '').trim().isNotEmpty,
    );

    final moreReady =
        basicReady &&
        categoryConfig != null &&
        requiredOk &&
        draft.location != null &&
        draft.confirmNotStolen;

    return (canProceed: basicReady, canPublish: moreReady);
  }

  AddListingDraft _normalizeDraftCategory(
    AddListingDraft draft,
    List<ListingCategoryConfig> categories,
  ) {
    String categoryId = draft.categoryId;
    String categoryName = draft.category;

    if (categoryId.trim().isEmpty && categoryName.trim().isNotEmpty) {
      for (final category in categories) {
        if (category.name.toLowerCase() == categoryName.toLowerCase()) {
          categoryId = category.id;
          categoryName = category.name;
          break;
        }
      }
    }

    if (categoryId.trim().isNotEmpty) {
      final category = _catalogService.getCategoryConfig(
        categoryId,
        categories,
      );
      if (category != null) {
        categoryName = category.name;
      }
    }

    return draft.copyWith(categoryId: categoryId, category: categoryName);
  }

  AddListingDraft _migrateLegacyAttributes(
    AddListingDraft draft,
    ListingCategoryConfig? config,
  ) {
    if (config == null || draft.attributes.isEmpty) return draft;

    final normalizedCurrent = <String, String>{};
    final current = Map<String, String>.from(draft.attributes);

    for (final field in config.fields) {
      final direct = current[field.key];
      if (direct != null && direct.trim().isNotEmpty) {
        normalizedCurrent[field.key] = direct;
        continue;
      }

      final byLegacy =
          current[field.legacyKey] ??
          current[field.label] ??
          current[field.label.toLowerCase()] ??
          current[field.label.trim().toLowerCase().replaceAll(
            RegExp(r'[^a-z0-9]+'),
            '_',
          )];

      if (byLegacy != null && byLegacy.trim().isNotEmpty) {
        normalizedCurrent[field.key] = byLegacy;
      }
    }

    return draft.copyWith(attributes: normalizedCurrent);
  }

  String _cleanErrorMessage(Object error) {
    return error.toString().replaceAll('Exception: ', '').trim();
  }

  bool _samePhotos(List<ListingPhotoItem> a, List<ListingPhotoItem> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
