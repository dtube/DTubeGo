import 'package:dtube_go/bloc/avalonConfig/avalonConfig_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AvalonConfigState extends Equatable {}

class AvalonConfigInitialState extends AvalonConfigState {
  List<Object> get props => [];
}

class AvalonConfigLoadingState extends AvalonConfigState {
  List<Object> get props => [];
}

class AvalonConfigLoadedState extends AvalonConfigState {
  final AvalonConfig config;

  AvalonConfigLoadedState({required this.config});

  List<Object> get props => [config];
}

class AvalonConfigErrorState extends AvalonConfigState {
  final String message;

  AvalonConfigErrorState({required this.message});

  List<Object> get props => [message];
}

class AvalonAccountAvailableState extends AvalonConfigState {
  final int dtcCosts;

  AvalonAccountAvailableState({required this.dtcCosts});

  List<Object> get props => [dtcCosts];
}

class AvalonAccountNotAvailableState extends AvalonConfigState {
  AvalonAccountNotAvailableState();

  List<Object> get props => [];
}

class AvalonAccountLoadingState extends AvalonConfigState {
  AvalonAccountLoadingState();

  List<Object> get props => [];
}

class AvalonAccountErrorState extends AvalonConfigState {
  AvalonAccountErrorState();

  List<Object> get props => [];
}
