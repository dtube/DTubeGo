import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

class FetchFeedEvent extends FeedEvent {
  late String feedType;
  FetchFeedEvent({required this.feedType});

  @override
  List<Object> get props => List.empty();
}

// class FetchMyFeedEvent extends FeedEvent {
//   FetchMyFeedEvent();

//   @override
//
//   List<Object> get props => List.empty();
// }

// class FetchHotFeedEvent extends FeedEvent {
//   @override
//
//   List<Object> get props => List.empty();
// }

// class FetchTrendingFeedEvent extends FeedEvent {
//   @override
//
//   List<Object> get props => List.empty();
// }

// class FetchNewFeedEvent extends FeedEvent {
//   @override
//
//   List<Object> get props => List.empty();
// }

class FetchUserFeedEvent extends FeedEvent {
  FetchUserFeedEvent(this.username);
  final String username;
  @override
  List<Object> get props => List.empty();
}
