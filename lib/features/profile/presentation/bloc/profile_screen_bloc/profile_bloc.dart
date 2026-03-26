import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/data/models/auth_models.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/profile_service.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;
  final UserModel authUser;

  ProfileBloc(this._profileService, this.authUser) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final appUser = await _profileService.getCurrentUserProfile(
        authUser: authUser,
      );
      print("-----App User Data: ${appUser}");
      emit(ProfileLoaded(appUser: appUser, isMe: event.isMe));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final formData = FormData.fromMap(event.updates);

      if (event.avatar != null) {
        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(
              event.avatar!.path,
              filename: 'avatar.jpg',
            ),
          ),
        );
      }

      final updatedProfile = await _profileService.updateProfile(
        formData: formData,
      );

      final appUser = AppUserModel.fromAuthAndProfile(authUser, updatedProfile);

      emit(ProfileLoaded(appUser: appUser, isMe: true));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
