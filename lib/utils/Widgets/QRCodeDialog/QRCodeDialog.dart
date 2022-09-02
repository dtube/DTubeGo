import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/utils/Widgets/QRCodeDialog/Layouts/QRCodeDialogDesktop.dart';
import 'package:dtube_go/utils/Widgets/QRCodeDialog/Layouts/QRCodeDialogMobile.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QRCodeDialog extends StatelessWidget {
  const QRCodeDialog({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: QRCodeDialogDesktop(code: code),
      tabletBody: QRCodeDialogDesktop(code: code),
      mobileBody: QRCodeDialogMobile(code: code),
    );
  }
}
