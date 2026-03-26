import 'package:equatable/equatable.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/add_listing_draft.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/listing_field_config.dart';

enum AddListingStep { basic, more }

const _unset = Object();

class AddListingDraftState extends Equatable {
  final AddListingDraft draft;
  final List<ListingCategoryConfig> categories;
  final ListingCategoryConfig? selectedCategoryConfig;
  final AddListingStep step;
  final bool isLoadingDraft;
  final bool isLoadingCategories;
  final String categoriesErrorMessage;
  final bool canProceed;
  final bool canPublish;

  const AddListingDraftState({
    required this.draft,
    this.categories = const [],
    this.selectedCategoryConfig,
    this.step = AddListingStep.basic,
    this.isLoadingDraft = false,
    this.isLoadingCategories = false,
    this.categoriesErrorMessage = '',
    this.canProceed = false,
    this.canPublish = false,
  });

  factory AddListingDraftState.initial() {
    return const AddListingDraftState(draft: AddListingDraft());
  }

  AddListingDraftState copyWith({
    AddListingDraft? draft,
    List<ListingCategoryConfig>? categories,
    Object? selectedCategoryConfig = _unset,
    AddListingStep? step,
    bool? isLoadingDraft,
    bool? isLoadingCategories,
    String? categoriesErrorMessage,
    bool? canProceed,
    bool? canPublish,
  }) {
    return AddListingDraftState(
      draft: draft ?? this.draft,
      categories: categories ?? this.categories,
      selectedCategoryConfig:
          selectedCategoryConfig == _unset
              ? this.selectedCategoryConfig
              : selectedCategoryConfig as ListingCategoryConfig?,
      step: step ?? this.step,
      isLoadingDraft: isLoadingDraft ?? this.isLoadingDraft,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      categoriesErrorMessage:
          categoriesErrorMessage ?? this.categoriesErrorMessage,
      canProceed: canProceed ?? this.canProceed,
      canPublish: canPublish ?? this.canPublish,
    );
  }

  @override
  List<Object?> get props => [
    draft,
    categories,
    selectedCategoryConfig,
    step,
    isLoadingDraft,
    isLoadingCategories,
    categoriesErrorMessage,
    canProceed,
    canPublish,
  ];
}
