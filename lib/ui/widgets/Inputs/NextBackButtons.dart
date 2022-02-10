import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomNextButton extends StatelessWidget {
  CustomNextButton({Key? key, required this.onTapped}) : super(key: key);

  VoidCallback? onTapped;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTapped != null
            ? () {
                onTapped!();
              }
            : null,
        child: Container(
          width: 15.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("next"),
              FaIcon(
                FontAwesomeIcons.arrowRight,
                size: 5.w,
              )
            ],
          ),
        ));
  }
}

class CustomBackButton extends StatelessWidget {
  CustomBackButton({Key? key, required this.onTapped}) : super(key: key);

  VoidCallback? onTapped;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTapped != null
            ? () {
                onTapped!();
              }
            : null,
        child: Container(
          width: 15.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 5.w,
              ),
              Text("back"),
            ],
          ),
        ));
  }
}
