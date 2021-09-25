import 'package:dtube_go/bloc/avalonConfig/avalonConfig_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AvalonConfigState extends Equatable {}

class AvalonConfigInitialState extends AvalonConfigState {
  @override
  List<Object> get props => [];
}

class AvalonConfigLoadingState extends AvalonConfigState {
  @override
  List<Object> get props => [];
}

class AvalonConfigLoadedState extends AvalonConfigState {
  AvalonConfig config;

  AvalonConfigLoadedState({required this.config});

  @override
  List<Object> get props => [config];
}

class AvalonConfigErrorState extends AvalonConfigState {
  String message;

  AvalonConfigErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
