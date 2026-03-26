import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_assets.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_popup.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/status_feedback_widget.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_state.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_media_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_media_state.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_submit_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_submit_state.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/pages/add_listing/steps/basic_details_step.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/pages/add_listing/steps/more_details_step.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/add_photo_options_sheet.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_category_sheet.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_location_sheet.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/listing_progress_bar.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Map<String, TextEditingController> _attributeControllers = {};

  bool _loadingDialogVisible = false;
  bool _allowPop = false;
  String _lastCategory = '';

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    for (final controller in _attributeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<bool> _handleBack(AddListingDraftState state) async {
    if (_allowPop) {
      _allowPop = false;
      return true;
    }
    if (state.step == AddListingStep.more) {
      context.read<AddListingDraftCubit>().prevStep();
      return false;
    }
    if (state.draft.isEmpty) return true;
    await context.read<AddListingDraftCubit>().saveDraft();
    CustomPopup.show(
      context,
      body: const StatusFeedbackWidget(
        iconPath: AppAssets.popupWarning,
        title: 'Leave this listing?',
        description:
            'Your changes are saved automatically. You can continue editing this listing later.',
      ),
      primaryButtonText: 'Continue editing',
      onPrimaryButtonPressed: () => Navigator.pop(context),
      secondaryButtonText: 'Leave',
      onSecondaryButtonPressed: () {
        Navigator.pop(context);
        _allowPop = true;
        Navigator.pop(context);
      },
    );
    return false;
  }

  void _syncControllers(AddListingDraftState state) {
    if (_titleController.text != state.draft.title) {
      _titleController.text = state.draft.title;
    }
    if (_priceController.text != state.draft.price) {
      _priceController.text = state.draft.price;
    }
    if (_descriptionController.text != state.draft.description) {
      _descriptionController.text = state.draft.description;
    }

    if (state.draft.categoryId != _lastCategory) {
      for (final controller in _attributeControllers.values) {
        controller.dispose();
      }
      _attributeControllers.clear();
      _lastCategory = state.draft.categoryId;
    }

    state.draft.attributes.forEach((key, value) {
      final controller = _attributeControllers[key];
      if (controller != null && controller.text != value) {
        controller.text = value;
      }
    });
  }

  void _showLoadingDialog() {
    if (_loadingDialogVisible) return;
    _loadingDialogVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) {
        return const _ListingSubmitLoading();
      },
    );
  }

  void _hideLoadingDialog() {
    if (!_loadingDialogVisible) return;
    Navigator.pop(context);
    _loadingDialogVisible = false;
  }

  void _showSuccessDialog() {
    CustomPopup.show(
      context,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAssets.popupDone, width: 72, height: 72),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            'Your Listing is under review',
            textAlign: TextAlign.center,
            style: AppTypography.h3_18Medium.copyWith(
              color: context.colors.titles,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            'We\'ve received your listing. Our team will review it within the next 12 hours. You\'ll be notified once it\'s approved.',
            textAlign: TextAlign.center,
            style: AppTypography.label12Regular.copyWith(
              color: context.colors.hint,
            ),
          ),
        ],
      ),
      primaryButtonText: 'View my Listings',
      onPrimaryButtonPressed: () {
        Navigator.pop(context);
        context.read<AddListingDraftCubit>().resetAfterSubmit();
        context.read<AddListingMediaCubit>().setPhotos(const []);
        context.read<AddListingSubmitCubit>().reset();
        context.goNamed(AppRoutes.mainLayout);
      },
      secondaryButtonText: 'Go Home',
      onSecondaryButtonPressed: () {
        Navigator.pop(context);
        context.read<AddListingDraftCubit>().resetAfterSubmit();
        context.read<AddListingMediaCubit>().setPhotos(const []);
        context.read<AddListingSubmitCubit>().reset();
        context.goNamed(AppRoutes.mainLayout);
      },
    );
  }

  void _openCategorySheet(
    AddListingDraftCubit cubit,
    AddListingDraftState state,
  ) {
    if (state.categories.isEmpty && !state.isLoadingCategories) {
      cubit.reloadCategories();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (_) => FractionallySizedBox(
            heightFactor: 0.9,
            child: BlocProvider.value(
              value: cubit,
              child: BlocBuilder<AddListingDraftCubit, AddListingDraftState>(
                builder: (context, sheetState) {
                  return ListingCategorySheet(
                    categories: sheetState.categories,
                    selectedCategoryId: sheetState.draft.categoryId,
                    onSelected: cubit.updateCategory,
                    isLoading: sheetState.isLoadingCategories,
                    errorMessage: sheetState.categoriesErrorMessage,
                    onRetry: cubit.reloadCategories,
                  );
                },
              ),
            ),
          ),
    );
  }

  void _openPhotoOptions(AddListingMediaCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => AddPhotoOptionsSheet(
            onTakePhoto: () {
              Navigator.pop(context);
              cubit.addPhotoFromCamera();
            },
            onPickGallery: () {
              Navigator.pop(context);
              cubit.addPhotoFromGallery();
            },
          ),
    );
  }

  void _openLocationSheet(
    AddListingDraftCubit cubit,
    AddListingDraftState state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (_) => ListingLocationSheet(
            initialLocation: state.draft.location,
            onSelected: cubit.updateLocation,
            onPickMap: () {
              Navigator.pop(context);
              _openMapSheet(cubit, state);
            },
          ),
    );
  }

  void _openMapSheet(AddListingDraftCubit cubit, AddListingDraftState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (_) => FractionallySizedBox(
            heightFactor: 0.9,
            child: ListingMapSheet(
              onSelected: cubit.updateLocation,
              onOpenList: () {
                Navigator.pop(context);
                Future.microtask(() {
                  if (!mounted) return;
                  _openLocationSheet(
                    cubit,
                    context.read<AddListingDraftCubit>().state,
                  );
                });
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddListingDraftCubit, AddListingDraftState>(
          listener: (context, state) {
            _syncControllers(state);
          },
        ),
        BlocListener<AddListingDraftCubit, AddListingDraftState>(
          listenWhen:
              (previous, current) =>
                  previous.draft.photos != current.draft.photos,
          listener: (context, state) {
            context.read<AddListingMediaCubit>().setPhotos(state.draft.photos);
          },
        ),
        BlocListener<AddListingMediaCubit, AddListingMediaState>(
          listenWhen: (previous, current) => previous.photos != current.photos,
          listener: (context, state) {
            context.read<AddListingDraftCubit>().updatePhotos(state.photos);
          },
        ),
        BlocListener<AddListingSubmitCubit, AddListingSubmitState>(
          listener: (context, state) {
            if (state.status == AddListingSubmitStatus.submitting) {
              _showLoadingDialog();
            } else if (_loadingDialogVisible) {
              _hideLoadingDialog();
            }

            if (state.status == AddListingSubmitStatus.success) {
              _showSuccessDialog();
              context.read<AddListingSubmitCubit>().reset();
            }

            if (state.status == AddListingSubmitStatus.offline) {
              context.read<AddListingSubmitCubit>().reset();
              context.pushNamed(AppRoutes.noInternet);
            }

            if (state.status == AddListingSubmitStatus.failure) {
              EasyLoading.showError(
                state.errorMessage.isEmpty
                    ? 'Failed to submit listing. Please try again.'
                    : state.errorMessage,
              );
              context.read<AddListingSubmitCubit>().reset();
            }
          },
        ),
      ],
      child: BlocBuilder<AddListingDraftCubit, AddListingDraftState>(
        builder: (context, state) {
          final draftCubit = context.read<AddListingDraftCubit>();
          final mediaCubit = context.read<AddListingMediaCubit>();
          final submitCubit = context.read<AddListingSubmitCubit>();
          if (state.isLoadingDraft) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return WillPopScope(
            onWillPop: () => _handleBack(state),
            child: Scaffold(
              appBar: AppBar(title: const Text('Add Listing')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingM,
                  AppSizes.paddingM,
                  AppSizes.paddingM,
                  AppSizes.paddingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListingProgressBar(
                      currentStep: state.step == AddListingStep.basic ? 1 : 2,
                      totalSteps: 2,
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    if (state.step == AddListingStep.basic)
                      BasicDetailsStep(
                        titleController: _titleController,
                        priceController: _priceController,
                        onOpenCategory:
                            () => _openCategorySheet(draftCubit, state),
                        onOpenPhotoOptions: () => _openPhotoOptions(mediaCubit),
                        onOpenTips: () => showPhotoTipsSheet(context),
                      )
                    else
                      MoreDetailsStep(
                        descriptionController: _descriptionController,
                        attributeControllers: _attributeControllers,
                        onOpenLocation:
                            () => _openLocationSheet(draftCubit, state),
                      ),
                    const SizedBox(height: AppSizes.paddingL),
                    if (state.step == AddListingStep.basic)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state.canProceed ? draftCubit.nextStep : null,
                          child: const Text('Next'),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  state.draft.isEmpty
                                      ? null
                                      : () async {
                                        await draftCubit.saveDraft();
                                        if (!mounted) return;
                                        EasyLoading.showSuccess('Draft saved');
                                      },
                              child: const Text('Save Draft'),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  state.canPublish
                                      ? () => submitCubit.submit(
                                        state.draft,
                                        canPublish: state.canPublish,
                                      )
                                      : null,
                              child: const Text('Publish'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ListingSubmitLoading extends StatefulWidget {
  const _ListingSubmitLoading();

  @override
  State<_ListingSubmitLoading> createState() => _ListingSubmitLoadingState();
}

class _ListingSubmitLoadingState extends State<_ListingSubmitLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _controller,
              child: SvgPicture.asset(
                AppAssets.loadingSvg,
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(
                  colors.mainColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'We\'re sending your Listing',
              style: AppTypography.body16Regular.copyWith(
                color: colors.surface,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              'This may take a few seconds..',
              style: AppTypography.label12Regular.copyWith(
                color: colors.surface.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
