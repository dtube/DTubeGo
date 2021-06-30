import 'package:flutter/services.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:flutter/material.dart';

class TransferDialog extends StatefulWidget {
  TransferDialog({Key? key, this.receiver, required this.txBloc})
      : super(key: key);
  TransactionBloc txBloc;
  String? receiver;

  @override
  _TransferDialogState createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  late TextEditingController _amountController;
  late TextEditingController _memoController;
  late TextEditingController _receiverController;
  late TransactionBloc _txBloc;

  @override
  void initState() {
    super.initState();
    _amountController = new TextEditingController();
    _memoController = new TextEditingController();
    _receiverController = new TextEditingController();
    _txBloc = widget.txBloc;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('DTC transfer'),
      backgroundColor: globalAlmostBlack,
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            height: height / 3,
            width: width - 100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  widget.receiver == null
                      ? TextField(
                          decoration:
                              new InputDecoration(labelText: "Receiver"),
                          controller: _receiverController,
                        )
                      : SizedBox(height: 0),
                  TextField(
                    decoration: new InputDecoration(labelText: "Amount"),
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d+\.?\d{0,2}")),
                    ],
                  ),
                  TextField(
                    decoration: new InputDecoration(labelText: "Memo"),
                    controller: _memoController,
                  )
                ],
              ),
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: globalRed),
          onPressed: () {
            TxData txdata = TxData(
                receiver: widget.receiver != null
                    ? widget.receiver
                    : _receiverController.value.text,
                amount:
                    (double.parse(_amountController.value.text) * 100).floor(),
                memo: _memoController.value.text);
            Transaction newTx = Transaction(type: 3, data: txdata);
            _txBloc.add(SignAndSendTransactionEvent(newTx));
            Navigator.of(context).pop();
          },
          child: Text(
            'Send',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}
