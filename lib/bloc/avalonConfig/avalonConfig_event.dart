import 'package:equatable/equatable.dart';

abstract class AvalonConfigEvent extends Equatable {}

class FetchAvalonConfigEvent extends AvalonConfigEvent {
  FetchAvalonConfigEvent();

  @override
  List<Object> get props => List.empty();
}

class FetchAvalonAccountPriceEvent extends AvalonConfigEvent {
  FetchAvalonAccountPriceEvent(this.accountName);
  String accountName;
  @override
  List<Object> get props => List.empty();
}
