import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Flushbar showCustomFlushbarOnError(String message, BuildContext context) {
  return Flushbar(
    margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    borderRadius: BorderRadius.circular(8),
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.easeOut,
    backgroundColor: globalBlue,
    boxShadows: [
      BoxShadow(color: globalRed, offset: Offset(0.0, 2.0), blurRadius: 3.0)
    ],
    //backgroundGradient: LinearGradient(colors: [globalBlue, globalAlmostBlack]),
    isDismissible: true,
    duration: Duration(seconds: 10),
    icon: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: FaIcon(
        FontAwesomeIcons.times,
        color: globalRed,
      ),
    ),
  )..show(context);
}

Flushbar showCustomFlushbarOnSuccess(
    TransactionSent state, BuildContext context) {
  if (state.isDownvote != null && state.isDownvote!) {
    Phoenix.rebirth(context);
  }

  return Flushbar(
    margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    borderRadius: BorderRadius.circular(8),
    message:
        state.isParentContent ? "new video is published" : state.successMessage,
    onTap: (Flushbar fb) {
      if (state.authorPerm != null) {
        BlocProvider.of<TransactionBloc>(context).add(SetInitState());
        navigateToPostDetailPage(
            context,
            state.authorPerm!.substring(0, state.authorPerm!.indexOf('/')),
            state.authorPerm!.substring(state.authorPerm!.indexOf('/') + 1),
            "none",
            true,
            () {});
      }
    },
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
    icon: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: FaIcon(
        FontAwesomeIcons.check,
        color: Colors.green,
      ),
    ),
  )..show(context);
}
