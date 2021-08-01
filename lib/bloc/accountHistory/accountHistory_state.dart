import 'package:dtube_togo/bloc/accountHistory/accountHistory_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AccountHistoryState extends Equatable {}

class AccountHistoryInitialState extends AccountHistoryState {
  @override
  List<Object> get props => [];
}

class AccountHistoryLoadingState extends AccountHistoryState {
  @override
  List<Object> get props => [];
}

class AccountHistoryLoadedState extends AccountHistoryState {
  List<AvalonAccountHistoryItem> historyItems;

  AccountHistoryLoadedState({required this.historyItems});

  @override
  List<Object> get props => [historyItems];
}

class AccountHistoryErrorState extends AccountHistoryState {
  String message;

  AccountHistoryErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
