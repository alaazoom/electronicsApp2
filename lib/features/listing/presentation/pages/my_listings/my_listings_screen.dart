import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_strings.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/filter_button.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/my_listings_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/my_listings_state.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/vertical_card.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/horizontal_card.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/no_listings.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/widgets/my_listings_widgets/sort_model.dart';

class MyListingScreen extends StatefulWidget {
  const MyListingScreen({super.key});

  @override
  State<MyListingScreen> createState() => _MyListingScreenState();
}

class _MyListingScreenState extends State<MyListingScreen> {
  int selectedSortOption = 0;
  bool isGridView = false;

  final List<String> statusOptions = [
    'All',
    'Pending',
    'Active',
    'Rejected',
    'Sold',
    'Archived',
    'Draft',
  ];
  int selectedStatusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        leading: const BackButton(),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchWidget(
                          controller: TextEditingController(),
                          onChanged: (value) {},
                        ),
                      ),
                      const Gap(10),
                      const FilterButton(),
                    ],
                  ),
                  const Gap(16),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: statusOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final bool isSelected = selectedStatusIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatusIndex = index;
                            });
                            context.read<MyListingsCubit>().fetchMyListings(
                              status: statusOptions[index],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? context.colors.mainColor
                                        : context.colors.border,
                              ),
                              color:
                                  isSelected
                                      ? context.colors.mainColor
                                      : context.colors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusOptions[index],
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : context.colors.text,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [SortModel(), const Text(AppStrings.sort)]),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isGridView = false;
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/svgs/document_colord.svg',
                              color:
                                  !isGridView
                                      ? context.colors.mainColor
                                      : context.colors.icons,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isGridView = true;
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/svgs/category_uncolord.svg',
                              color:
                                  isGridView
                                      ? context.colors.mainColor
                                      : context.colors.icons,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<MyListingsCubit, MyListingsState>(
                builder: (context, state) {
                  if (state is MyListingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MyListingsFailure) {
                    return Center(child: Text(state.message));
                  } else if (state is MyListingsSuccess) {
                    if (state.listings.isEmpty) {
                      return NoListings(
                        text:
                            selectedStatusIndex == 0
                                ? "haven't added any yet"
                                : 'have no ${statusOptions[selectedStatusIndex]} items',
                      );
                    }
                    return isGridView
                        ? GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.60,
                              ),
                          itemBuilder:
                              (context, index) => VerticalCard(
                                listing: state.listings[index],
                                isOwnerMode: true,
                                ownerMenuState: selectedStatusIndex,
                              ),
                          itemCount: state.listings.length,
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder:
                              (context, index) => HorizontalCard(
                                listing: state.listings[index],
                                isOwnerMode: true,
                                ownerMenuState: selectedStatusIndex,
                              ),
                          itemCount: state.listings.length,
                          scrollDirection: Axis.vertical,
                        );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
