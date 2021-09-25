import 'package:dtube_go/bloc/feed/feed_response_model.dart';

import 'package:equatable/equatable.dart';

abstract class FeedState extends Equatable {}

class FeedInitialState extends FeedState {
  @override
  List<Object> get props => [];
}

class FeedLoadingState extends FeedState {
  @override
  List<Object> get props => [];
}

class FeedLoadedState extends FeedState {
  List<FeedItem> feed;
  String feedType;

  FeedLoadedState({required this.feed, required this.feedType});

  @override
  List<Object> get props => [feed];
}

class FeedErrorState extends FeedState {
  String message;

  FeedErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
