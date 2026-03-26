import '../../../../core/constants/api_constants.dart';

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.fullName: fullName,
      ApiKeys.email: email,
      ApiKeys.phoneNumber: phoneNumber,
      ApiKeys.password: password,
    };
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isIdentityVerified;
  final DateTime? lastLogin;
  final DateTime? createdAt; // optional, لو حابب تعرض Member since

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isIdentityVerified,
    this.lastLogin,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      fullName: json[ApiKeys.fullName] ?? '',
      email: json[ApiKeys.email] ?? '',
      phoneNumber: json[ApiKeys.phoneNumber] ?? '',
      role: json[ApiKeys.role] ?? ApiKeys.defaultRoleBuyer,
      isEmailVerified: json[ApiKeys.isEmailVerified] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isIdentityVerified: json['isIdentityVerified'] ?? false,
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.fullName: fullName,
      ApiKeys.email: email,
      ApiKeys.phoneNumber: phoneNumber,
      ApiKeys.role: role,
      ApiKeys.isEmailVerified: isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isIdentityVerified': isIdentityVerified,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, role: $role, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, isIdentityVerified: $isIdentityVerified, lastLogin: $lastLogin, createdAt: $createdAt)';
  }
}

extension UserVerification on UserModel {
  /// نسبة التحقق: من 0 إلى 100
  double get verificationPercentage {
    int verifiedCount = 0;
    if (isEmailVerified) verifiedCount++;
    if (isPhoneVerified) verifiedCount++;
    if (isIdentityVerified) verifiedCount++;

    return (verifiedCount / 3) * 100;
  }

  /// حالة عامة: Fully / Partially / Not Verified
  String get verificationStatus {
    final percent = verificationPercentage;
    if (percent == 100) return 'Fully Verified';
    if (percent >= 50) return 'Partially Verified';
    return 'Not Verified';
  }
}

class AuthResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserModel? user;
  final String? otpSentMessage;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.token,
    this.user,
    this.otpSentMessage,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json[ApiKeys.data] ?? {};

    return AuthResponseModel(
      success: json[ApiKeys.success] ?? false,
      message: json[ApiKeys.message] ?? '',
      token: data[ApiKeys.token] ?? '',
      user:
          data[ApiKeys.user] != null
              ? UserModel.fromJson(data[ApiKeys.user])
              : null,
      otpSentMessage: data[ApiKeys.otpSent],
    );
  }
}
