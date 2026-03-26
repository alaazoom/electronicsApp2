import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';
import 'package:second_hand_electronics_marketplace/features/auth/presentation/cubits/auth_states.dart';
import 'package:second_hand_electronics_marketplace/features/auth/presentation/pages/login_screen.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/pages/country_selection_screen.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/pages/main_layout_screen.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/pages/onboarding_screen.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/pages/my_listings/my_listings_screen.dart';
import 'package:second_hand_electronics_marketplace/features/location/presentation/pages/location_page.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_draft_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_media_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/bloc/add_listing_submit_cubit.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_catalog_service.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/services/listing_submit_service.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/pages/add_listing/add_listing_screen.dart';
import 'package:second_hand_electronics_marketplace/features/listing/presentation/pages/no_internet_screen.dart';
import 'package:second_hand_electronics_marketplace/features/profile/presentation/pages/user_profile/settings_screen/help_center_screen.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/auth/presentation/pages/change_password_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/otp_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/home/presentation/pages/favorite_screen.dart';
import '../../features/home/presentation/pages/listings_screen.dart';
import '../../features/home/presentation/pages/splash_screen.dart';
import '../../features/chating/presentation/screens/chating_screen.dart';
import '../../features/products/data/models/product_model.dart';
import '../../features/profile/data/services/profile_service.dart';
import '../../features/profile/presentation/pages/user_profile/settings_screen/currency_screen.dart';
import '../../features/profile/presentation/pages/user_profile/settings_screen/language_currency_screen.dart';
import '../../features/profile/presentation/pages/user_profile/settings_screen/language_screen.dart';
import '../../features/profile/presentation/pages/user_profile/settings_screen/notification_settings_screen.dart';
import '../../features/profile/presentation/pages/user_profile/user_profile_screens/edit_user_profile.dart';
import '../../features/profile/presentation/widgets/profile_widgets/profile_error_screen.dart';
import '../../features/profile/profile_exports.dart';
import '../../features/verification/presentation/pages/verification_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import '../../core/constants/cache_keys.dart';
import '../../core/helpers/cache_helper.dart';

