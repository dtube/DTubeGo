import 'package:flutter/material.dart';

import 'ThemeData.dart';

class DTubeLogoPulse extends StatefulWidget {
  DTubeLogoPulse({Key? key, required this.size}) : super(key: key);
  double size;
  @override
  _DTubeLogoPulseState createState() => _DTubeLogoPulseState();
}

class _DTubeLogoPulseState extends State<DTubeLogoPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation =
        Tween(begin: 0.0, end: widget.size * 0.1).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _circleWidth = widget.size;
    return Container(
      width: _circleWidth,
      height: _circleWidth,
      child: Center(
        child: Image.asset(
          'assets/images/dtube_logo_white.png',
          fit: BoxFit.fitWidth,
          width: _circleWidth * 0.6,
        ),
      ),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: globalBlue, boxShadow: [
        BoxShadow(
            color: globalRed,
            blurRadius: _animation.value,
            spreadRadius: _animation.value)
      ]),
    );
  }
}
