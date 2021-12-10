import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/bloc/rewards/rewards_event.dart';
import 'package:dtube_go/bloc/rewards/rewards_repository.dart';
import 'package:dtube_go/bloc/rewards/rewards_state.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  RewardsRepository repository;

  RewardsBloc({required this.repository}) : super(RewardsInitialState()) {
    on<FetchRewardsEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();
      emit(RewardsLoadingState());
      try {
        List<Reward> rewardList = await repository.getRewards(
            _avalonApiNode, _applicationUser, event.rewardState);

        emit(RewardsLoadedState(rewardList: rewardList));
      } catch (e) {
        emit(RewardsErrorState(message: e.toString()));
      }
    });
  }
}
