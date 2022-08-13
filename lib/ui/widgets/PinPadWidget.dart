import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinPadWidget extends StatelessWidget {
  PinPadWidget(
      {Key? key,
      required TextEditingController pinPutController,
      required this.requestFocus})
      : _pinPutController = pinPutController,
        super(key: key);

  final _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController;
  final bool requestFocus;

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(90.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Pinput(
      key: key,

      length: 5,
      defaultPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(fontSize: 25.0, color: globalAlmostWhite),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      showCursor: true,

      // eachFieldWidth: 40.0,
      // eachFieldHeight: 55.0,
      onSubmitted: (String pin) => print(pin),
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      autofocus: requestFocus,
      submittedPinTheme: PinTheme(decoration: pinPutDecoration),
      focusedPinTheme: PinTheme(decoration: pinPutDecoration),
      followingPinTheme: PinTheme(decoration: pinPutDecoration),
      pinAnimationType: PinAnimationType.fade,

      //keyboardType: TextInputType.name,
      //useNativeKeyboard: true,
    );
  }
}
