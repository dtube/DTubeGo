import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogoDesktop.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogoMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class PopUpDialogWithTitleLogo extends StatelessWidget {
  PopUpDialogWithTitleLogo(
      {Key? key,
      required this.child,
      required this.titleWidget,
      required this.callbackOK,
      this.callbackCancel,
      required this.titleWidgetPadding,
      required this.titleWidgetSize,
      required this.showTitleWidget})
      : super(key: key);
  final Widget child;
  final Widget titleWidget;
  final VoidCallback callbackOK;
  final VoidCallback? callbackCancel;
  final double titleWidgetSize;
  final double titleWidgetPadding;
  final bool showTitleWidget;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: PopUpDialogWithTitleLogoDesktop(
          child: child,
          titleWidget: titleWidget,
          callbackOK: callbackOK,
          titleWidgetPadding: titleWidgetPadding,
          titleWidgetSize: titleWidgetSize,
          showTitleWidget: showTitleWidget),
      mobileBody: PopUpDialogWithTitleLogoMobile(
          child: child,
          titleWidget: titleWidget,
          callbackOK: callbackOK,
          titleWidgetPadding: titleWidgetPadding,
          titleWidgetSize: titleWidgetSize,
          showTitleWidget: showTitleWidget),
      tabletBody: PopUpDialogWithTitleLogoDesktop(
          child: child,
          titleWidget: titleWidget,
          callbackOK: callbackOK,
          titleWidgetPadding: titleWidgetPadding,
          titleWidgetSize: titleWidgetSize,
          showTitleWidget: showTitleWidget),
    );
  }
}
