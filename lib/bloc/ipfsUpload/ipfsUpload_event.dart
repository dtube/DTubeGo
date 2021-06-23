import 'package:equatable/equatable.dart';

abstract class IPFSUploadEvent extends Equatable {}

class UploadVideo extends IPFSUploadEvent {
  UploadVideo(this.videoPath, this.thumbnailPath);
  final String videoPath;
  final String thumbnailPath;
  @override
  List<Object> get props => List.empty();
}
