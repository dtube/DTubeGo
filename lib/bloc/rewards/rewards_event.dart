import 'package:equatable/equatable.dart';

abstract class RewardsEvent extends Equatable {}

class FetchRewardsEvent extends RewardsEvent {
  late String rewardState;
  FetchRewardsEvent({required this.rewardState});

  @override
  List<Object> get props => List.empty();
}