class AppRouter {
  static final bool isFirstTime =
      CacheHelper.getData(key: CacheKeys.isFirstTime) ?? true;
  static final GoRouter _router = GoRouter(
    initialLocation:
        isFirstTime ? '/${AppRoutes.splash}' : '/${AppRoutes.mainLayout}',

    debugLogDiagnostics: true,
    redirect: (context, state) async {
      return null;
    },
    routes: [
      GoRoute(
        path: '/${AppRoutes.splash}',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding route
      GoRoute(
        path: '/${AppRoutes.onboarding}',
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/${AppRoutes.mylistings}',
        name: AppRoutes.mylistings,
        builder: (context, state) => MyListingScreen(),
      ),
      //country selection
      GoRoute(
        path: '/${AppRoutes.countrySelection}',
        name: AppRoutes.countrySelection,
        builder: (context, state) => const CountrySelectionScreen(),
      ),
      //location route
      GoRoute(
        path: '/${AppRoutes.location}',
        name: AppRoutes.location,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LocationScreen(
            initialLat: extra?['initialLat'] as double? ?? 0.0,
            initialLng: extra?['initialLng'] as double? ?? 0.0,
            fallbackCountry:
                extra?['fallbackCountry'] as String? ?? '', // ✅ نستقبل الدولة
            fallbackCity:
                extra?['fallbackCity'] as String? ?? '', // ✅ نستقبل المدينة
          );
        },
      ),
      GoRoute(
        path: '/${AppRoutes.verification}',
        name: AppRoutes.verification,
        builder: (context, state) => VerificationScreen(),
      ),
      // GoRoute(
      //   path: '/${AppRoutes.home}',
      //   name: AppRoutes.home,
      //   builder: (context, state) => HomeScreen(),
      // ),
      GoRoute(
        path: '/${AppRoutes.mainLayout}',
        name: AppRoutes.mainLayout,
        builder: (context, state) => MainLayoutScreen(),
        routes: [
          GoRoute(
            path: '/${AppRoutes.listings}',
            name: AppRoutes.listings,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return ListingsScreen(
                title: args['title'] as String,
                listings: args['listings'] as List<ProductModel>,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.favorite,
            name: AppRoutes.favorite,
            builder: (context, state) => FavoriteScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/${AppRoutes.userProfile}',
        name: AppRoutes.userProfile,
        builder: (context, state) {
          final authState = context.read<AuthCubit>().state;

          if (authState is AuthSuccess) {
            final user = authState.response.user!;
            return ProfileScreen(
              key: ValueKey(
                '${user.isPhoneVerified}_${user.isEmailVerified}_${user.isIdentityVerified}',
              ),
              authUser: user,
              isMe: true,
            );
          }

          return const ProfileErrorScreen();
        },
        routes: [
          GoRoute(
            path: '/${AppRoutes.editUserProfile}',
            name: AppRoutes.editUserProfile,
            builder: (context, state) {
              final authState = context.read<AuthCubit>().state;

              if (authState is AuthSuccess) {
                return BlocProvider(
                  create:
                      (context) => ProfileBloc(
                        context
                            .read<
                              ProfileService
                            >(), // تأكدي ProfileService موجود في MultiRepositoryProvider
                        authState.response.user!,
                      )..add(FetchProfileEvent(isMe: true)),
                  child: EditUserProfile(
                    authUser: authState.response.user!,
                    isMe: true,
                  ),
                );
              }

              return const ProfileErrorScreen();
            },
          ),
          GoRoute(
            path: '/${AppRoutes.reportUser}',
            name: AppRoutes.reportUser,
            builder: (context, state) => SendReportScreen(),
          ),
          GoRoute(
            path: '/${AppRoutes.settingsScreen}',
            name: AppRoutes.settingsScreen,
            builder: (context, state) => SettingsScreen(),
            routes: [
              GoRoute(
                path: '/${AppRoutes.notificationSettings}',
                name: AppRoutes.notificationSettings,
                builder: (context, state) => NotificationSettingsScreen(),
              ),
              GoRoute(
                path: '/${AppRoutes.languageCurrency}',
                name: AppRoutes.languageCurrency,
                builder: (context, state) => const LanguageCurrencyScreen(),
                routes: [
                  GoRoute(
                    path: '/${AppRoutes.language}',
                    name: AppRoutes.language,
                    builder: (context, state) => const LanguageScreen(),
                  ),
                  GoRoute(
                    path: '/${AppRoutes.currency}',
                    name: AppRoutes.currency,
                    builder: (context, state) => const CurrencyScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: '/${AppRoutes.helpCenter}',
                name: AppRoutes.helpCenter,
                builder: (context, state) => HelpCenterScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/${AppRoutes.addListing}',
        name: AppRoutes.addListing,
        builder: (context, state) {
          final dio = context.read<Dio>();
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (_) => AddListingDraftCubit(
                      catalogService: ListingCatalogService(dio),
                    )..loadDraft(),
              ),
              BlocProvider(create: (_) => AddListingMediaCubit()),
              BlocProvider(
                create:
                    (_) => AddListingSubmitCubit(
                      submitService: ListingSubmitService(dio),
                    ),
              ),
            ],
            child: const AddListingScreen(),
          );
        },
      ),
      /*GoRoute(
        path: '/${AppRoutes.addListingPreview}',
        name: AppRoutes.addListingPreview,
        builder: (context, state) {
          final draft = state.extra as AddListingDraft;
          return ListingPreviewScreen(draft: draft);
        },
      ),*/
      GoRoute(
        path: '/${AppRoutes.noInternet}',
        name: AppRoutes.noInternet,
        builder: (context, state) => const NoInternetScreen(),
      ),

      GoRoute(
        path: '/${AppRoutes.login}',
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${AppRoutes.register}',
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/${AppRoutes.forgotPassword}',
        name: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/${AppRoutes.otp}',
        name: AppRoutes.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpScreen(
            email: extra['email'] as String,
            phoneNumber: extra['phoneNumber'] as String,
          );
        },
      ),
      GoRoute(
        path: '/${AppRoutes.changePassword}',
        name: AppRoutes.changePassword,
        builder: (context, state) {
          final token = state.extra as String;
          return ChangePasswordScreen(token: token);
        },
      ),
      // GoRoute(
      //   path: '/${AppRoutes.notification}',
      //   name: AppRoutes.notification,
      //   builder: (context, state) => NotificationsListScreen(),
      // ),
      GoRoute(
        path: '/${AppRoutes.chating}',
        name: AppRoutes.chating,
        builder: (context, state) => const ChatingScreen(),
      ),
      GoRoute(
        path: '/${AppRoutes.productDetails}',
        name: AppRoutes.productDetails,
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailsScreen(product: product);
        },
      ),
    ],

    // Error page
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
  );

  static GoRouter get router => _router;
}
