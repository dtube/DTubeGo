import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class Web3StorageState extends Equatable {}

// general user states
class Web3StorageInitialState extends Web3StorageState {
  @override
  List<Object> get props => [];
}

// general user states
class Web3StorageVideoPreProcessingState extends Web3StorageState {
  @override
  List<Object> get props => [];
}

// general user states
class Web3StorageVideoPreProcessedState extends Web3StorageState {
  File compressedFile;
  Web3StorageVideoPreProcessedState({required this.compressedFile});
  @override
  List<Object> get props => [compressedFile];
}

// general user states
class Web3StorageVideoUploadingState extends Web3StorageState {
  @override
  List<Object> get props => [];
}

// general user states
class Web3StorageVideoUploadedState extends Web3StorageState {
  String uploadToken;
  Web3StorageVideoUploadedState({required this.uploadToken});
  @override
  List<Object> get props => [uploadToken];
}

// general user states
class Web3StorageVideoPostProcessingState extends Web3StorageState {
  Map processingResponse;
  Web3StorageVideoPostProcessingState({required this.processingResponse});
  @override
  List<Object> get props => [processingResponse];
}

// general user states
class Web3StorageVideoPostProcessedState extends Web3StorageState {
  String processingResponse;
  Web3StorageVideoPostProcessedState({required this.processingResponse});
  @override
  List<Object> get props => [processingResponse];
}

// general user states
class Web3StorageThumbnailUploadingState extends Web3StorageState {
  Map uploadingResponse;
  Web3StorageThumbnailUploadingState({required this.uploadingResponse});
  @override
  List<Object> get props => [uploadingResponse];
  //List<Object> get props => [];
}

class Web3StorageThumbnailUploadedState extends Web3StorageState {
  Web3StorageThumbnailUploadedState();
  @override
  List<Object> get props => [];
}

// general user states
class OtherProviderThumbnailUploadingState extends Web3StorageState {
  OtherProviderThumbnailUploadingState();
  @override
  List<Object> get props => [];
  //List<Object> get props => [];
}

class OtherProviderThumbnailUploadedState extends Web3StorageState {
  String resultMessage;
  OtherProviderThumbnailUploadedState({required this.resultMessage});
  @override
  List<Object> get props => [resultMessage];
}

class Web3StorageErrorState extends Web3StorageState {
  String message;

  Web3StorageErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
