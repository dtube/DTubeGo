import 'package:equatable/equatable.dart';

abstract class ThirdPartyUploaderState extends Equatable {}

// general user states
class ThirdPartyUploaderInitialState extends ThirdPartyUploaderState {
  List<Object> get props => [];
}

class ThirdPartyUploaderUploadingState extends ThirdPartyUploaderState {
  ThirdPartyUploaderUploadingState();

  List<Object> get props => [];
}

class ThirdPartyUploaderUploadedState extends ThirdPartyUploaderState {
  final String uploadResponse;
  ThirdPartyUploaderUploadedState({required this.uploadResponse});

  List<Object> get props => [uploadResponse];
}

class ThirdPartyUploaderErrorState extends ThirdPartyUploaderState {
  final String message;

  ThirdPartyUploaderErrorState({required this.message});

  List<Object> get props => [message];
}
