import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_colors.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/app_typography.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_popup.dart';

class MoreVertButton extends StatelessWidget {
  MoreVertButton({super.key, required this.selectState});

  final int selectState;

  Map<int, List<String>> options = {
    0: ['Edit', 'Delete'],
    1: ['Edit', 'Delete'],
    2: ['Edit', 'Share', 'Mark as Sold', 'Archive', 'Delete'],
    3: ['Edit', 'View Reason', 'Delete'],
    4: ['Archive', 'Republish', 'Delete'],
    5: ['Publish', 'Delete'],
    6: ['Continue editing', 'Delete'],
  };

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,

          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Option Listings',
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: options[selectState]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final option = options[selectState]![index];
                      return ListTile(
                        title: Text(
                          option,
                          style: TextStyle(
                            color:
                                index == options[selectState]!.length - 1
                                    ? const Color.fromARGB(255, 247, 1, 1)
                                    : Colors.black,
                          ),
                        ),
                        onTap: () {
                          // Handle option tap
                          switch (option) {
                            case 'Edit':
                              // Handle edit action
                              CustomPopup.show(
                                context,
                                body: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/pop_up_icon.svg',
                                    ),
                                    Gap(10),
                                    Text(
                                      'Edit Listing',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Gap(10),
                                    Text(
                                      'Are you sure you want to edit this listing?',
                                    ),
                                  ],
                                ),
                                //: SvgPicture.asset('assets/svgs/Frame.svg'),
                                primaryButtonText: 'Edit',
                                onPrimaryButtonPressed: () {
                                  // Perform delete action
                                  Navigator.pop(context);
                                },
                                secondaryButtonText: AppStrings.cancel,
                                onSecondaryButtonPressed: () {
                                  Navigator.pop(context);
                                },
                                primaryButtonColor: context.colors.mainColor,
                              );
                              break;
                            case 'Delete':
                              // Handle delete action
                              CustomPopup.show(
                                context,
                                body: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/pop_up_icon.svg',
                                    ),
                                    Gap(10),
                                    Text(
                                      'Delete Listing',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Gap(10),
                                    Text(
                                      'Are you sure you want to delete this listing?',
                                    ),
                                  ],
                                ),
                                //: SvgPicture.asset('assets/svgs/Frame.svg'),
                                primaryButtonText: 'Delete',
                                onPrimaryButtonPressed: () {
                                  // Perform delete action
                                  Navigator.pop(context);
                                },
                                secondaryButtonText: AppStrings.cancel,
                                onSecondaryButtonPressed: () {
                                  Navigator.pop(context);
                                },
                                primaryButtonColor: Colors.red,
                              );
                              break;
                            case 'Share':
                              // Handle share action
                              break;
                            case 'Copy Link':
                              // Handle copy link action
                              break;
                            case 'Republish':
                              // Handle republish action
                              break;
                            case 'Mark as Sold':
                              // Handle mark as sold action
                              CustomPopup.show(
                                context,
                                body: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/pop_up_icon.svg',
                                    ),
                                    Gap(10),
                                    Text(
                                      'Mark as Sold',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Gap(10),
                                    Text(
                                      'Are you sure you want to Mark this listing as Sold?',
                                    ),
                                  ],
                                ),
                                //: SvgPicture.asset('assets/svgs/Frame.svg'),
                                primaryButtonText: 'Mark as Sold',
                                onPrimaryButtonPressed: () {
                                  // Perform delete action
                                  Navigator.pop(context);
                                },
                                secondaryButtonText: AppStrings.cancel,
                                onSecondaryButtonPressed: () {
                                  Navigator.pop(context);
                                },
                                primaryButtonColor: context.colors.mainColor,
                              );
                              break;
                            case 'Archive':
                              // Handle archive action
                              break;
                            case 'View Reason':
                              // Handle view reason action
                              break;
                            case 'Publish':
                              // Handle publish action
                              break;
                            case 'Continue Editing':
                              // Handle continue editing action
                              break;
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Center(child: Icon(Icons.more_vert, size: 20)),
    );
  }
}
