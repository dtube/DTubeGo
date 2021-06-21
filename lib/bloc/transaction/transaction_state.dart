import 'package:dtube_togo/bloc/transaction/transaction_response_model.dart';
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

class TransactionSigned extends TransactionState {
  Transaction tx;

  TransactionSigned({required this.tx});

  @override
  List<Object> get props => [tx];
}

class TransactionSent extends TransactionState {
  int block;
  String successMessage;

  TransactionSent({required this.block, required this.successMessage});

  @override
  List<Object> get props => [block];
}

class TransactionError extends TransactionState {
  String message;

  TransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
