import 'package:dtube_go/bloc/transaction/transaction_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {}

class TransactionInitialState extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionSinging extends TransactionState {
  Transaction tx;

  TransactionSinging({required this.tx});
  @override
  List<Object> get props => [tx];
}

// used only for uploading videos
class TransactionPreprocessingState extends TransactionState {
  TransactionPreprocessingState({required this.txType});
  final int txType;
  @override
  List<Object> get props => [];
}

class TransactionSigned extends TransactionState {
  Transaction tx;

  TransactionSigned({required this.tx});

  @override
  List<Object> get props => [tx];
}

class TransactionSent extends TransactionState {
  int block;
  String successMessage;
  int txType;
  bool isParentContent;
  String? authorPerm;

  TransactionSent(
      {required this.block,
      required this.successMessage,
      required this.txType,
      required this.isParentContent,
      this.authorPerm});

  @override
  List<Object> get props => [block];
}

class TransactionError extends TransactionState {
  String message;

  TransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
