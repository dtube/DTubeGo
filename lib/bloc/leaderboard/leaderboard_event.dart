import 'package:equatable/equatable.dart';

abstract class LeaderboardEvent extends Equatable {}

class FetchLeaderboardEvent extends LeaderboardEvent {
  FetchLeaderboardEvent();

  @override
  List<Object> get props => List.empty();
}
