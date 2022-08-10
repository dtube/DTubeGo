import 'package:dtube_go/bloc/leaderboard/leaderboard_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class LeaderboardState extends Equatable {}

class LeaderboardInitialState extends LeaderboardState {
  @override
  List<Object> get props => [];
}

class LeaderboardLoadingState extends LeaderboardState {
  @override
  List<Object> get props => [];
}

class LeaderboardLoadedState extends LeaderboardState {
  List<Leader> leaderboardList;

  LeaderboardLoadedState({required this.leaderboardList});

  @override
  List<Object> get props => [leaderboardList];
}

class LeaderboardErrorState extends LeaderboardState {
  String message;

  LeaderboardErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
