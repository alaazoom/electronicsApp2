import 'package:equatable/equatable.dart';

abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();
  @override
  List<Object?> get props => [];
}

class ToggleMuteAll extends NotificationSettingsEvent {
  final bool value;
  const ToggleMuteAll(this.value);

  @override
  List<Object?> get props => [value];
}

class TogglePush extends NotificationSettingsEvent {
  final bool value;
  const TogglePush(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleEmail extends NotificationSettingsEvent {
  final bool value;
  const ToggleEmail(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleInApp extends NotificationSettingsEvent {
  final bool value;
  const ToggleInApp(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleListingStatus extends NotificationSettingsEvent {
  final bool value;
  const ToggleListingStatus(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleListingReminders extends NotificationSettingsEvent {
  final bool value;
  const ToggleListingReminders(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleNewMessage extends NotificationSettingsEvent {
  final bool value;
  const ToggleNewMessage(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleResponseReminders extends NotificationSettingsEvent {
  final bool value;
  const ToggleResponseReminders(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleDiscovery extends NotificationSettingsEvent {
  final bool value;
  const ToggleDiscovery(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleSystem extends NotificationSettingsEvent {
  final bool value;
  const ToggleSystem(this.value);

  @override
  List<Object?> get props => [value];
}
