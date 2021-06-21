import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class AppStartedEvent extends AuthEvent {
  AppStartedEvent();
  @override
  List<Object> get props => List.empty();
}

class SignOutEvent extends AuthEvent {
  SignOutEvent();
  @override
  List<Object> get props => List.empty();
}

class SignInWithCredentialsEvent extends AuthEvent {
  SignInWithCredentialsEvent(this.username, this.privateKey);
  final String username;
  final String privateKey;
  @override
  List<Object> get props => List.empty();
}
