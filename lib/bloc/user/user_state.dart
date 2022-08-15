import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

// general user states
class UserInitialState extends UserState {
  List<Object> get props => [];
}

class UserLoadingState extends UserState {
  List<Object> get props => [];
}

class UserLoadedState extends UserState {
  final User user;
  final bool verified;

  UserLoadedState({required this.user, required this.verified});

  List<Object> get props => [user];
}

class UserDTCVPLoadingState extends UserState {
  List<Object> get props => [];
}

class UserDTCVPLoadedState extends UserState {
  final Map<String, int> vtBalance;
  final int dtcBalance;

  UserDTCVPLoadedState({required this.vtBalance, required this.dtcBalance});

  List<Object> get props => [vtBalance, dtcBalance];
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState({required this.message});

  List<Object> get props => [message];
}
