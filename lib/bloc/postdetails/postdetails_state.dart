import 'package:dtube_go/bloc/postdetails/postdetails_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {}

class PostInitialState extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoadingState extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoadedState extends PostState {
  Post post;

  PostLoadedState({required this.post});

  @override
  List<Object> get props => [Post];
}

class PostErrorState extends PostState {
  String message;

  PostErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
