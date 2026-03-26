import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';

import '../../../../configs/theme/theme_exports.dart';
import '../../../../core/constants/constants_exports.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/notification_toast.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_states.dart';
import '../../../wishlist/presentation/cubits/wishlist_cubit.dart';
import '../../../listing/presentation/bloc/my_listings_cubit.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;
  final bool isForPasswordReset;

  const OtpScreen({
    super.key,
    required this.email,
    required this.phoneNumber,
    this.isForPasswordReset = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isEmailVerification = false;

  @override
  void initState() {
    super.initState();
    _isEmailVerification = widget.email.isNotEmpty;
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verify() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_pinController.text.length == 4) {
      context.read<AuthCubit>().verifyCode(
        code: _pinController.text,
        email: _isEmailVerification ? widget.email : null,
        phone: _isEmailVerification ? null : widget.phoneNumber,
        type: widget.isForPasswordReset ? "password_reset" : null,
      );
    } else {
      NotificationToast.show(
        context,
        AppStrings.invalidCode,
        AppStrings.enter4DigitCode,
        ToastType.warning,
      );
    }
  }

  void _switchVerificationMethod() {
    setState(() {
      _isEmailVerification = !_isEmailVerification;
      _pinController.clear();
    });
    context.read<AuthCubit>().resendCode(isEmail: _isEmailVerification);
  }

  @override
  Widget build(BuildContext context) {
    final String destination =
        _isEmailVerification
            ? StringUtils.maskData(widget.email)
            : StringUtils.maskData(widget.phoneNumber);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTypography.h3_18Medium.copyWith(color: context.colors.text),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.hint),
        borderRadius: BorderRadius.circular(12),
        color: context.colors.surface,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: context.colors.mainColor, width: 1),
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.verifyCodeTitle)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen:
            (previous, current) => ModalRoute.of(context)?.isCurrent == true,
        listener: (context, state) {
          if (state is AuthSuccess) {
            NotificationToast.show(
              context,
              AppStrings.verified,
              AppStrings.accountVerifiedSuccess,
              ToastType.success,
            );

            if (widget.isForPasswordReset) {
              final token = state.response.token;

              context.pushReplacementNamed(
                AppRoutes.changePassword,
                extra: token,
              );
            } else {
              context.read<WishlistCubit>().clearWishlist();
              context.read<MyListingsCubit>().clearMyListings();
              context.read<WishlistCubit>().fetchWishlist();
              context.read<MyListingsCubit>().fetchMyListings();
              context.goNamed(AppRoutes.mainLayout);
            }
          } else if (state is AuthCodeSent) {
            NotificationToast.show(
              context,
              AppStrings.sent,
              "${AppStrings.codeSentTo}$destination",
              ToastType.success,
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
          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${AppStrings.enterCodeWeSentTo}$destination',
                  textAlign: TextAlign.center,
                  style: AppTypography.h3_18Regular.copyWith(
                    color: context.colors.text,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),

                Pinput(
                  length: 4,
                  controller: _pinController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) => _verify(),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading ? null : _verify,
                    child:
                        state is AuthLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(AppStrings.verify),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.didntReceiveCode,
                      style: AppTypography.body16Regular.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => context.read<AuthCubit>().resendCode(
                            isEmail: _isEmailVerification,
                          ),
                      child: Text(
                        AppStrings.resend,
                        style: AppTypography.body16Medium.copyWith(
                          color: context.colors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingM),

                GestureDetector(
                  onTap: _switchVerificationMethod,
                  child: Text(
                    _isEmailVerification
                        ? AppStrings.sendCodeViaPhone
                        : AppStrings.sendCodeViaEmail,
                    style: AppTypography.body14Regular.copyWith(
                      color: context.colors.hint,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
