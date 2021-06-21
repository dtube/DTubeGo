import 'package:dtube_togo/bloc/user/user_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

// general user states
class UserInitialState extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoadedState extends UserState {
  User user;

  UserLoadedState({required this.user});

  @override
  List<Object> get props => [user];
}

class UserDTCVPLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

class UserDTCVPLoadedState extends UserState {
  Map<String, int> vtBalance;
  int dtcBalance;

  UserDTCVPLoadedState({required this.vtBalance, required this.dtcBalance});

  @override
  List<Object> get props => [vtBalance, dtcBalance];
}

class UserErrorState extends UserState {
  String message;

  UserErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
