import 'package:dtube_go/bloc/postdetails/postdetails_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {}

class PostInitialState extends PostState {
  List<Object> get props => [];
}

class PostLoadingState extends PostState {
  List<Object> get props => [];
}

class PostLoadedState extends PostState {
  final Post post;

  PostLoadedState({required this.post});

  List<Object> get props => [Post];
}

class TopLevelPostLoadingState extends PostState {
  List<Object> get props => [];
}

class TopLevelPostLoadedState extends PostState {
  final Post post;

  TopLevelPostLoadedState({required this.post});

  List<Object> get props => [Post];
}

class PostErrorState extends PostState {
  final String message;

  PostErrorState({required this.message});

  List<Object> get props => [message];
}
