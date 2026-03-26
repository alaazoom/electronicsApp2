import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/constants/constants_exports.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../../../../core/widgets/custom_password_field.dart';
import '../../data/auth_validators.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String token;
  const ChangePasswordScreen({super.key, required this.token});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUpdatePressed() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
        token: widget.token,
      );
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.changePasswordTitle),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen:
            (previous, current) => ModalRoute.of(context)?.isCurrent == true,
        listener: (context, state) {
          if (state is AuthPasswordResetSuccess) {
            NotificationToast.show(
              context,
              AppStrings.success,
              AppStrings.passwordResetSuccess,
              ToastType.success,
            );
            context.goNamed(AppRoutes.login);
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
                      AppStrings.createNewPasswordDescription,
                      textAlign: TextAlign.center,
                      style: AppTypography.body16Regular.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXL),

                    CustomPasswordTextField(
                      label: AppStrings.newPassword,
                      hintText: AppStrings.enterNewPassword,
                      controller: _newPasswordController,
                      validator: AuthValidators.validateNewPassword,
                    ),
                    const SizedBox(height: AppSizes.paddingM),

                    CustomPasswordTextField(
                      label: AppStrings.confirmNewPassword,
                      hintText: AppStrings.enterConfirmNewPassword,
                      controller: _confirmPasswordController,
                      validator:
                          (val) => AuthValidators.validateConfirmPassword(
                            val,
                            _newPasswordController.text,
                          ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is AuthLoading ? null : _onUpdatePressed,
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(AppStrings.updatePassword),
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
