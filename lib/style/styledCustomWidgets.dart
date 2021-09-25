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

class DTubeLogo extends StatelessWidget {
  double size;
  DTubeLogo({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/dtube_logo_white.png',
      fit: BoxFit.fitWidth,
      width: size,
    );
  }
}

class DTubeFormCard extends StatelessWidget {
  DTubeFormCard({Key? key, required this.childs}) : super(key: key);
  List<Widget> childs;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: globalBlue,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: childs),
      ),
    );
  }
}

class OverlayText extends StatelessWidget {
  OverlayText(
      {Key? key,
      required this.text,
      this.sizeMultiply,
      this.maxLines,
      this.overflow,
      this.bold})
      : super(key: key);

  final String text;
  double? sizeMultiply;
  int? maxLines;
  TextOverflow? overflow;
  bool? bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //style: Theme.of(context).textTheme.headline5,
      maxLines: maxLines != null ? maxLines! : 1,
      overflow: overflow != null ? overflow! : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.bodyText1!.fontSize! *
            (sizeMultiply != null ? sizeMultiply! : 1),
        fontWeight: bold != null && bold == true
            ? FontWeight.bold
            : Theme.of(context).textTheme.bodyText1!.fontWeight,
        color: Colors.white,
        shadows: [
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class ShadowedIcon extends StatelessWidget {
  double size;
  IconData icon;
  Color color;
  Color shadowColor;
  ShadowedIcon({
    Key? key,
    required this.size,
    required this.icon,
    required this.color,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new DecoratedIcon(
      icon,
      color: color,
      size: size,
      shadows: [
        Shadow(
          //blurRadius: size / 3,
          offset: Offset(1.0, 1.0),
          blurRadius: 2,
          color: shadowColor,
        ),
      ],
    );
  }
}
