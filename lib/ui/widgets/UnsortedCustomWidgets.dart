import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DTubeFormCard extends StatelessWidget {
  DTubeFormCard(
      {Key? key,
      required this.childs,
      required this.waitBeforeFadeIn,
      required this.avoidAnimation})
      : super(key: key);
  final List<Widget> childs;
  final Duration waitBeforeFadeIn;
  final bool avoidAnimation;

  @override
  Widget build(BuildContext context) {
    return avoidAnimation
        ? Card(
            color: globalBlue,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: childs),
            ),
          )
        : SlideInLeft(
            preferences: AnimationPreferences(
              offset: waitBeforeFadeIn,
            ),
            child: Card(
              color: globalBlue,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: childs),
              ),
            ),
          );
  }
}
