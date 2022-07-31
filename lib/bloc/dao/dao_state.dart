import 'package:dtube_go/bloc/dao/dao_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class DaoState extends Equatable {}

class DaoInitialState extends DaoState {
  @override
  List<Object> get props => [];
}

class DaoLoadingState extends DaoState {
  @override
  List<Object> get props => [];
}

class DaoLoadedState extends DaoState {
  List<DAOItem> daoList;

  DaoLoadedState({required this.daoList});

  @override
  List<Object> get props => [daoList];
}

class DaoErrorState extends DaoState {
  String message;

  DaoErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
