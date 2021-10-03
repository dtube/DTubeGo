import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/services.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class GiftDialog extends StatefulWidget {
  GiftDialog(
      {Key? key,
      required this.receiver,
      required this.txBloc,
      required this.originLink})
      : super(key: key);
  TransactionBloc txBloc;
  String receiver;
  String? originLink;

  @override
  _GiftDialogState createState() => _GiftDialogState();
}

class _GiftDialogState extends State<GiftDialog> {
  late TextEditingController _amountController;
  late TextEditingController _memoController;

  late TransactionBloc _txBloc;

  @override
  void initState() {
    super.initState();
    _amountController = new TextEditingController();
    _memoController = new TextEditingController();

    _txBloc = widget.txBloc;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      // title: const Text('Send a gift'),
      backgroundColor: globalAlmostBlack,
      content: Builder(
        builder: (context) {
          return Container(
            height: 45.h,
            width: 100.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: FaIcon(
                      FontAwesomeIcons.gift,
                      size: 30.w,
                      color: globalAlmostWhite,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          child: TextField(
                            cursorColor: globalRed,
                            decoration:
                                new InputDecoration(labelText: "Amount"),
                            style: Theme.of(context).textTheme.bodyText1,
                            controller: _amountController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d+\.?\d{0,2}")),
                            ],
                          ),
                        ),
                        Text(
                          "DTC",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: TextField(
                      cursorColor: globalRed,
                      decoration: new InputDecoration(
                          labelText:
                              "you can add some kind words to your gift"),
                      controller: _memoController,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        InputChip(
          backgroundColor: globalRed,
          onPressed: () async {
            String _memo = "";

            if (widget.originLink != "") {
              _memo =
                  "Gift sent through https://d.tube/#!/v/${widget.receiver}/${widget.originLink!}";
              if (_memoController.value.text != "") {
                _memo = _memo + ": ${_memoController.value.text}";
              }
            } else {
              _memo = _memoController.value.text;
            }
            TxData txdata = TxData(
                receiver: widget.receiver,
                amount:
                    (double.parse(_amountController.value.text) * 100).floor(),
                memo: _memo);
            Transaction newTx = Transaction(type: 3, data: txdata);
            _txBloc.add(SignAndSendTransactionEvent(newTx));
            Navigator.of(context).pop();
          },
          label: Text(
            'Send',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}
