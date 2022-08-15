import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/leaderboard/leaderboard_bloc_full.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardRepository repository;

  LeaderboardBloc({required this.repository})
      : super(LeaderboardInitialState()) {
    on<FetchLeaderboardEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();

      emit(LeaderboardLoadingState());
      try {
        List<Leader> leaderboardList =
            await repository.getLeaderboard(_avalonApiNode);

        emit(LeaderboardLoadedState(leaderboardList: leaderboardList));
      } catch (e) {
        emit(LeaderboardErrorState(message: e.toString()));
      }
    });
  }
}
