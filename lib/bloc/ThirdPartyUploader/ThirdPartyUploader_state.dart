import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ThirdPartyUploaderState extends Equatable {}

// general user states
class ThirdPartyUploaderInitialState extends ThirdPartyUploaderState {
  @override
  List<Object> get props => [];
}

class ThirdPartyUploaderUploadingState extends ThirdPartyUploaderState {
  ThirdPartyUploaderUploadingState();
  @override
  List<Object> get props => [];
}

class ThirdPartyUploaderUploadedState extends ThirdPartyUploaderState {
  String uploadResponse;
  ThirdPartyUploaderUploadedState({required this.uploadResponse});
  @override
  List<Object> get props => [uploadResponse];
}

class ThirdPartyUploaderErrorState extends ThirdPartyUploaderState {
  String message;

  ThirdPartyUploaderErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
