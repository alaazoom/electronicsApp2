import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../configs/theme/app_colors.dart';
import '../../../../../../core/constants/constants_exports.dart';
import '../../../../../../core/widgets/custom_textfield.dart';
import '../../../../../../core/widgets/notification_toast.dart';
import '../../../../../auth/data/models/auth_models.dart';
import '../../../../profile_exports.dart';
import '../../../widgets/profile_widgets_exports.dart';

class EditUserProfile extends StatefulWidget {
  final bool isMe;
  final UserModel authUser;

  const EditUserProfile({
    super.key,
    required this.isMe,
    required this.authUser,
  });

  static const double _avatarSizePrivate = 150;
  static const double _editIndicatorSize = 32;

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  static const _warningIcon = AppAssets.popupWarning;
  File? _selectedAvatar;

  Map<String, TextEditingController> controllers = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(FetchProfileEvent(isMe: widget.isMe));
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image == null) return;
    setState(() => _selectedAvatar = File(image.path));
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;
    setState(() => _selectedAvatar = File(image.path));
  }

  Widget _buildAvatar(ProfileViewData profile) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child:
              _selectedAvatar != null
                  ? Image.file(
                    _selectedAvatar!,
                    width: EditUserProfile._avatarSizePrivate,
                    height: EditUserProfile._avatarSizePrivate,
                    fit: BoxFit.cover,
                  )
                  : Image.network(
                    profile.avatar,
                    width: EditUserProfile._avatarSizePrivate,
                    height: EditUserProfile._avatarSizePrivate,
                    fit: BoxFit.cover,
                  ),
        ),
        Positioned(
          bottom: EditUserProfile._avatarSizePrivate * 0.15,
          right: EditUserProfile._avatarSizePrivate * 0.15,
          child: GestureDetector(
            onTap:
                () => showProfileOptionsSheet(
                  context,
                  type: ProfileOptionType.photo,
                  onTakePhoto: _takePhoto,
                  onPickGallery: _pickFromGallery,
                ),
            child: Container(
              width: EditUserProfile._editIndicatorSize,
              height: EditUserProfile._editIndicatorSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.mainColor,
              ),
              child: SvgPicture.asset(AppAssets.editIcon),
            ),
          ),
        ),
      ],
    );
  }

  void _updateProfile(ProfileViewData profile) {
    final updates = {
      'bio': controllers['Bio']?.text,
      'location': controllers['Location']?.text,
      'countryId': 1,
    };

    context.read<ProfileBloc>().add(
      UpdateProfileEvent(updates: updates, avatar: _selectedAvatar),
    );
    // context.pop();
  }

  bool _hasShownError = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          EasyLoading.show(status: 'Loading...');
        } else {
          EasyLoading.dismiss();
        }
        if (state is ProfileError && !_hasShownError) {
          _hasShownError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowStatusPopup(
              context: context,
              icon: _warningIcon,
              title: 'Error',
              description: state.message,
              primaryText: 'Try again',
              onPrimary: () {
                _hasShownError = false;
                context.read<ProfileBloc>().add(
                  FetchProfileEvent(isMe: widget.isMe),
                );
              },
              primaryColor: Theme.of(context).colorScheme.error,
            );
          });
        }

        if (state is ProfileLoaded) {
          _hasShownError = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NotificationToast.show(
              context,
              'Success',
              'Profile loaded successfully',
              ToastType.success,
            );
          });
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final profileData = ProfileViewData.fromAppUser(
            state.appUser,
            type: ProfileType.private,
          );
          if (controllers.isEmpty) {
            controllers = {
              'Full Name': TextEditingController(text: profileData.name),
              'Email': TextEditingController(text: profileData.email ?? ''),
              'Phone Number': TextEditingController(
                text: profileData.phone ?? '',
              ),
              'Location': TextEditingController(
                text: profileData.location ?? '',
              ),
              'Country': TextEditingController(
                text: state.appUser.profile?.country?.nameEn ?? '',
              ),
              'Bio': TextEditingController(text: profileData.bio ?? ''),
            };
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              leading: const BackButton(),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingM,
                0,
                AppSizes.paddingM,
                AppSizes.paddingL,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: _buildAvatar(profileData)),
                  const SizedBox(height: AppSizes.paddingM),
                  ...controllers.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
                      child: CustomTextField(
                        label: e.key,
                        hintText: e.value.text,
                        controller: e.value,
                        readOnly:
                            e.key == 'Full Name' ||
                            e.key == 'Email' ||
                            e.key == 'Phone Number',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          () =>
                              EasyLoading.isShow
                                  ? null
                                  : _updateProfile(profileData),
                      child: const Text("Update Profile"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
