import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../../style/ThemeData.dart';

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

class DTubeLogoPulseRotating extends StatefulWidget {
  DTubeLogoPulseRotating({Key? key, required this.size}) : super(key: key);
  double size;
  @override
  _DTubeLogoPulseRotatingState createState() => _DTubeLogoPulseRotatingState();
}

class _DTubeLogoPulseRotatingState extends State<DTubeLogoPulseRotating>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (_, child) {
        return Transform.rotate(
            angle: _rotationController.value * 2 * pi,
            child: DTubeLogoPulse(
              size: widget.size,
            ));
      },
    );
  }
}

class DtubeLogoPulseWithSubtitle extends StatelessWidget {
  DtubeLogoPulseWithSubtitle(
      {Key? key, required this.subtitle, required this.size})
      : super(key: key);
  String subtitle;
  double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size * 2,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DTubeLogoPulse(
            size: size,
          ),
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Container(
              width: size * 1.2,
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class DTubeLogoPulseWave extends StatefulWidget {
  DTubeLogoPulseWave(
      {Key? key, required this.size, required this.progressPercent})
      : super(key: key);
  double size;
  double progressPercent;
  @override
  _DTubeLogoPulseWaveState createState() => _DTubeLogoPulseWaveState();
}

class _DTubeLogoPulseWaveState extends State<DTubeLogoPulseWave>
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
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          Center(
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: WaveWidget(
                  config: CustomConfig(
                    colors: [
                      Colors.blue[300]!,
                      Colors.blue[600]!,
                      Colors.blue[800]!,
                      Colors.blue[900]!,
                    ],
                    durations: [18000, 8000, 5000, 12000],
                    heightPercentages: [
                      0.99 - widget.progressPercent / 100,
                      0.86 - widget.progressPercent / 100,
                      0.88 - widget.progressPercent / 100,
                      0.90 - widget.progressPercent / 100,
                    ],
                    //heightPercentages: [0.25, 0.26, 0.28, 0.31],
                  ),
                  waveAmplitude: 0,
                  size: Size(
                    widget.size,
                    widget.size,
                  ),
                ),
              ),
            ),
          ),
          Center(child: DTubeLogoShadowed(size: widget.size * 0.6)),
        ],
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
