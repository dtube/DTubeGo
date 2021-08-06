import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_togo/bloc/rewards/rewards_event.dart';
import 'package:dtube_togo/bloc/rewards/rewards_repository.dart';
import 'package:dtube_togo/bloc/rewards/rewards_state.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  RewardsRepository repository;

  RewardsBloc({required this.repository}) : super(RewardsInitialState());

  // @override

  // RewardsState get initialState => RewardsInitialState();

  @override
  Stream<RewardsState> mapEventToState(RewardsEvent event) async* {
    String _avalonApiNode = await sec.getNode();
    String? _applicationUser = await sec.getUsername();
    if (event is FetchRewardsEvent) {
      yield RewardsLoadingState();
      try {
        List<Reward> rewardList = await repository.getRewards(
            _avalonApiNode, _applicationUser, event.rewardState);

        yield RewardsLoadedState(rewardList: rewardList);
      } catch (e) {
        yield RewardsErrorState(message: e.toString());
      }
    }
  }
}
