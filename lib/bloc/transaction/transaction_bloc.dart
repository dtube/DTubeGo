import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_repository.dart';

import 'package:dtube_togo/bloc/transaction/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionRepository repository;

  TransactionBloc({required this.repository})
      : super(TransactionInitialState());

  @override
  // TODO: implement initialState
  TransactionState get initialState => TransactionInitialState();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    final String _avalonApiNode = await sec.getNode();
    final String? _applicationUser = await sec.getUsername();
    final String? _privKey = await sec.getPrivateKey();
    if (event is SignAndSendTransactionEvent) {
      String result = "";
      //for (var i = 0; i < 5; i++) {
      //yield TransactionSinging(tx: event.tx);
      try {
        result = "";
        result = await repository
            .sign(event.tx, _applicationUser!, _privKey!)
            .then((value) => repository.send(_avalonApiNode, value));

        if (int.tryParse(result) != null) {
          yield TransactionSent(
              block: int.parse(result),
              successMessage: txTypeFriendlyDescription_Actions[event.tx.type]!
                  .replaceAll(
                      '##DTCAMOUNT',
                      (event.tx.data.amount != null
                              ? event.tx.data.amount! / 100
                              : 0)
                          .toString())
                  .replaceAll('##TIPAMOUNT', event.tx.data.tip.toString())
                  .replaceAll('##USERNAME', event.tx.data.target.toString()));
        } else {
          yield TransactionError(message: result);
        }
      } catch (e) {
        yield TransactionError(message: e.toString());
      }
    }
  }
}
