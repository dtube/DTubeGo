import 'package:dtube_togo/bloc/settings/settings_bloc.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/ui/widgets/PinPadWidget.dart';
import 'package:flutter/services.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinCodeDialog extends StatefulWidget {
  PinCodeDialog({Key? key, required this.currentPin}) : super(key: key);

  String? currentPin;

  @override
  _PinCodeDialogState createState() => _PinCodeDialogState();
}

class _PinCodeDialogState extends State<PinCodeDialog> {
  late TextEditingController _currentPinController =
      new TextEditingController();
  late TextEditingController _newPinController = new TextEditingController();
  bool _currentPinValid = false;
  bool _activateSaveButton = false;

  void _currentPinOkay() {
    if (_currentPinController.text == widget.currentPin) {
      setState(() {
        _currentPinValid = true;
      });
    }
  }

  void _newPinSet() {
    if (_newPinController.text.length == 5) {
      setState(() {
        _activateSaveButton = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //  _loginBloc = BlocProvider.of<AuthBloc>(context);
    //if logindata already stored
    _currentPinController.addListener(_currentPinOkay);
    _newPinController.addListener(_newPinSet);
    if (widget.currentPin == "") {
      _currentPinValid = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      // title: Text(
      //   'set your pin',
      //   style: Theme.of(context).textTheme.headline3,
      // ),
      backgroundColor: globalAlmostBlack,
      content: Builder(
        builder: (context) {
          return Container(
            height: deviceHeight / 6,
            width: deviceWidth - 100,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    !_currentPinValid
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("current pin"),
                          )
                        : SizedBox(height: 0),
                    !_currentPinValid
                        ? PinPadWidget(
                            pinPutController: _currentPinController,
                            requestFocus: !_currentPinValid,
                          )
                        : SizedBox(height: 0),
                    _currentPinValid
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("new pin"),
                          )
                        : SizedBox(height: 0),
                    _currentPinValid
                        ? PinPadWidget(
                            pinPutController: _newPinController,
                            requestFocus: _currentPinValid,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ],
                ),
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
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        ElevatedButton(
          //style: TextButton.styleFrom(backgroundColor: globalRed),
          onPressed: _activateSaveButton
              ? () {
                  BlocProvider.of<SettingsBloc>(context)
                      .add(PushNewPinEvent(_newPinController.text));
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(
            'Save',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
