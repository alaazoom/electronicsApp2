
part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {
  final bool isMe;
  FetchProfileEvent({required this.isMe});
}
class UpdateProfileEvent extends ProfileEvent {
  final Map<String, dynamic> updates;
  final File? avatar;

  UpdateProfileEvent({required this.updates, this.avatar});
}