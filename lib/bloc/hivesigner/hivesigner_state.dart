import 'package:equatable/equatable.dart';

abstract class HivesignerState extends Equatable {}

// general user states
class HivesignerInitialState extends HivesignerState {
  @override
  List<Object> get props => [];
}

class AccessTokenLoadingState extends HivesignerState {
  @override
  List<Object> get props => [];
}

class AccessTokenValidState extends HivesignerState {
  AccessTokenValidState();

  @override
  List<Object> get props => [];
}

class AccessTokenInvalidState extends HivesignerState {
  String message;

  AccessTokenInvalidState({required this.message});

  @override
  List<Object> get props => [message];
}

class NoAccessTokenFoundState extends HivesignerState {
  NoAccessTokenFoundState();

  @override
  List<Object> get props => [];
}

class HivesignerErrorState extends HivesignerState {
  String message;

  HivesignerErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
