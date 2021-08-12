import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:equatable/equatable.dart';

abstract class IPFSUploadEvent extends Equatable {}

class UploadVideo extends IPFSUploadEvent {
  UploadVideo(this.videoPath, this.thumbnailPath, this.uploadData);
  final String videoPath;
  final String thumbnailPath;
  // just for testing: background uploader
  UploadData uploadData;
  @override
  List<Object> get props => List.empty();
}
