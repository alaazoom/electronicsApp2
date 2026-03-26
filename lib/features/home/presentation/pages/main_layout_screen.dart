import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/custom_bottom_navbar.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_routes.dart';
import 'package:second_hand_electronics_marketplace/features/categories/presentation/pages/categories_tab.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/screens/all_chats_screen.dart';
import 'package:second_hand_electronics_marketplace/features/home/presentation/pages/home_tab.dart';
import 'package:second_hand_electronics_marketplace/features/profile/presentation/pages/user_profile/user_profile_screens/profile_screen.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_states.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../../listing/presentation/bloc/my_listings_cubit.dart';
import 'not_logged_in.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<WishlistCubit>().fetchWishlist();
      context.read<MyListingsCubit>().fetchMyListings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen:
          (previous, current) => ModalRoute.of(context)?.isCurrent == true,
      listener: (context, state) {
        if (state is AuthLoading) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }

        if (state is AuthSuccess) {
          context.read<WishlistCubit>().fetchWishlist();
          context.read<MyListingsCubit>().fetchMyListings();
          NotificationToast.show(
            context,
            AppStrings.welcomeBack,
            AppStrings.loggedInSuccess,
            ToastType.success,
          );
          context.goNamed(AppRoutes.mainLayout);
        } else if (state is AuthLogOut) {
          context.read<WishlistCubit>().clearWishlist();
          context.read<MyListingsCubit>().clearMyListings();
        } else if (state is AuthFailure) {
          NotificationToast.show(
            context,
            AppStrings.loginFailed,
            state.message,
            ToastType.error,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(body: SizedBox());
        }

        final authUser = state is AuthSuccess ? state.response.user : null;

        final screens = [
          const HomeTab(), // Home (Index 0)
          const CategoriesTab(), // Categories (Index 1)
          const ChatsScreen(), // Chat (Index 2)
          authUser != null
              ? ProfileScreen(
                key: ValueKey(
                  '${authUser.isPhoneVerified}_${authUser.isEmailVerified}_${authUser.isIdentityVerified}',
                ),
                authUser: authUser,
                isMe: true,
              )
              : const NotLoggedInScreen(), // Profile (Index 3)
        ];

        return Scaffold(
          body: screens[_currentIndex],
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onAddTap: () {
              context.pushNamed(AppRoutes.addListing);
            },
          ),
        );
      },
    );
  }
}
