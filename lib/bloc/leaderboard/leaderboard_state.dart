import 'package:dtube_go/bloc/leaderboard/leaderboard_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class LeaderboardState extends Equatable {}

class LeaderboardInitialState extends LeaderboardState {
  List<Object> get props => [];
}

class LeaderboardLoadingState extends LeaderboardState {
  List<Object> get props => [];
}

class LeaderboardLoadedState extends LeaderboardState {
  final List<Leader> leaderboardList;

  LeaderboardLoadedState({required this.leaderboardList});

  List<Object> get props => [leaderboardList];
}

class LeaderboardErrorState extends LeaderboardState {
  final String message;

  LeaderboardErrorState({required this.message});

  List<Object> get props => [message];
}
