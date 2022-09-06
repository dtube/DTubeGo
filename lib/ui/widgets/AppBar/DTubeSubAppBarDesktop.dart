import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter/material.dart';

AppBar dtubeSubAppBarDesktop(
    bool showLogo, String title, BuildContext context, List<Widget>? actions) {
  return AppBar(
    centerTitle: true,
    backgroundColor: globalBGColor,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showLogo
            ? DTubeLogo(
                size: 60,
              )
            : SizedBox(
                width: 0,
              ),
        title != ""
            ? Padding(
                padding: EdgeInsets.only(right: 60),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline2,
                ),
              )
            : SizedBox(
                width: 0,
              ),
      ],
    ),
    actions: actions,
  );
}
