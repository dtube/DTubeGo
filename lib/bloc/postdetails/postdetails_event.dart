import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class FetchPostEvent extends PostEvent {
  FetchPostEvent(this.author, this.link, this.origin);
  final String author;
  final String link;
  final String origin;

  @override
  List<Object> get props => List.empty();
}

class FetchTopLevelPostEvent extends PostEvent {
  FetchTopLevelPostEvent(this.author, this.link);
  final String author;
  final String link;

  @override
  List<Object> get props => List.empty();
}
