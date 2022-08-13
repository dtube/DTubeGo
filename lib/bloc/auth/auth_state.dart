import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

// general user states
class AuthInitialState extends AuthState {
  List<Object> get props => [];
}

class SignInLoadingState extends AuthState {
  List<Object> get props => [];
}

class SignedInState extends AuthState {
  final bool firstSignIn;
  final bool termsAccepted;
  SignedInState({required this.firstSignIn, required this.termsAccepted});

  List<Object> get props => [];
}

class SignInFailedState extends AuthState {
  final String message;
  final String username;

  SignInFailedState({required this.message, required this.username});

  List<Object> get props => [message];
}

class ApiNodeOfflineState extends AuthState {
  ApiNodeOfflineState();

  List<Object> get props => [];
}

class NoSignInInformationFoundState extends AuthState {
  NoSignInInformationFoundState();

  List<Object> get props => [];
}

class SignOutInitiatedState extends AuthState {
  List<Object> get props => [];
}

class SignOutCompleteState extends AuthState {
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({required this.message});

  List<Object> get props => [message];
}

class NeverUsedTheAppBeforeState extends AuthState {
  NeverUsedTheAppBeforeState();

  List<Object> get props => [];
}

class CheckCredentialsValidState extends AuthState {
  CheckCredentialsValidState({required this.publicKey, required this.txTypes});
  final String publicKey;
  final List<int> txTypes;

  List<Object> get props => [publicKey, txTypes];
}

class CheckCredentialsInValidState extends AuthState {
  CheckCredentialsInValidState();

  List<Object> get props => [];
}
