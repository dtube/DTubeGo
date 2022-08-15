import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/search/search_event.dart';
import 'package:dtube_go/bloc/search/search_state.dart';
import 'package:dtube_go/bloc/search/search_response_model.dart';
import 'package:dtube_go/bloc/search/search_repository.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitialState()) {
    on<FetchSearchResultsEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String _currentUser = await sec.getUsername();

      emit(SearchLoadingState());
      try {
        SearchResults results = await repository.getSearchResults(
            event.searchQuery,
            event.searchEntity,
            _avalonApiNode,
            _currentUser);

        emit(SearchLoadedState(searchResults: results));
      } catch (e) {
        emit(SearchErrorState(message: e.toString()));
      }
    });

    on<SetSearchInitialState>((event, emit) async {
      emit(SearchInitialState());
    });
  }
}
