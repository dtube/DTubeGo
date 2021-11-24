abstract class AppState
//extends Equatable
{}

// Upload States
class UploadInitialState extends AppState {
  @override
  List<Object> get props => [];
}

class UploadStartedState extends AppState {
  @override
  List<Object> get props => [];
}

class UploadProcessingState extends AppState {
  final double progressPercent;
  UploadProcessingState({required this.progressPercent});
  @override
  List<Object> get props => [progressPercent];
}

class UploadFinishedState extends AppState {
  @override
  List<Object> get props => [];
}

class UploadFailedState extends AppState {
  @override
  List<Object> get props => [];
}
