import '../../data/models/auth_models.dart';

abstract class AuthState {}

class AuthCodeSent extends AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthResponseModel response;
  AuthSuccess(this.response);
}
class AuthLogOut extends AuthState {}


class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
