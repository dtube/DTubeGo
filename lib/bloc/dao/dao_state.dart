import 'package:dtube_go/bloc/dao/dao_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class DaoState extends Equatable {}

class DaoInitialState extends DaoState {
  List<Object> get props => [];
}

class DaoLoadingState extends DaoState {
  List<Object> get props => [];
}

class DaoLoadedState extends DaoState {
  final List<DAOItem> daoList;

  DaoLoadedState({required this.daoList});

  List<Object> get props => [daoList];
}

class ProposalLoadingState extends DaoState {
  List<Object> get props => [];
}

class ProposalLoadedState extends DaoState {
  final DAOItem daoItem;

  ProposalLoadedState({required this.daoItem});

  List<Object> get props => [daoItem];
}

class DaoErrorState extends DaoState {
  final String message;

  DaoErrorState({required this.message});

  List<Object> get props => [message];
}
