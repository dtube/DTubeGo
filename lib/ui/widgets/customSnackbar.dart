import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Flushbar showCustomFlushbarOnError(
    TransactionError state, BuildContext context) {
  return Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    message: state.message,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: globalBlue,
    boxShadows: [
      BoxShadow(color: globalRed, offset: Offset(0.0, 2.0), blurRadius: 3.0)
    ],
    //backgroundGradient: LinearGradient(colors: [globalBlue, globalAlmostBlack]),
    isDismissible: true,
    duration: Duration(seconds: 4),
    icon: FaIcon(
      FontAwesomeIcons.times,
      color: globalRed,
    ),
  )..show(context);
}

Flushbar showCustomFlushbarOnSuccess(
    TransactionSent state, BuildContext context) {
  return Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    message: state.successMessage,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: globalBlue,
    boxShadows: [
      BoxShadow(color: Colors.green, offset: Offset(0.0, 2.0), blurRadius: 3.0)
    ],
    //backgroundGradient: LinearGradient(colors: [globalBlue, globalAlmostBlack]),
    isDismissible: true,
    duration: Duration(seconds: 4),
    icon: FaIcon(
      FontAwesomeIcons.check,
      color: Colors.green,
    ),
  )..show(context);
}
