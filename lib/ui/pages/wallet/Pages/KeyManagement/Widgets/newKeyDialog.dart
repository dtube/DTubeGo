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

class NewKeyDialog extends StatefulWidget {
  NewKeyDialog({Key? key, required this.txBloc}) : super(key: key);
  final TransactionBloc txBloc;

  @override
  _NewKeyDialogState createState() => _NewKeyDialogState();
}

class _NewKeyDialogState extends State<NewKeyDialog> {
  late TextEditingController _keyNameController;
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
    _keyNameController = new TextEditingController();
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
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration:
                        new InputDecoration(labelText: "Key Name / Usage*"),
                    controller: _keyNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Permissions:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children:
                        List<Widget>.generate(txTypes.length, (int index) {
                      return FilterChip(
                        showCheckmark: false,
                        selectedColor: globalRed,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          txTypes[index]!.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: 10),
                        ),
                        selected: _selectedTxTypes.contains(index),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTxTypes.add(index);
                            } else {
                              _selectedTxTypes.remove(index);
                            }
                          });
                        },
                      );
                    }),
                  ),
                ),
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
                              onPressed: _keyNameController.value.text != ""
                                  ? () {
                                      setState(() {
                                        _copyClicked = true;
                                      });
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              "name / usage: ${_keyNameController.value.text}\npublic key: ${_newPubController.value.text}\nprivate key: ${_newPrivController.value.text}"));
                                    }
                                  : null,
                              child: Center(child: Text("copy")))),
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: _copyClicked &&
                              _keyNameController.value.text != "" &&
                              _selectedTxTypes.length > 0
                          ? globalRed
                          : Colors.grey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      "Create key",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: _copyClicked &&
                          _keyNameController.value.text != "" &&
                          _selectedTxTypes.length > 0
                      ? () async {
                          TxData txdata = TxData(
                              id: _keyNameController.value.text,
                              pub: _newPubController.value.text,
                              types: _selectedTxTypes);
                          Transaction newTx =
                              Transaction(type: 10, data: txdata);
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
