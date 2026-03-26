import 'package:dio/dio.dart';
import '../../../auth/data/models/auth_models.dart';
import '../models/user_model.dart';
import '../../../../core/constants/api_constants.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  Future<AppUserModel> getCurrentUserProfile({
    required UserModel authUser,
  }) async {
    try {
      print("📡 Fetching current user profile...");
      print("🔑 Using token: ${_dio.options.headers[ApiKeys.authorization]}");

      final response = await _dio.get(ApiEndpoints.getProfile);

      print("📦 Server Response: ${response.data}");

      if (response.statusCode == 200) {
        print("✅ Profile fetched successfully");

        final profileJson = response.data['data'];
        final profileModel =
            profileJson != null ? ProfileModel.fromJson(profileJson) : null;

        final appUser = AppUserModel.fromAuthAndProfile(authUser, profileModel);

        return appUser;
      } else {
        final msg =
            response.data[ApiKeys.message] ?? 'Failed to get user profile';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      print("🚨 Dio Error: ${e.response?.data}");
      final errorMessage =
          e.response?.data[ApiKeys.message]?.toString().toLowerCase() ?? '';

      if (e.response?.statusCode == 404 ||
          errorMessage.contains('profile not found') ||
          errorMessage.contains('not found')) {
        print("⚠️ Profile not found (New User). Returning basic Auth info.");
        return AppUserModel.fromAuthAndProfile(authUser, null);
      }

      throw Exception(
        e.response?.data[ApiKeys.message] ?? 'Network error occurred',
      );
    } catch (e) {
      print("❌ Unknown Error: $e");
      throw Exception(e.toString());
    }
  }

  Future<ProfileModel> updateProfile({required FormData formData}) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.updateProfile,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data['data']);
      } else {
        final msg =
            response.data[ApiKeys.message] ?? 'Failed to update profile';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data[ApiKeys.message] ?? 'Network error occurred';
      throw Exception(errorMessage);
    }
  }
}
