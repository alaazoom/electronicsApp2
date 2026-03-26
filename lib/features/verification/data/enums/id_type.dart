import 'package:second_hand_electronics_marketplace/core/constants/app_strings.dart';

enum IdType {
  idCard,
  passport,
  driverLicense;

  String get label {
    switch (this) {
      case IdType.idCard:
        return AppStrings.idCard;
      case IdType.passport:
        return AppStrings.passport;
      case IdType.driverLicense:
        return AppStrings.driversLicense;
    }
  }
}
