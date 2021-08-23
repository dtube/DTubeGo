import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class FetchSearchResultsEvent extends SearchEvent {
  FetchSearchResultsEvent(
      {required this.searchQuery, required this.searchEntity});
  final String searchQuery;
  final String searchEntity;

  @override
  List<Object> get props => List.empty();
}

class SetSearchInitialState extends SearchEvent {
  SetSearchInitialState();
  @override
  List<Object> get props => List.empty();
}
