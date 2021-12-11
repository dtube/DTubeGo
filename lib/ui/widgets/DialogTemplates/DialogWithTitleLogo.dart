import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class PopUpDialogWithTitleLogo extends StatefulWidget {
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
  Widget child;
  Widget titleWidget;
  VoidCallback callbackOK;
  VoidCallback? callbackCancel;
  double titleWidgetSize;
  double titleWidgetPadding;
  bool showTitleWidget;

  @override
  _PopUpDialogWithTitleLogoState createState() =>
      _PopUpDialogWithTitleLogoState();
}

class _PopUpDialogWithTitleLogoState extends State<PopUpDialogWithTitleLogo> {
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
            // padding: EdgeInsets.only(top: 50 + 20),
            // margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.only(top: widget.titleWidgetSize),
            margin: EdgeInsets.only(top: widget.titleWidgetSize / 2),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: globalBGColor,
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(width: 5, color: globalAlmostWhite),
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
