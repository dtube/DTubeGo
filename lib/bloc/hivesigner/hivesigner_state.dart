import 'package:equatable/equatable.dart';

abstract class HivesignerState extends Equatable {}

// general user states
class HivesignerInitialState extends HivesignerState {
  List<Object> get props => [];
}

class HiveSignerAccessTokenLoadingState extends HivesignerState {
  List<Object> get props => [];
}

class HiveSignerAccessTokenValidState extends HivesignerState {
  HiveSignerAccessTokenValidState();

  List<Object> get props => [];
}

class HiveSignerAccessTokenInvalidState extends HivesignerState {
  final String message;

  HiveSignerAccessTokenInvalidState({required this.message});

  List<Object> get props => [message];
}

class HiveSignerNoAccessTokenFoundState extends HivesignerState {
  HiveSignerNoAccessTokenFoundState();

  List<Object> get props => [];
}

class HiveSignerTransactionPreparing extends HivesignerState {
  HiveSignerTransactionPreparing();

  List<Object> get props => [];
}

class HiveSignerTransactionBroadcasting extends HivesignerState {
  HiveSignerTransactionBroadcasting();

  List<Object> get props => [];
}

class HiveSignerTransactionSent extends HivesignerState {
  HiveSignerTransactionSent();

  List<Object> get props => [];
}

class HiveSignerTransactionError extends HivesignerState {
  final String message;
  HiveSignerTransactionError({required this.message});

  List<Object> get props => [message];
}

class HivesignerErrorState extends HivesignerState {
  final String message;

  HivesignerErrorState({required this.message});

  List<Object> get props => [message];
}
