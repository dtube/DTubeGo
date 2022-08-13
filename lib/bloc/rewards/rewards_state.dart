import 'package:dtube_go/bloc/rewards/rewards_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class RewardsState extends Equatable {}

class RewardsInitialState extends RewardsState {
  List<Object> get props => [];
}

class RewardsLoadingState extends RewardsState {
  List<Object> get props => [];
}

class RewardsLoadedState extends RewardsState {
  final List<Reward> rewardList;

  RewardsLoadedState({required this.rewardList});

  List<Object> get props => [rewardList];
}

class RewardsErrorState extends RewardsState {
  final String message;

  RewardsErrorState({required this.message});

  List<Object> get props => [message];
}
