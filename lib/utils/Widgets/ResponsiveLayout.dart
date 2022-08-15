import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

  const ResponsiveLayout(
      {Key? key, required this.portrait, required this.landscape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Device.orientation == Orientation.portrait) {
      return portrait;
    } else {
      return landscape;
    }
  }
}
