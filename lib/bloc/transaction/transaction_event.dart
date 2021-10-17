import 'package:dtube_go/bloc/transaction/transaction_response_model.dart';
import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {}

class SignAndSendTransactionEvent extends TransactionEvent {
  SignAndSendTransactionEvent(this.tx);
  Transaction tx;

  @override
  List<Object> get props => List.empty();
}

class SendCommentEvent extends TransactionEvent {
  SendCommentEvent(
    this.uploadData,
  );
  UploadData uploadData;

  @override
  List<Object> get props => List.empty();
}

class ChangeProfileData extends TransactionEvent {
  ChangeProfileData(
    this.userData,
  );
  User userData;

  @override
  List<Object> get props => List.empty();
}

class SetInitState extends TransactionEvent {
  SetInitState();

  @override
  List<Object> get props => List.empty();
}

// used only for uploading videos
class TransactionPreprocessing extends TransactionEvent {
  TransactionPreprocessing({required this.txType});
  final int txType;
  @override
  List<Object> get props => List.empty();
}

// used only for uploading videos
class TransactionPreprocessingFailed extends TransactionEvent {
  String errorMessage;
  final int txType;
  TransactionPreprocessingFailed(
      {required this.errorMessage, required this.txType});
  @override
  List<Object> get props => List.empty();
}
