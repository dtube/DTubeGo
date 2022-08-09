import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class FetchPostEvent extends PostEvent {
  FetchPostEvent(this.author, this.link, this.origin);
  String author;
  String link;
  String origin;

  @override
  List<Object> get props => List.empty();
}

class FetchTopLevelPostEvent extends PostEvent {
  FetchTopLevelPostEvent(this.author, this.link);
  String author;
  String link;

  @override
  List<Object> get props => List.empty();
}
