import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/accountHistory/accountHistory_event.dart';
import 'package:dtube_togo/bloc/accountHistory/accountHistory_state.dart';
import 'package:dtube_togo/bloc/accountHistory/accountHistory_response_model.dart';
import 'package:dtube_togo/bloc/accountHistory/accountHistory_repository.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class AccountHistoryBloc
    extends Bloc<AccountHistoryEvent, AccountHistoryState> {
  AccountHistoryRepository repository;
  bool isFetching = false;

  AccountHistoryBloc({required this.repository})
      : super(AccountHistoryInitialState());

  // @override

  // AccountHistoryState get initialState => AccountHistoryInitialState();

  @override
  Stream<AccountHistoryState> mapEventToState(
      AccountHistoryEvent event) async* {
    String? _applicationUser = await sec.getUsername();
    String _avalonApiNode = await sec.getNode();
    if (event is FetchAccountHistorysEvent) {
      yield AccountHistoryLoadingState();
      try {
        List<AvalonAccountHistoryItem> accountHistory =
            await repository.getAccountHistory(_avalonApiNode,
                event.accountHistoryTypes, event.username, event.fromBloc);

        yield AccountHistoryLoadedState(
            historyItems: accountHistory, username: event.username);
      } catch (e) {
        yield AccountHistoryErrorState(message: e.toString());
      }
    }
  }
}
