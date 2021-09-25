import 'package:dtube_go/bloc/rewards/rewards_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class RewardsState extends Equatable {}

class RewardsInitialState extends RewardsState {
  @override
  List<Object> get props => [];
}

class RewardsLoadingState extends RewardsState {
  @override
  List<Object> get props => [];
}

class RewardsLoadedState extends RewardsState {
  List<Reward> rewardList;

  RewardsLoadedState({required this.rewardList});

  @override
  List<Object> get props => [rewardList];
}

class RewardsErrorState extends RewardsState {
  String message;

  RewardsErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
