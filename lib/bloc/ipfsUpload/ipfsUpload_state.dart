import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class IPFSUploadState extends Equatable {}

// general user states
class IPFSUploadInitialState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadVideoPreProcessingState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadVideoPreProcessedState extends IPFSUploadState {
  File compressedFile;
  IPFSUploadVideoPreProcessedState({required this.compressedFile});
  @override
  List<Object> get props => [compressedFile];
}

// general user states
class IPFSUploadVideoUploadingState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadVideoUploadedState extends IPFSUploadState {
  String uploadToken;
  IPFSUploadVideoUploadedState({required this.uploadToken});
  @override
  List<Object> get props => [uploadToken];
}

// general user states
class IPFSUploadVideoPostProcessingState extends IPFSUploadState {
  Map processingResponse;
  IPFSUploadVideoPostProcessingState({required this.processingResponse});
  @override
  List<Object> get props => [processingResponse];
}

// general user states
class IPFSUploadVideoPostProcessedState extends IPFSUploadState {
  Map processingResponse;
  IPFSUploadVideoPostProcessedState({required this.processingResponse});
  @override
  List<Object> get props => [processingResponse];
}

// general user states
class IPFSUploadThumbnailUploadingState extends IPFSUploadState {
  Map uploadingResponse;
  IPFSUploadThumbnailUploadingState({required this.uploadingResponse});
  @override
  List<Object> get props => [uploadingResponse];
  //List<Object> get props => [];
}

class IPFSUploadThumbnailUploadedState extends IPFSUploadState {
  Map uploadResponse;
  IPFSUploadThumbnailUploadedState({required this.uploadResponse});
  @override
  List<Object> get props => [uploadResponse];
}

class IPFSUploadErrorState extends IPFSUploadState {
  String message;

  IPFSUploadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
