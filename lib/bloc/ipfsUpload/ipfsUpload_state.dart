import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dtube_togo/bloc/user/user_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:video_compress/video_compress.dart';

abstract class IPFSUploadState extends Equatable {}

// general user states
class IPFSUploadInitialState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadFilePreProcessingState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadFilePreProcessedState extends IPFSUploadState {
  File compressedFile;
  IPFSUploadFilePreProcessedState({required this.compressedFile});
  @override
  List<Object> get props => [compressedFile];
}

// general user states
class IPFSUploadFileUploadingState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadFileUploadedState extends IPFSUploadState {
  String uploadToken;
  IPFSUploadFileUploadedState({required this.uploadToken});
  @override
  List<Object> get props => [uploadToken];
}

// general user states
class IPFSUploadFilePostProcessingState extends IPFSUploadState {
  Map processingResponse;
  IPFSUploadFilePostProcessingState({required this.processingResponse});
  @override
  List<Object> get props => [processingResponse];
}

// general user states
class IPFSUploadFilePostProcessedState extends IPFSUploadState {
  Map processingResponse;
  IPFSUploadFilePostProcessedState({required this.processingResponse});
  @override
  List<Object> get props => [processingResponse];
}

class IPFSUploadErrorState extends IPFSUploadState {
  String message;

  IPFSUploadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
