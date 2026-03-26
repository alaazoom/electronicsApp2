import '../../../auth/data/models/auth_models.dart';

class ProfileModel {
  final int id;
  final int userId;
  final String? bio;
  final String? location;
  final int? avatarAssetId;
  final int? countryId;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CountryModel? country;
  final AvatarAssetModel? avatarAsset;
  ProfileModel({
    required this.id,
    required this.userId,
    this.bio,
    this.location,
    this.avatarAssetId,
    this.countryId,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.avatarAsset,
    this.country,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id:
        json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
    userId:
        json['userId'] is int
            ? json['userId']
            : int.tryParse(json['userId'].toString()) ?? 0,
    bio: json['bio'],
    location: json['location'],
    avatarAssetId:
        json['avatarAssetId'] is int
            ? json['avatarAssetId']
            : int.tryParse(json['avatarAssetId']?.toString() ?? ''),
    avatarAsset:
        json['avatarAsset'] != null
            ? AvatarAssetModel.fromJson(json['avatarAsset'])
            : null,
    countryId:
        json['countryId'] is int
            ? json['countryId']
            : int.tryParse(json['countryId']?.toString() ?? ''),
    country:
        json['country'] != null ? CountryModel.fromJson(json['country']) : null,
    latitude:
        json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
    longitude:
        json['longitude'] != null
            ? (json['longitude'] as num).toDouble()
            : null,
    createdAt:
        json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    updatedAt:
        json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
  );

  @override
  String toString() {
    return 'ProfileModel(id: $id, userId: $userId, bio: $bio, location: $location, avatarAssetId: $avatarAssetId, countryId: $countryId, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class AppUserModel {
  final UserModel user;
  final ProfileModel? profile;

  AppUserModel({required this.user, this.profile});

  // fromJson
  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    final profileJson = json['profile'];
    final user = UserModel.fromJson(userJson);
    final profile =
        profileJson != null ? ProfileModel.fromJson(profileJson) : null;
    return AppUserModel(user: user, profile: profile);
  }

  factory AppUserModel.fromAuthAndProfile(
    UserModel user,
    ProfileModel? profile,
  ) => AppUserModel(user: user, profile: profile);

  @override
  String toString() {
    return 'AppUserModel(user: $user, profile: $profile)';
  }
}

class AvatarAssetModel {
  final int id;
  final String storageProviderName;
  final String fileId;
  final String type;
  final String url;
  final String fileName;
  final double? fileSizeInKB;
  final String fileType;
  final int? width;
  final int? height;

  AvatarAssetModel({
    required this.id,
    required this.storageProviderName,
    required this.fileId,
    required this.type,
    required this.url,
    required this.fileName,
    this.fileSizeInKB,
    required this.fileType,
    this.width,
    this.height,
  });

  factory AvatarAssetModel.fromJson(Map<String, dynamic> json) =>
      AvatarAssetModel(
        id:
            json['id'] is int
                ? json['id']
                : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        storageProviderName: json['storageProviderName'] ?? '',
        fileId: json['fileId'] ?? '',
        type: json['type'] ?? '',
        url: json['url'] ?? '',
        fileName: json['fileName'] ?? '',
        fileSizeInKB:
            json['fileSizeInKB'] != null
                ? (json['fileSizeInKB'] is num
                    ? (json['fileSizeInKB'] as num).toDouble()
                    : double.tryParse(json['fileSizeInKB'].toString()))
                : null,
        fileType: json['fileType'] ?? '',
        width:
            json['width'] is int
                ? json['width']
                : int.tryParse(json['width']?.toString() ?? ''),
        height:
            json['height'] is int
                ? json['height']
                : int.tryParse(json['height']?.toString() ?? ''),
      );
}

class CountryModel {
  final int id;
  final String nameEn;
  final String nameAr;
  final String isoCode;
  final String currencySymbolEn;
  final String currencySymbolAr;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CountryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.isoCode,
    required this.currencySymbolEn,
    required this.currencySymbolAr,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id:
        json['id'] is int
            ? json['id']
            : int.tryParse(json['id'].toString()) ?? 0,
    nameEn: json['nameEn'] ?? '',
    nameAr: json['nameAr'] ?? '',
    isoCode: json['isoCode'] ?? '',
    currencySymbolEn: json['currencySymbolEn'] ?? '',
    currencySymbolAr: json['currencySymbolAr'] ?? '',
    isActive: json['isActive'] ?? false,
    createdAt:
        json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    updatedAt:
        json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
  );

  @override
  String toString() {
    return 'CountryModel(id: $id, nameEn: $nameEn, nameAr: $nameAr, isoCode: $isoCode, currencySymbolEn: $currencySymbolEn, currencySymbolAr: $currencySymbolAr, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
