import 'package:equatable/equatable.dart';

abstract class AccountHistoryEvent extends Equatable {}

class FetchAccountHistorysEvent extends AccountHistoryEvent {
  FetchAccountHistorysEvent(
      {required this.accountHistoryTypes, required this.username});
  final List<int> accountHistoryTypes;
  final String username;

  @override
  List<Object> get props => List.empty();
}
