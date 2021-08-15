import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class FetchSearchResultsEvent extends SearchEvent {
  FetchSearchResultsEvent(this.searchQuery);
  final String searchQuery;

  @override
  List<Object> get props => List.empty();
}
