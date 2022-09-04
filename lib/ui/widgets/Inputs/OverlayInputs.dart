import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverlayTextInput extends StatelessWidget {
  const OverlayTextInput(
      {Key? key,
      required this.textEditingController,
      required this.label,
      required this.autoFocus})
      : super(key: key);

  final TextEditingController textEditingController;
  final String label;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      //key: UniqueKey(),
      autofocus: autoFocus,
      controller: textEditingController,
      style: Theme.of(context).textTheme.headline5,
      cursorColor: globalRed,
      maxLines: 4,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20.0, top: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: globalRed,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: globalRed,
              width: 2.0,
            ),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: Theme.of(context).textTheme.bodyText1),
    );
  }
}

class OverlayNumberInput extends StatelessWidget {
  OverlayNumberInput({
    Key? key,
    required this.autoFocus,
    required this.textEditingController,
    required this.label,
  }) : super(key: key);

  final bool autoFocus;
  final TextEditingController textEditingController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: globalRed,
      autofocus: autoFocus,
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: globalRed,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: globalRed,
              width: 2.0,
            ),
          ),
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyText1),
      style: Theme.of(context).textTheme.headline5,
      controller: textEditingController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
      ],
    );
  }
}
