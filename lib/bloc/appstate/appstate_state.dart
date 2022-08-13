abstract class AppState
//extends Equatable
{}

// Upload States
class UploadInitialState extends AppState {
  List<Object> get props => [];
}

class UploadStartedState extends AppState {
  List<Object> get props => [];
}

class UploadProcessingState extends AppState {
  final double progressPercent;
  UploadProcessingState({required this.progressPercent});

  List<Object> get props => [progressPercent];
}

class UploadFinishedState extends AppState {
  List<Object> get props => [];
}

class UploadFailedState extends AppState {
  List<Object> get props => [];
}
