import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class GiftDialogDesktop extends StatefulWidget {
  GiftDialogDesktop(
      {Key? key,
      required this.receiver,
      required this.txBloc,
      required this.originLink,
      this.okCallback,
      this.cancelCallback})
      : super(key: key);
  final TransactionBloc txBloc;
  final String receiver;
  final String? originLink;
  final VoidCallback? okCallback;
  final VoidCallback? cancelCallback;

  @override
  _GiftDialogDesktopState createState() => _GiftDialogDesktopState();
}

class _GiftDialogDesktopState extends State<GiftDialogDesktop> {
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
    return WillPopScope(
        onWillPop: () async {
          if (widget.cancelCallback != null) {
            widget.cancelCallback!();
          }

          return true;
        },
        child: PopUpDialogWithTitleLogo(
          titleWidgetPadding: 25,
          titleWidgetSize: 50,
          height: 300,
          width: 400,
          callbackOK: () {},
          titleWidget: FaIcon(
            FontAwesomeIcons.gift,
            size: 50,
            color: globalBGColor,
          ),
          showTitleWidget: true,
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          child: OverlayNumberInput(
                            autoFocus: true,
                            textEditingController: _amountController,
                            label: "Amount",

                            // cursorColor: globalRed,
                            // decoration: new InputDecoration(labelText: "Amount"),
                            // style: Theme.of(context).textTheme.bodyText1,
                            // controller: _amountController,
                            // keyboardType:
                            //     TextInputType.numberWithOptions(decimal: true),
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp(r"^\d+\.?\d{0,2}")),
                            // ],
                          ),
                        ),
                        Text(
                          " DTC",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    child: Container(
                      height: 50,
                      child: OverlayTextInput(
                        autoFocus: true,
                        textEditingController: _memoController,
                        label: "add some kind words to your gift!",
                      ),
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
                          "Send Gift",
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
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
                                (double.parse(_amountController.value.text) *
                                        100)
                                    .floor(),
                            memo: _memo);
                        Transaction newTx = Transaction(type: 3, data: txdata);
                        _txBloc.add(SignAndSendTransactionEvent(tx: newTx));
                        Navigator.of(context).pop();
                        if (widget.okCallback != null) {
                          widget.okCallback!();
                        }
                      }),
                ],
              );
            },
          ),
        ));
  }
}
