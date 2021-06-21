import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class FetchPostEvent extends PostEvent {
  FetchPostEvent(this.author, this.link);
  String author;
  String link;

  @override
  List<Object> get props => List.empty();
}
