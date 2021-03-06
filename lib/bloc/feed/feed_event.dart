import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

class FetchFeedEvent extends FeedEvent {
  late String feedType;
  String? fromAuthor;
  String? fromLink;
  FetchFeedEvent({required this.feedType, this.fromAuthor, this.fromLink});

  @override
  List<Object> get props => List.empty();
}

class FetchMomentsEvent extends FeedEvent {
  String feedType; // NewFeed or MyFeed
  FetchMomentsEvent({required this.feedType});

  @override
  List<Object> get props => List.empty();
}

class FetchTagSearchResults extends FeedEvent {
  String tags; // NewFeed or MyFeed
  FetchTagSearchResults({required this.tags});

  @override
  List<Object> get props => List.empty();
}

class FetchUserFeedEvent extends FeedEvent {
  late String username;
  String? fromAuthor;
  String? fromLink;
  FetchUserFeedEvent({required this.username, this.fromAuthor, this.fromLink});

  @override
  List<Object> get props => List.empty();
}

class FetchMomentsOfUserEvent extends FeedEvent {
  String feedType; // NewFeed or MyFeed
  String username;
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
  late String username;
  FetchSuggestedUsersForUserHistory({required this.username});
  @override
  List<Object> get props => List.empty();
}

class FetchSuggestedUsersForPost extends FeedEvent {
  late List<String> tags;
  late String currentUsername;
  FetchSuggestedUsersForPost(
      {required this.currentUsername, required this.tags});
  @override
  List<Object> get props => List.empty();
}

class FetchSuggestedPostsForPost extends FeedEvent {
  late List<String> tags;
  late String currentUsername;
  FetchSuggestedPostsForPost(
      {required this.currentUsername, required this.tags});
  @override
  List<Object> get props => List.empty();
}
