import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'dart:ui';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar dtubeSubAppBar(
    bool showLogo, String title, BuildContext context, List<Widget>? actions) {
  return AppBar(
    centerTitle: true,
    title: showLogo
        ? DTubeLogo(
            size: 60,
          )
        : Text(
            title,
            style: Theme.of(context).textTheme.headline2,
          ),
    actions: actions,
  );
}

class DTubeFormCard extends StatelessWidget {
  DTubeFormCard(
      {Key? key, required this.childs, required this.waitBeforeFadeIn})
      : super(key: key);
  List<Widget> childs;
  Duration waitBeforeFadeIn;

  @override
  Widget build(BuildContext context) {
    return SlideInLeft(
      preferences: AnimationPreferences(offset: waitBeforeFadeIn),
      child: Card(
        color: globalBlue,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: childs),
        ),
      ),
    );
  }
}
