import 'package:dtube_togo/bloc/transaction/transaction_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {}

class SignAndSendTransactionEvent extends TransactionEvent {
  SignAndSendTransactionEvent(this.tx);
  Transaction tx;

  @override
  List<Object> get props => List.empty();
}
