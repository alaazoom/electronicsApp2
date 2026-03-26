import 'package:equatable/equatable.dart';

class NotificationSettingsState extends Equatable {
  final bool muteAll;
  final bool push;
  final bool email;
  final bool inApp;
  final bool listingStatus;
  final bool listingReminders;
  final bool newMessage;
  final bool responseReminders;
  final bool discovery;
  final bool system;

  const NotificationSettingsState({
    this.muteAll = false,
    this.push = true,
    this.email = false,
    this.inApp = false,
    this.listingStatus = true,
    this.listingReminders = true,
    this.newMessage = true,
    this.responseReminders = true,
    this.discovery = true,
    this.system = true,
  });

  NotificationSettingsState copyWith({
    bool? muteAll,
    bool? push,
    bool? email,
    bool? inApp,
    bool? listingStatus,
    bool? listingReminders,
    bool? newMessage,
    bool? responseReminders,
    bool? discovery,
    bool? system,
  }) {
    return NotificationSettingsState(
      muteAll: muteAll ?? this.muteAll,
      push: push ?? this.push,
      email: email ?? this.email,
      inApp: inApp ?? this.inApp,
      listingStatus: listingStatus ?? this.listingStatus,
      listingReminders: listingReminders ?? this.listingReminders,
      newMessage: newMessage ?? this.newMessage,
      responseReminders: responseReminders ?? this.responseReminders,
      discovery: discovery ?? this.discovery,
      system: system ?? this.system,
    );
  }

  @override
  List<Object> get props => [
    muteAll,
    push,
    email,
    inApp,
    listingStatus,
    listingReminders,
    newMessage,
    responseReminders,
    discovery,
    system,
  ];
}
