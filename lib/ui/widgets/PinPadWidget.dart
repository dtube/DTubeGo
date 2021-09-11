import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PinPadWidget extends StatelessWidget {
  PinPadWidget(
      {Key? key,
      required TextEditingController pinPutController,
      required this.requestFocus})
      : _pinPutController = pinPutController,
        super(key: key);

  final _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController;
  bool requestFocus = false;

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(90.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return PinPut(
      key: key,
      fieldsCount: 5,
      withCursor: true,
      textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
      eachFieldWidth: 40.0,
      eachFieldHeight: 55.0,
      onSubmit: (String pin) => print(pin),
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      autofocus: requestFocus,
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.fade,
      inputDecoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        counterText: "",
      ),

      //keyboardType: TextInputType.name,
      //useNativeKeyboard: true,
    );
  }
}
