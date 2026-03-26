class CityModel {
  final String id;
  final String nameEn;
  final String nameAr;
  final double latitude;
  final double longitude;

  CityModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString() ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      latitude:
          json['latitude'] != null ? (json['latitude'] as num).toDouble() : 0.0,
      longitude:
          json['longitude'] != null
              ? (json['longitude'] as num).toDouble()
              : 0.0,
    );
  }
}
