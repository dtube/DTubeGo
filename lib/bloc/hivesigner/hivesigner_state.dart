import 'package:equatable/equatable.dart';

abstract class HivesignerState extends Equatable {}

// general user states
class HivesignerInitialState extends HivesignerState {
  @override
  List<Object> get props => [];
}

class HiveSignerAccessTokenLoadingState extends HivesignerState {
  @override
  List<Object> get props => [];
}

class HiveSignerAccessTokenValidState extends HivesignerState {
  HiveSignerAccessTokenValidState();

  @override
  List<Object> get props => [];
}

class HiveSignerAccessTokenInvalidState extends HivesignerState {
  String message;

  HiveSignerAccessTokenInvalidState({required this.message});

  @override
  List<Object> get props => [message];
}

class HiveSignerNoAccessTokenFoundState extends HivesignerState {
  HiveSignerNoAccessTokenFoundState();

  @override
  List<Object> get props => [];
}

class HiveSignerTransactionPreparing extends HivesignerState {
  HiveSignerTransactionPreparing();

  @override
  List<Object> get props => [];
}

class HiveSignerTransactionBroadcasting extends HivesignerState {
  HiveSignerTransactionBroadcasting();

  @override
  List<Object> get props => [];
}

class HiveSignerTransactionSent extends HivesignerState {
  HiveSignerTransactionSent();

  @override
  List<Object> get props => [];
}

class HiveSignerTransactionError extends HivesignerState {
  String message;
  HiveSignerTransactionError({required this.message});

  @override
  List<Object> get props => [message];
}

class HivesignerErrorState extends HivesignerState {
  String message;

  HivesignerErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
