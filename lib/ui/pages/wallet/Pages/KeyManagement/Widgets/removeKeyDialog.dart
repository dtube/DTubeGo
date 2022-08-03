import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:flutter/services.dart';

import 'dart:async' show Future;

import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RemoveKeyDialog extends StatefulWidget {
  RemoveKeyDialog({Key? key, required this.txBloc, required this.keyId})
      : super(key: key);
  TransactionBloc txBloc;
  String keyId;

  @override
  _RemoveKeyDialogState createState() => _RemoveKeyDialogState();
}

class _RemoveKeyDialogState extends State<RemoveKeyDialog> {
  late TransactionBloc _txBloc;

  @override
  void initState() {
    super.initState();
    _txBloc = widget.txBloc;
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
      titleWidgetPadding: 5.w,
      titleWidgetSize: 20.w,
      callbackOK: () {},
      titleWidget: FaIcon(
        FontAwesomeIcons.times,
        size: 20.w,
        color: globalBGColor,
      ),
      showTitleWidget: true,
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h, left: 2.w, right: 2.w),
                  child: Text(
                    "Do you really want to delete this key?",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: globalRed,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      "Yes",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    TxData txdata = TxData(
                      id: widget.keyId,
                    );
                    Transaction newTx = Transaction(type: 11, data: txdata);
                    _txBloc.add(SignAndSendTransactionEvent(tx: newTx));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
