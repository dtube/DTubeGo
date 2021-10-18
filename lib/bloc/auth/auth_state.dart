import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

// general user states
class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignInLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignedInState extends AuthState {
  bool firstSignIn;
  SignedInState({required this.firstSignIn});

  @override
  List<Object> get props => [];
}

class SignInFailedState extends AuthState {
  String message;
  String username;
  SignInFailedState({required this.message, required this.username});

  @override
  List<Object> get props => [message];
}

class ApiNodeOfflineState extends AuthState {
  ApiNodeOfflineState();

  @override
  List<Object> get props => [];
}

class NoSignInInformationFoundState extends AuthState {
  NoSignInInformationFoundState();

  @override
  List<Object> get props => [];
}

class SignOutInitiatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignOutCompleteState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  String message;

  AuthErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class NeverUsedTheAppBeforeState extends AuthState {
  NeverUsedTheAppBeforeState();

  @override
  List<Object> get props => [];
}
