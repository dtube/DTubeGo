import 'package:equatable/equatable.dart';

abstract class IPFSUploadEvent extends Equatable {}

class UploadFile extends IPFSUploadEvent {
  UploadFile(this.localFilePath);
  final String localFilePath;
  @override
  List<Object> get props => List.empty();
}
