import 'package:flutter/material.dart';

import 'ThemeData.dart';

class DTubeLogoPulse extends StatefulWidget {
  const DTubeLogoPulse({
    Key? key,
  }) : super(key: key);

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
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
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
    double _circleWidth = MediaQuery.of(context).size.width / 3;
    return Container(
      width: _circleWidth,
      height: _circleWidth,
      child: Center(
        child: Image.asset(
          'assets/images/dtube_logo_white.png',
          fit: BoxFit.fitWidth,
          width: _circleWidth - 42,
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
