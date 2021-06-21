import 'dart:io';

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
class IPFSUploadFileProcessingState extends IPFSUploadState {
  @override
  List<Object> get props => [];
}

// general user states
class IPFSUploadFileProcessedState extends IPFSUploadState {
  File compressedFile;
  IPFSUploadFileProcessedState({required this.compressedFile});
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
  String hash;
  IPFSUploadFileUploadedState({required this.hash});
  @override
  List<Object> get props => [hash];
}

class IPFSUploadErrorState extends IPFSUploadState {
  String message;

  IPFSUploadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
