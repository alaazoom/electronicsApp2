import '../enums/id_type.dart';

class VerificationFormData {
  IdType? idType;
  String? frontIdPath;
  String? backIdPath;
  String? selfiePath;

  VerificationFormData({
    this.idType,
    this.frontIdPath,
    this.backIdPath,
    this.selfiePath,
  });

  bool get isComplete =>
      idType != null &&
      frontIdPath != null &&
      backIdPath != null &&
      selfiePath != null;
}
