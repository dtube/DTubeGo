import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class OverlayText extends StatelessWidget {
  OverlayText(
      {Key? key,
      required this.text,
      this.sizeMultiply,
      this.maxLines,
      this.overflow,
      this.bold,
      this.color})
      : super(key: key);

  final String text;
  double? sizeMultiply;
  int? maxLines;
  TextOverflow? overflow;
  bool? bold;
  Color? color;

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
        color: color != null ? color : globalAlmostWhite,
        shadows: [
          Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 2),
          //Shadow(color: globalAlmostWhite, offset: Offset(0, 0), blurRadius: 10),
          Shadow(
            offset: Offset(4.0, 3.0),
            blurRadius: 10,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
