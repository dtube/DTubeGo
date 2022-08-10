import 'package:equatable/equatable.dart';

abstract class DaoEvent extends Equatable {}

class FetchDaoEvent extends DaoEvent {
  late String daoState;
  late String daoType;
  FetchDaoEvent({required this.daoState, required this.daoType});

  @override
  List<Object> get props => List.empty();
}

class FetchProsposalEvent extends DaoEvent {
  late int id;
  FetchProsposalEvent({required this.id});

  @override
  List<Object> get props => List.empty();
}
