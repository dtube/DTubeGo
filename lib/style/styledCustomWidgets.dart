import 'package:flutter/services.dart';
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

class DTubeLogoShadowed extends StatelessWidget {
  double size;
  DTubeLogoShadowed({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: SimpleShadow(
          child: Image.asset('assets/images/dtube_logo_white.png'),
          opacity: 0.5, // Default: 0.5
          color: Colors.black, // Default: Black
          offset: Offset(200, 200), // Default: Offset(2, 2)
          sigma: 80,
          // Default: 2
        ),
      ),
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
          Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 2),
          //Shadow(color: Colors.white, offset: Offset(0, 0), blurRadius: 10),
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
        Shadow(color: shadowColor, offset: Offset(0, 0), blurRadius: 2),
        //Shadow(color: Colors.white, offset: Offset(0, 0), blurRadius: 10),
        Shadow(
          offset: Offset(4.0, 3.0),
          blurRadius: 10,
          color: shadowColor,
        ),
      ],
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
        //Shadow(color: Colors.white, offset: Offset(0, 0), blurRadius: 10),
      ],
    );
  }
}

class OverlayTextInput extends StatelessWidget {
  const OverlayTextInput(
      {Key? key,
      required this.textEditingController,
      required this.label,
      required this.autoFocus})
      : super(key: key);

  final TextEditingController textEditingController;
  final String label;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      //key: UniqueKey(),
      autofocus: autoFocus,
      controller: textEditingController,
      style: Theme.of(context).textTheme.headline5,
      cursorColor: globalRed,
      maxLines: 4,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20.0, top: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: globalRed,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: globalRed,
              width: 2.0,
            ),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: Theme.of(context).textTheme.headline5),
    );
  }
}

class OverlayNumberInput extends StatelessWidget {
  OverlayNumberInput({
    Key? key,
    required this.autoFocus,
    required this.textEditingController,
    required this.label,
  }) : super(key: key);

  final bool autoFocus;
  final TextEditingController textEditingController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: globalRed,
      autofocus: autoFocus,
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: globalRed,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: globalRed,
              width: 2.0,
            ),
          ),
          labelText: label,
          labelStyle: Theme.of(context).textTheme.headline5),
      style: Theme.of(context).textTheme.headline5,
      controller: textEditingController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
      ],
    );
  }
}
