import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftDialog/GiftDialogDesktop.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftDialog/GiftDialogMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class GiftDialog extends StatelessWidget {
  GiftDialog(
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
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: GiftDialogDesktop(
          receiver: receiver, txBloc: txBloc, originLink: originLink),
      tabletBody: GiftDialogDesktop(
          receiver: receiver, txBloc: txBloc, originLink: originLink),
      mobileBody: GiftDialogMobile(
          receiver: receiver, txBloc: txBloc, originLink: originLink),
    );
  }
}
