import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {}

class FetchAccountDataEvent extends UserEvent {
  FetchAccountDataEvent({required this.username});
  final String username;

  @override
  List<Object> get props => List.empty();
}

class FetchMyAccountDataEvent extends UserEvent {
  FetchMyAccountDataEvent();

  @override
  List<Object> get props => List.empty();
}

class FetchDTCVPEvent extends UserEvent {
  FetchDTCVPEvent();

  @override
  List<Object> get props => List.empty();
}
