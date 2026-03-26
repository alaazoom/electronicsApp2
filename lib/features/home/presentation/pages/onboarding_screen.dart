import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/badge_widget.dart';

class OnboardingData {
  final String title;
  final String description;
  final String imagePlaceholder;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePlaceholder,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      imagePlaceholder: AppAssets.onboarding1,
    ),
    OnboardingData(
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      imagePlaceholder: AppAssets.onboarding2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_pages[index].imagePlaceholder),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSizes.paddingL),

                          Text(
                            _pages[index].title,
                            textAlign: TextAlign.center,
                            style: AppTypography.h2_20Medium.copyWith(
                              color: context.colors.titles,
                            ),
                          ),

                          const SizedBox(height: AppSizes.paddingS),

                          Text(
                            _pages[index].description,
                            textAlign: TextAlign.center,
                            style: AppTypography.body16Regular.copyWith(
                              color: context.colors.text.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingM),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (idx) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 8,
                                width: _currentPage == idx ? 22 : 8,
                                decoration: BoxDecoration(
                                  color:
                                      _currentPage == idx
                                          ? context.colors.mainColor
                                          : context.colors.mainColor40,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              // في ملف onboarding_screen.dart
                              onPressed: () {
                                if (_currentPage == _pages.length - 1) {
                                  context.goNamed(AppRoutes.countrySelection);
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },

                              child: Text(
                                _currentPage == _pages.length - 1
                                    ? AppStrings.getStarted
                                    : AppStrings.next,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingL),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          Positioned(
            top: 50,
            left: AppSizes.paddingM,
            child: BadgeWidget(
              text: AppStrings.languageEn,
              bgColor: context.colors.mainColor,
              textColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
