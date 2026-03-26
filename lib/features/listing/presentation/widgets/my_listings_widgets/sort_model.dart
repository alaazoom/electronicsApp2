import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/simple_selection_list.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/selection_cubit.dart';

class SortModel extends StatelessWidget {
  SortModel({super.key});

  final List<SimpleSelectionOption> sortOptions = [
    SimpleSelectionOption(label: 'Newest'),
    SimpleSelectionOption(label: 'Most Viewed'),
    SimpleSelectionOption(label: 'Price: Low to High'),
    SimpleSelectionOption(label: 'Price: High to Low'),
  ];
  int selectedSortOption = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return BlocConsumer<SelectionCubit, int>(
              listener: (context, state) {
                selectedSortOption = state;
              },

              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  //height: 400,
                  child: Column(
                    children: [
                      Gap(10),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sort By',
                              style: AppTypography.body14Regular.copyWith(
                                color: context.colors.titles,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset(
                                'assets/svgs/Close_Square.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(20),
                      SimpleSelectionList(
                        title: '',
                        options: sortOptions,
                        selectedIndex: selectedSortOption,
                        onChanged: (int value) {
                          context.read<SelectionCubit>().select(value);
                          print(value);
                        },
                      ),
                      Gap(30),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Apply'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },

      icon: SvgPicture.asset(AppAssets.swapIcon),
    );
  }
}
