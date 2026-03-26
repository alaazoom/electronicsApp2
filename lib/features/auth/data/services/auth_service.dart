import 'package:dio/dio.dart';
import '../models/auth_models.dart';
import '../../../../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      print("📦 Server Response: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception(
          response.data[ApiKeys.message] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      print("🚨 Server Error Data: ${e.response?.data}");
      final errorMessage =
          e.response?.data[ApiKeys.message] ?? 'Network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: {
          ApiKeys.newPassword: newPassword,
          ApiKeys.confirmPassword: confirmPassword,
        },
        options: Options(
          headers: {ApiKeys.authorization: '${ApiKeys.bearer}$token'},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendResetPasswordCode({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.sendResetPasswordCode,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {ApiKeys.email: email, ApiKeys.password: password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.data[ApiKeys.message] ?? 'Login failed');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data[ApiKeys.message] ?? 'Network error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<Response> verifyCode({
    required String code,
    String? email,
    String? phone,
    String? type,
  }) async {
    try {
      final Map<String, dynamic> data = {ApiKeys.code: code};

      if (email != null) {
        data[ApiKeys.email] = email;
        data[ApiKeys.type] = type ?? ApiKeys.emailVerification;
      } else if (phone != null) {
        data[ApiKeys.phoneNumber] = phone;
        data[ApiKeys.type] = type ?? ApiKeys.phoneVerification;
      }
      if (type != null) data[ApiKeys.type] = type;

      final response = await _dio.post(ApiEndpoints.verifyCode, data: data);
      return response;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data[ApiKeys.message] ?? 'Verification failed';
      throw Exception(errorMessage);
    }
  }

  Future<void> resendCode({bool isEmail = true}) async {
    try {
      await _dio.post(
        ApiEndpoints.resendVerificationCode,
        data: {
          ApiKeys.otpType:
              isEmail ? ApiKeys.emailVerification : ApiKeys.phoneVerification,
        },
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data[ApiKeys.message] ?? 'Failed to resend code';
      throw Exception(errorMessage);
    }
  }

  void updateHeader(String token) {
    _dio.options.headers[ApiKeys.authorization] = '${ApiKeys.bearer}$token';
  }
}
