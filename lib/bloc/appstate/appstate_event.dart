import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:equatable/equatable.dart';

abstract class AppStateEvent extends Equatable {}

// Upload States
class UploadStateChangedEvent extends AppStateEvent {
  final AppState uploadState;
  UploadStateChangedEvent({required this.uploadState});

  @override
  List<Object> get props => List.empty();
}
