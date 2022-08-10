import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';

class ShadowedIcon extends StatelessWidget {
  double size;
  IconData icon;
  Color color;
  Color shadowColor;
  bool? visible;
  ShadowedIcon(
      {Key? key,
      required this.size,
      required this.icon,
      required this.color,
      required this.shadowColor,
      this.visible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (visible == null) {
      visible = true;
    }
    return Visibility(
      visible: visible!,
      child: new DecoratedIcon(
        icon,
        color: color,
        size: size,
        shadows: [
          Shadow(color: shadowColor, offset: Offset(0, 0), blurRadius: 2),
          //Shadow(color: globalAlmostWhite, offset: Offset(0, 0), blurRadius: 10),
          Shadow(
            offset: Offset(4.0, 3.0),
            blurRadius: 10,
            color: shadowColor,
          ),
        ],
      ),
    );
  }
}

class HighlightedIcon extends StatelessWidget {
  double size;
  IconData icon;
  Color color;
  Color highlightColor;
  double highlightBlur;
  HighlightedIcon({
    Key? key,
    required this.size,
    required this.icon,
    required this.color,
    required this.highlightColor,
    required this.highlightBlur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new DecoratedIcon(
      icon,
      color: color,
      size: size,
      shadows: [
        Shadow(
            color: highlightColor,
            offset: Offset(0, 0),
            blurRadius: highlightBlur),
        //Shadow(color: globalAlmostWhite, offset: Offset(0, 0), blurRadius: 10),
      ],
    );
  }
}

class BorderedIcon extends StatelessWidget {
  double size;
  IconData icon;
  Color color;
  Color borderColor;
  bool? visible;
  BorderedIcon(
      {Key? key,
      required this.size,
      required this.icon,
      required this.color,
      required this.borderColor,
      this.visible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (visible == null) {
      visible = true;
    }
    return Visibility(
      visible: visible!,
      child: new DecoratedIcon(
        icon,
        color: color,
        size: size,
        shadows: [
          Shadow(color: borderColor, offset: Offset(0, 0), blurRadius: 2),
          //Shadow(color: globalAlmostWhite, offset: Offset(0, 0), blurRadius: 10),
          // Shadow(
          //   offset: Offset(4.0, 3.0),
          //   blurRadius: 10,
          //   color: borderColor,
          // ),
        ],
      ),
    );
  }
}
