import 'package:dtube_togo/bloc/search/search_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class SearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadedState extends SearchState {
  SearchResults searchResults;

  SearchLoadedState({required this.searchResults});

  @override
  List<Object> get props => [searchResults];
}

class SearchErrorState extends SearchState {
  String message;

  SearchErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
