import 'package:dtube_go/bloc/search/search_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class SearchInitialState extends SearchState {
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  List<Object> get props => [];
}

class SearchLoadedState extends SearchState {
  final SearchResults searchResults;

  SearchLoadedState({required this.searchResults});

  List<Object> get props => [searchResults];
}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState({required this.message});

  List<Object> get props => [message];
}
