import 'package:equatable/equatable.dart';

abstract class HelpCenterEvent extends Equatable {
  const HelpCenterEvent();

  @override
  List<Object?> get props => [];
}

class LoadHelpCenter extends HelpCenterEvent {}

class TapContactItem extends HelpCenterEvent {
  final String type; // customer_service, facebook, website, instagram

  const TapContactItem(this.type);

  @override
  List<Object?> get props => [type];
}
