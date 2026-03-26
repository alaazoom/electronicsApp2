class ApiEndpoints {
  static const String baseUrl = 'https://gsg-project-group-6.onrender.com';

  // ==========================================
  // Auth Endpoints
  // ==========================================
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyCode = '/auth/verify-code';
  static const String resendVerificationCode = '/auth/send-verification-code';
  static const String sendResetPasswordCode = '/auth/send-reset-password-code';
  static const String resetPassword = '/auth/reset-password';

  // ==========================================
  // ==========================================
  // Profile Endpoints
  // ==========================================
  static const String getProfile = '/profile'; // GET
  static const String updateProfile = '/profile'; // PATCH

  // ==========================================
  // categories Endpoints
  // ==========================================
  static const String categories = '/categories'; // GET
  static const String adminCategories = '/admin/categories'; // POST
  static String categoryById(String id) => '/categories/$id'; // GET

  // ==========================================
  // Product Endpoints
  // ==========================================
  static const String createPendingProduct = '/products/pending'; // POST
  static const String getMyProducts = '/products/my'; // GET

  // ==========================================
  // Wishlist Endpoints
  // ==========================================
  static const String wishlist = '/wishlist'; // GET / POST
  static String removeFromWishlist(String productId) =>
      '/wishlist/$productId'; // DELETE
}

class ApiKeys {
  // JSON Request/Response Keys
  static const String id = 'id';
  static const String fullName = 'fullName';
  static const String email = 'email';
  static const String phoneNumber = 'phoneNumber';
  static const String password = 'password';
  static const String newPassword = 'newPassword';
  static const String confirmPassword = 'confirmPassword';
  static const String role = 'role';
  static const String isEmailVerified = 'isEmailVerified';
  static const String success = 'success';
  static const String message = 'message';
  static const String data = 'data';
  static const String token = 'token';
  static const String user = 'user';
  static const String otpSent = 'otpSent';
  static const String name = 'name';
  static const String isActive = 'isActive';
  static const String icon = 'icon';
  static const String url = 'url';
  static const String fileName = 'fileName';
  static const String meta = 'meta';
  static const String total = 'total';
  static const String page = 'page';
  static const String lastPage = 'lastPage';
  static const String limit = 'limit';
  static const String code = 'code';
  static const String type = 'type';
  static const String otpType = 'otpType';
  static const String bio = 'bio';
  static const String location = 'location';
  static const String countryId = 'countryId';
  static const String avatarAssetId = 'avatarAssetId';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String lastLogin = 'lastLogin';
  static const String responseTimeMinutes = 'responseTimeMinutes';
  static const String isPhoneVerified = 'isPhoneVerified';
  static const String isIdentityVerified = 'isIdentityVerified';
  static const String userId = 'userId';
  static const String title = 'title';
  static const String categoryId = 'categoryId';
  static const String condition = 'condition';
  static const String price = 'price';
  static const String isNegotiable = 'isNegotiable';
  static const String images = 'images';
  static const String attributes = 'attributes';
  static const String attributeId = 'attributeId';
  static const String value = 'value';
  static const String productId = 'productId';

  // Specific API Values (Enums/Types)
  static const String emailVerification = 'email_verification';
  static const String phoneVerification = 'phone_verification';
  static const String passwordResetType = 'password_reset';
  static const String defaultRoleBuyer = 'buyer';

  // Headers
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer ';
}
