import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';

class ColorChangeCircularProgressIndicator extends StatefulWidget {
  const ColorChangeCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  State<ColorChangeCircularProgressIndicator> createState() =>
      _ColorChangeCircularProgressIndicatorState();
}

class _ColorChangeCircularProgressIndicatorState
    extends State<ColorChangeCircularProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: animationController
            .drive(ColorTween(begin: globalBlue, end: globalRed)),
      ),
    );
  }
}
