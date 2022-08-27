import 'package:dtube_go/bloc/feed/feed_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class FeedState extends Equatable {}

class FeedInitialState extends FeedState {
  List<Object> get props => [];
}

class FeedLoadingState extends FeedState {
  List<Object> get props => [];
}

class FeedLoadedState extends FeedState {
  final List<FeedItem> feed;
  final String feedType;
  final bool fetchedWholeFeed;

  FeedLoadedState(
      {required this.feed,
      required this.feedType,
      required this.fetchedWholeFeed});

  List<Object> get props => [feed];
}

class FeedErrorState extends FeedState {
  final String message;

  FeedErrorState({required this.message});

  List<Object> get props => [message];
}

// suggestions based on a post query
// that's why they are listed here

class SuggestedUsersLoadingState extends FeedState {
  SuggestedUsersLoadingState();

  List<Object> get props => [];
}

class SuggestedUsersLoadedState extends FeedState {
  final List<String> users;

  SuggestedUsersLoadedState({
    required this.users,
  });

  List<Object> get props => [users];
}

class SuggestedPostsLoadingState extends FeedState {
  SuggestedPostsLoadingState();

  List<Object> get props => [];
}

class SuggestedPostsLoadedState extends FeedState {
  final List<FeedItem> suggestedPosts;

  SuggestedPostsLoadedState({
    required this.suggestedPosts,
  });

  List<Object> get props => [suggestedPosts];
}
