import 'package:equatable/equatable.dart';

abstract class AvalonConfigEvent extends Equatable {}

class FetchAvalonConfigEvent extends AvalonConfigEvent {
  FetchAvalonConfigEvent(this.author, this.link);
  String author;
  String link;

  @override
  List<Object> get props => List.empty();
}

class FetchAvalonAccountPriceEvent extends AvalonConfigEvent {
  FetchAvalonAccountPriceEvent(this.accountName);
  String accountName;
  @override
  List<Object> get props => List.empty();
}
