import '../../../core/constants/constants_exports.dart';

class AuthValidators {
  static String? validateIdentifier(String? value, bool isPhoneMode) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.valEnterEmailOrPhone;

    if (isPhoneMode) {
      String cleanPhone = value.trim();
      if (cleanPhone.length < 9 || cleanPhone.length > 10)
        return AppStrings.valInvalidPhone;
      if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone))
        return AppStrings.valInvalidPhone;
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) return AppStrings.valInvalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.valEnterPassword;
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.valEnterFullName;
    if (RegExp(r'[0-9]').hasMatch(value)) return AppStrings.valNameNoNumbers;
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.valEnterEmailOrPhone;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return AppStrings.valInvalidEmail;
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty)
      return AppStrings.valEnterEmailOrPhone;
    String cleanPhone = value.trim();
    if (cleanPhone.length < 9 || cleanPhone.length > 10)
      return AppStrings.valPhoneLength;
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone))
      return AppStrings.valPhoneDigitsOnly;
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.valEnterPassword;
    if (value.length < 8) return AppStrings.valPasswordLength;
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    if (!hasUppercase || !hasLowercase || !hasDigits)
      return AppStrings.valPasswordComplexity;
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.valEnterPassword;
    if (value.length < 8) return AppStrings.valPasswordLength;
    if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value))
      return AppStrings.valNewPasswordComplexity;
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) return AppStrings.valConfirmPassword;
    if (value != originalPassword) return AppStrings.valPasswordsNotMatch;
    return null;
  }
}
