import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../../core/constants/constants_exports.dart';
import '../../../../../auth/data/models/auth_models.dart';
import '../../../../../products/data/models/product_model.dart';
import '../../../../data/services/profile_service.dart';
import '../../../../profile_exports.dart';
import '../../../../../listing/presentation/bloc/my_listings_cubit.dart';
import '../../../../../listing/presentation/bloc/my_listings_state.dart';
import '../../../widgets/profile_widgets_exports.dart';

class ProfileScreen extends StatelessWidget {
  final bool isMe;
  final UserModel authUser;

  const ProfileScreen({super.key, required this.authUser, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ProfileBloc(context.read<ProfileService>(), authUser)
                ..add(FetchProfileEvent(isMe: isMe)),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            EasyLoading.show(status: 'Loading...');
          } else {
            EasyLoading.dismiss();
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileError)
              return ProfileErrorScreen(message: state.message);
            if (state is ProfileLoaded) {
              final profileData = ProfileViewData.fromAppUser(
                state.appUser,
                type: state.isMe ? ProfileType.private : ProfileType.public,
              );

              final verificationProgress =
                  state.appUser.user.verificationPercentage / 100;
              return Scaffold(
                appBar: AppBar(
                  title: Text(profileData.name),
                  actions: [ProfileAppBarActions(isMe: state.isMe)],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingM,
                    AppSizes.paddingM,
                    AppSizes.paddingM,
                    AppSizes.paddingL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileHeader(
                        profile: profileData,
                        type:
                            state.isMe
                                ? ProfileType.private
                                : ProfileType.public,
                      ),
                      SizedBox(height: AppSizes.paddingS),
                      if (state.isMe)
                        PrivateProfileCompletion(
                          verificationProgress: verificationProgress,
                        ),
                      SizedBox(
                        height:
                            state.isMe
                                ? AppSizes.paddingM
                                : AppSizes.paddingXXS,
                      ),
                      state.isMe
                          ? BlocBuilder<MyListingsCubit, MyListingsState>(
                            builder: (context, listingsState) {
                              final listings =
                                  listingsState is MyListingsSuccess
                                      ? listingsState.listings
                                      : <ProductModel>[];
                              return PrivateProfileWidget(
                                userListings: listings,
                                user: authUser,
                              );
                            },
                          )
                          : PublicProfileWidget(
                            userListings: const [],
                            user: authUser,
                          ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
