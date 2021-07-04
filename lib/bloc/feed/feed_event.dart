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

class FetchUserFeedEvent extends FeedEvent {
  late String username;
  String? fromAuthor;
  String? fromLink;
  FetchUserFeedEvent({required this.username, this.fromAuthor, this.fromLink});

  @override
  List<Object> get props => List.empty();
}
