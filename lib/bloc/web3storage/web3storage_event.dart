import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class Web3StorageEvent extends Equatable {}

class UploadVideo extends Web3StorageEvent {
  UploadVideo(
      {required this.videoPath,
      required this.thumbnailPath,
      required this.uploadData,
      required this.context});
  final String videoPath;
  final String thumbnailPath;
  UploadData uploadData;
  BuildContext context;
  @override
  List<Object> get props => List.empty();
}

class Web3StorageInitState extends Web3StorageEvent {
  Web3StorageInitState();

  @override
  List<Object> get props => List.empty();
}
