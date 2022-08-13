import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class IPFSUploadState extends Equatable {}

// general user states
class IPFSUploadInitialState extends IPFSUploadState {
  List<Object> get props => [];
}

// general user states
class IPFSUploadVideoPreProcessingState extends IPFSUploadState {
  List<Object> get props => [];
}

// general user states
class IPFSUploadVideoPreProcessedState extends IPFSUploadState {
  final File compressedFile;
  IPFSUploadVideoPreProcessedState({required this.compressedFile});

  List<Object> get props => [compressedFile];
}

// general user states
class IPFSUploadVideoUploadingState extends IPFSUploadState {
  List<Object> get props => [];
}

// general user states
class IPFSUploadVideoUploadedState extends IPFSUploadState {
  final String uploadToken;
  IPFSUploadVideoUploadedState({required this.uploadToken});

  List<Object> get props => [uploadToken];
}

// general user states
class IPFSUploadVideoPostProcessingState extends IPFSUploadState {
  final Map processingResponse;
  IPFSUploadVideoPostProcessingState({required this.processingResponse});

  List<Object> get props => [processingResponse];
}

// general user states
class IPFSUploadVideoPostProcessedState extends IPFSUploadState {
  final Map processingResponse;
  IPFSUploadVideoPostProcessedState({required this.processingResponse});

  List<Object> get props => [processingResponse];
}

// general user states
class IPFSUploadThumbnailUploadingState extends IPFSUploadState {
  final Map uploadingResponse;
  IPFSUploadThumbnailUploadingState({required this.uploadingResponse});

  List<Object> get props => [uploadingResponse];
  //List<Object> get props => [];
}

class IPFSUploadThumbnailUploadedState extends IPFSUploadState {
  IPFSUploadThumbnailUploadedState();

  List<Object> get props => [];
}

// general user states
class OtherProviderThumbnailUploadingState extends IPFSUploadState {
  OtherProviderThumbnailUploadingState();

  List<Object> get props => [];
  //List<Object> get props => [];
}

class OtherProviderThumbnailUploadedState extends IPFSUploadState {
  final String resultMessage;
  OtherProviderThumbnailUploadedState({required this.resultMessage});

  List<Object> get props => [resultMessage];
}

class IPFSUploadErrorState extends IPFSUploadState {
  final String message;

  IPFSUploadErrorState({required this.message});

  List<Object> get props => [message];
}
