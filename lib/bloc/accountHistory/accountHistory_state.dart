import 'package:dtube_go/bloc/accountHistory/accountHistory_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AccountHistoryState extends Equatable {}

class AccountHistoryInitialState extends AccountHistoryState {
  List<Object> get props => [];
}

class AccountHistoryLoadingState extends AccountHistoryState {
  List<Object> get props => [];
}

class AccountHistoryLoadedState extends AccountHistoryState {
  final List<AvalonAccountHistoryItem> historyItems;
  final String username;

  AccountHistoryLoadedState(
      {required this.historyItems, required this.username});

  List<Object> get props => [historyItems];
}

class AccountHistoryErrorState extends AccountHistoryState {
  final String message;

  AccountHistoryErrorState({required this.message});

  List<Object> get props => [message];
}
