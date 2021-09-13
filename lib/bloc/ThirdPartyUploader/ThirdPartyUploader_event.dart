import 'package:equatable/equatable.dart';

abstract class ThirdPartyUploaderEvent extends Equatable {}

class UploadFile extends ThirdPartyUploaderEvent {
  UploadFile({required this.filePath});
  final String filePath;

  @override
  List<Object> get props => List.empty();
}

class SetThirdPartyUploaderInitState extends ThirdPartyUploaderEvent {
  SetThirdPartyUploaderInitState();

  @override
  List<Object> get props => List.empty();
}
