import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants_exports.dart';
import '../../../../core/widgets/custom_password_field.dart';
import '../../../../core/widgets/custom_phone_field.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../../../../core/widgets/top_in_registration.dart';
import '../../data/auth_validators.dart';
import '../widgets/social_auth_section.dart';
import '../widgets/auth_prompt_text.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';
import '../widgets/terms_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedCountryCode = AppStrings.palestineDialCode;
  bool _isTermsAccepted = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (!_isTermsAccepted) {
      NotificationToast.show(
        context,
        AppStrings.termsRequired,
        AppStrings.agreeToTerms,
        ToastType.warning,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      String cleanPhone = _phoneController.text.trim();
      if (cleanPhone.startsWith('0')) cleanPhone = cleanPhone.substring(1);
      final fullPhoneNumber = '$_selectedCountryCode$cleanPhone';

      context.read<AuthCubit>().register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: fullPhoneNumber,
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
      appBar: AppBar(title: const Text(AppStrings.signUp)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen:
            (previous, current) => ModalRoute.of(context)?.isCurrent == true,
        listener: (context, state) {
          if (state is AuthSuccess) {
            NotificationToast.show(
              context,
              AppStrings.success,
              AppStrings.registerSuccessOTP,
              ToastType.success,
            );

            String cleanPhone = _phoneController.text.trim();
            if (cleanPhone.startsWith('0'))
              cleanPhone = cleanPhone.substring(1);

            context.pushNamed(
              AppRoutes.otp,
              extra: {
                AppKeys.email: _emailController.text.trim(),
                AppKeys.phone: '$_selectedCountryCode$cleanPhone',
              },
            );
          } else if (state is AuthFailure) {
            NotificationToast.show(
              context,
              AppStrings.registerFailed,
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
                  children: [
                    TopInRegistrationWidget(
                      title: AppStrings.welcome,
                      subtitle: AppStrings.createAccountSubtitle,
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    CustomTextField(
                      label: AppStrings.fullName,
                      hintText: AppStrings.enterFullName,
                      isRequired: true,
                      controller: _nameController,
                      validator: AuthValidators.validateName,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    CustomTextField(
                      label: AppStrings.email,
                      hintText: AppStrings.enterEmail,
                      isRequired: true,
                      controller: _emailController,
                      validator: AuthValidators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    CustomPhoneField(
                      controller: _phoneController,
                      validator: AuthValidators.validatePhone,
                      onCountryChanged: (code) => _selectedCountryCode = code,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    CustomPasswordTextField(
                      controller: _passwordController,
                      validator: AuthValidators.validateStrongPassword,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    TermsWidget(
                      onChanged: (val) => _isTermsAccepted = val,
                      onTermsTapped: () => print("Open Terms Page"),
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is AuthLoading ? null : _onRegisterPressed,
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(AppStrings.register),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    const SocialAuthSection(),
                    const SizedBox(height: AppSizes.paddingL),

                    AuthPromptText(
                      questionText: AppStrings.alreadyHaveAccount,
                      actionText: AppStrings.signIn,
                      onTap: () => context.goNamed(AppRoutes.login),
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
