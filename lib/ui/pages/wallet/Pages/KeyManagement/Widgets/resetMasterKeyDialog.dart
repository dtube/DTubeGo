import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:flutter/services.dart';

import 'dart:async' show Future;

import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/Random/randomGenerator.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResetMasterKeyDialog extends StatefulWidget {
  ResetMasterKeyDialog({Key? key, required this.txBloc}) : super(key: key);
  final TransactionBloc txBloc;

  @override
  _ResetMasterKeyDialogState createState() => _ResetMasterKeyDialogState();
}

class _ResetMasterKeyDialogState extends State<ResetMasterKeyDialog> {
  late TextEditingController _newPubController;
  late TextEditingController _newPrivController;
  late TransactionBloc _txBloc;
  bool _copyClicked = false;
  List<int> _selectedTxTypes = [];

  void getNewKeyPair() async {
    List<String> keys = generateNewKeyPair();
    setState(() {
      _newPubController.text = keys[0];
      _newPrivController.text = keys[1];
    });
  }

  @override
  void initState() {
    super.initState();

    _newPubController = new TextEditingController();
    _newPrivController = new TextEditingController();
    _txBloc = widget.txBloc;

    getNewKeyPair();
  }

  @override
  Widget build(BuildContext context) {
    return PopUpDialogWithTitleLogo(
      titleWidgetPadding: 5.w,
      titleWidgetSize: 20.w,
      callbackOK: () {},
      titleWidget: FaIcon(
        FontAwesomeIcons.key,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Changing the master key can not be reverted. Make sure you safe the key before proceeding!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: globalRed))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("public key:"),
                            Text(
                              _newPubController.value.text,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text("private key:"),
                            ),
                            Text(
                              _newPrivController.value.text,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 20.w,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _copyClicked = true;
                                });
                                Clipboard.setData(ClipboardData(
                                    text:
                                        "name / usage: MASTERKEY\npublic key: ${_newPubController.value.text}\nprivate key: ${_newPrivController.value.text}"));
                              },
                              child: Center(child: Text("copy")))),
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: _copyClicked ? globalRed : Colors.grey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      "Reset key!",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: _copyClicked
                      ? () async {
                          TxData txdata = TxData(
                            pub: _newPubController.value.text,
                          );
                          Transaction newTx =
                              Transaction(type: 12, data: txdata);
                          _txBloc.add(SignAndSendTransactionEvent(tx: newTx));
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
