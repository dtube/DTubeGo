import 'package:dtube_go/bloc/transaction/transaction_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {}

class TransactionInitialState extends TransactionState {
  List<Object> get props => [];
}

class TransactionSinging extends TransactionState {
  final Transaction tx;

  TransactionSinging({required this.tx});

  List<Object> get props => [tx];
}

class DAOTransactionSinging extends TransactionState {
  final DAOTransaction tx;

  DAOTransactionSinging({required this.tx});

  List<Object> get props => [tx];
}

// used only for uploading videos
class TransactionPreprocessingState extends TransactionState {
  TransactionPreprocessingState({required this.txType});
  final int txType;

  List<Object> get props => [];
}

class TransactionSigned extends TransactionState {
  final Transaction tx;

  TransactionSigned({required this.tx});

  List<Object> get props => [tx];
}

class TransactionSent extends TransactionState {
  final int block;
  final String successMessage;
  final int txType;
  final bool isParentContent;
  final String? authorPerm;
  final bool? isDownvote;

  TransactionSent(
      {required this.block,
      required this.successMessage,
      required this.txType,
      required this.isParentContent,
      this.authorPerm,
      this.isDownvote});

  List<Object> get props => [block];
}

class TransactionError extends TransactionState {
  final String message;
  final int txType;
  final bool isParentContent;

  TransactionError(
      {required this.message,
      required this.txType,
      required this.isParentContent});

  List<Object> get props => [message];
}
