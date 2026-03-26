import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_settings_event.dart';
import 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  NotificationSettingsBloc() : super(const NotificationSettingsState()) {
    on<ToggleMuteAll>((event, emit) {
      emit(
        state.copyWith(
          muteAll: event.value,
          push: !event.value,
          email: !event.value,
          inApp: !event.value,
          listingStatus: !event.value,
          listingReminders: !event.value,
          newMessage: !event.value,
          responseReminders: !event.value,
          discovery: !event.value,
          system: !event.value,
        ),
      );
    });

    on<TogglePush>((event, emit) => emit(state.copyWith(push: event.value)));
    on<ToggleEmail>((event, emit) => emit(state.copyWith(email: event.value)));
    on<ToggleInApp>((event, emit) => emit(state.copyWith(inApp: event.value)));
    on<ToggleListingStatus>(
      (event, emit) => emit(state.copyWith(listingStatus: event.value)),
    );
    on<ToggleListingReminders>(
      (event, emit) => emit(state.copyWith(listingReminders: event.value)),
    );
    on<ToggleNewMessage>(
      (event, emit) => emit(state.copyWith(newMessage: event.value)),
    );
    on<ToggleResponseReminders>(
      (event, emit) => emit(state.copyWith(responseReminders: event.value)),
    );
    on<ToggleDiscovery>(
      (event, emit) => emit(state.copyWith(discovery: event.value)),
    );
    on<ToggleSystem>(
      (event, emit) => emit(state.copyWith(system: event.value)),
    );
  }
}
