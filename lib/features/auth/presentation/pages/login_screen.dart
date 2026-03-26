import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants_exports.dart';
import '../../../../core/widgets/country_picker_prefix.dart';
import '../../../../core/widgets/custom_textfield.dart';

import '../../../../core/widgets/custom_password_field.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../../../../core/widgets/top_in_registration.dart';
import '../../data/auth_validators.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';
import '../widgets/auth_prompt_text.dart';
import '../widgets/social_auth_section.dart';
import '../widgets/remember_me_widget.dart';
import '../../../wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../../listing/presentation/bloc/my_listings_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedCountryCode = AppStrings.palestineDialCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool _isPhoneMode = false;
  bool _rememberMeValue = false;

  @override
  void initState() {
    super.initState();
    _identifierController.addListener(_checkInputType);
  }

  @override
  void dispose() {
    _identifierController.removeListener(_checkInputType);
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkInputType() {
    final text = _identifierController.text;
    if (text.isEmpty) {
      if (_isPhoneMode) setState(() => _isPhoneMode = false);
      return;
    }

    final isNumber = RegExp(r'^[0-9+]+$').hasMatch(text[0]);
    if (isNumber != _isPhoneMode) {
      setState(() => _isPhoneMode = isNumber);
    }
  }

  void _onLoginPressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      String identifier = _identifierController.text.trim();

      if (_isPhoneMode) {
        if (identifier.startsWith('0')) identifier = identifier.substring(1);
        identifier = '$_selectedCountryCode$identifier';
      }

      context.read<AuthCubit>().login(
        email: identifier,
        password: _passwordController.text,
      );
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      NotificationToast.show(
        context,
        AppStrings.missingInfo,
        AppStrings.checkRedFields,
        ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.signIn)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen:
            (previous, current) => ModalRoute.of(context)?.isCurrent == true,
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<WishlistCubit>().clearWishlist();
            context.read<MyListingsCubit>().clearMyListings();
            context.read<WishlistCubit>().fetchWishlist();
            context.read<MyListingsCubit>().fetchMyListings();
            NotificationToast.show(
              context,
              AppStrings.welcomeBack,
              AppStrings.loggedInSuccess,
              ToastType.success,
            );
            context.goNamed(AppRoutes.mainLayout);
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
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TopInRegistrationWidget(
                      title: AppStrings.welcomeBack,
                      subtitle: AppStrings.welcomeBackSubtitle,
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    CustomTextField(
                      label: AppStrings.emailOrPhone,
                      hintText: AppStrings.enterEmailOrPhone,
                      isRequired: true,
                      controller: _identifierController,
                      validator:
                          (val) => AuthValidators.validateIdentifier(
                            val,
                            _isPhoneMode,
                          ),
                      keyboardType:
                          _isPhoneMode
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                      prefix:
                          _isPhoneMode
                              ? CountryPickerPrefix(
                                onChanged: (code) {
                                  setState(() {
                                    _selectedCountryCode = code;
                                  });
                                },
                              )
                              : null,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    CustomPasswordTextField(
                      label: AppStrings.password,
                      hintText: AppStrings.enterPassword,
                      controller: _passwordController,
                      validator: AuthValidators.validatePassword,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    RememberMeWidget(
                      onChanged: (val) => _rememberMeValue = val,
                      onForgotPasswordTapped:
                          () => context.pushNamed(AppRoutes.forgotPassword),
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is AuthLoading ? null : _onLoginPressed,
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(AppStrings.signIn),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    const SocialAuthSection(),
                    const SizedBox(height: AppSizes.paddingL),

                    AuthPromptText(
                      questionText: AppStrings.dontHaveAccount,
                      actionText: AppStrings.signUp,
                      onTap: () => context.goNamed(AppRoutes.register),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
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
