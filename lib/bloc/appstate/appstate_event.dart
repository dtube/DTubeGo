import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppStateEvent extends Equatable {}

// Upload States
class UploadStateChangedEvent extends AppStateEvent {
  AppState uploadState;
  UploadStateChangedEvent({required this.uploadState});

  @override
  List<Object> get props => List.empty();
}
