import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/constants/constants_exports.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/country_picker_prefix.dart';
import '../../data/auth_validators.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String _selectedCountryCode =
      AppStrings.palestineDialCode; // المتغير الذي أضفتيه '+970'
  bool _isPhoneMode = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isPhoneMode = !_isPhoneMode;
      _identifierController.clear();
      _autovalidateMode = AutovalidateMode.disabled;
    });
  }

  void _onSendCodePressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      String identifier = _identifierController.text.trim();

      if (_isPhoneMode) {
        if (identifier.startsWith('0')) identifier = identifier.substring(1);
        identifier = '$_selectedCountryCode$identifier';
      }

      context.read<AuthCubit>().sendResetPasswordCode(
        identifier: identifier,
        isPhone: _isPhoneMode,
      );
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.forgetPasswordTitle),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen:
            (previous, current) => ModalRoute.of(context)?.isCurrent == true,
        listener: (context, state) {
          if (state is AuthCodeSent) {
            NotificationToast.show(
              context,
              AppStrings.success,
              AppStrings.codeSentSuccess,
              ToastType.success,
            );

            context.pushNamed(
              AppRoutes.otp,
              extra: {
                AppKeys.email:
                    _isPhoneMode ? '' : _identifierController.text.trim(),
                AppKeys.phone:
                    _isPhoneMode
                        ? '$_selectedCountryCode${_identifierController.text.trim().replaceFirst(RegExp(r'^0+'), '')}'
                        : '',
                'isForPasswordReset': true,
              },
            );
          } else if (state is AuthFailure) {
            NotificationToast.show(
              context,
              AppStrings.error,
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
                    const SizedBox(height: AppSizes.paddingM),
                    Text(
                      _isPhoneMode
                          ? AppStrings.enterPhoneToReceiveCode
                          : AppStrings.enterEmailToReceiveCode,
                      textAlign: TextAlign.center,
                      style: AppTypography.body16Regular.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXL),

                    CustomTextField(
                      label:
                          _isPhoneMode
                              ? AppStrings.phoneNumber
                              : AppStrings.email,
                      hintText:
                          _isPhoneMode
                              ? AppStrings.enterPhoneNumber
                              : AppStrings.enterEmail,
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
                                onChanged:
                                    (code) => _selectedCountryCode = code,
                              )
                              : null,
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is AuthLoading ? null : _onSendCodePressed,
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(AppStrings.sendCode),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    TextButton(
                      onPressed: _toggleMode,
                      child: Text(
                        _isPhoneMode
                            ? AppStrings.resetViaEmail
                            : AppStrings.resetViaPhone,
                        style: AppTypography.body14Regular.copyWith(
                          color: context.colors.hint,
                        ),
                      ),
                    ),
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
