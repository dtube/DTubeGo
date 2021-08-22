import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ThirdPartyUploaderEvent extends Equatable {}

class UploadFile extends ThirdPartyUploaderEvent {
  UploadFile({required this.filePath, required this.context});
  final String filePath;
  BuildContext context;
  @override
  List<Object> get props => List.empty();
}

class SetThirdPartyUploaderInitState extends ThirdPartyUploaderEvent {
  SetThirdPartyUploaderInitState();

  @override
  List<Object> get props => List.empty();
}
