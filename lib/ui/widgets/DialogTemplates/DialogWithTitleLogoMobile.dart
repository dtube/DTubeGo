import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class PopUpDialogWithTitleLogoMobile extends StatefulWidget {
  PopUpDialogWithTitleLogoMobile(
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
  _PopUpDialogWithTitleLogoMobileState createState() =>
      _PopUpDialogWithTitleLogoMobileState();
}

class _PopUpDialogWithTitleLogoMobileState
    extends State<PopUpDialogWithTitleLogoMobile> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: widget.titleWidgetSize),
            margin: EdgeInsets.only(top: widget.titleWidgetSize / 2),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: globalBGColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: widget.child),
        widget.showTitleWidget
            ? Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: globalAlmostWhite,
                  radius: 50,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: widget.titleWidget),
                ),
              )
            : Container(),
      ],
    );
  }
}
