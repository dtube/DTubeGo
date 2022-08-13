import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

class FetchFeedEvent extends FeedEvent {
  final String feedType;
  final String? fromAuthor;
  final String? fromLink;
  FetchFeedEvent({required this.feedType, this.fromAuthor, this.fromLink});

  @override
  List<Object> get props => List.empty();
}

class FetchMomentsEvent extends FeedEvent {
  final String feedType; // NewFeed or MyFeed
  FetchMomentsEvent({required this.feedType});

  @override
  List<Object> get props => List.empty();
}

class FetchTagSearchResults extends FeedEvent {
  final String tags; // NewFeed or MyFeed
  FetchTagSearchResults({required this.tags});

  @override
  List<Object> get props => List.empty();
}

class FetchUserFeedEvent extends FeedEvent {
  final String username;
  final String? fromAuthor;
  final String? fromLink;
  FetchUserFeedEvent({required this.username, this.fromAuthor, this.fromLink});

  @override
  List<Object> get props => List.empty();
}

class FetchMomentsOfUserEvent extends FeedEvent {
  final String feedType; // NewFeed or MyFeed
  final String username;
  FetchMomentsOfUserEvent({required this.feedType, required this.username});

  @override
  List<Object> get props => List.empty();
}

class InitFeedEvent extends FeedEvent {
  InitFeedEvent();

  @override
  List<Object> get props => List.empty();
}

// suggestions based on a post query
// that's why they are listed here

class FetchSuggestedUsersForUserHistory extends FeedEvent {
  final String username;
  FetchSuggestedUsersForUserHistory({required this.username});
  @override
  List<Object> get props => List.empty();
}

class FetchSuggestedUsersForPost extends FeedEvent {
  final List<String> tags;
  final String currentUsername;

  FetchSuggestedUsersForPost(
      {required this.currentUsername, required this.tags});
  @override
  List<Object> get props => List.empty();
}

class FetchSuggestedPostsForPost extends FeedEvent {
  final List<String> tags;
  final String currentUsername;
  FetchSuggestedPostsForPost(
      {required this.currentUsername, required this.tags});
  @override
  List<Object> get props => List.empty();
}
