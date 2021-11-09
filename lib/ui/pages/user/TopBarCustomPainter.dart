import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TopBarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    // mainBackground.addRect(Rect.fromLTRB(0, 0, 10, 10));
    paint.color = Colors.blue.shade700;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    // Start paint from 20% height to the left
    // ovalPath.moveTo(0, height * 0.2);
    ovalPath.moveTo(0, 0);
// paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(0, 0, 0.w, 15.h);
    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(0, 25.h, 15.w, 25.h);
    ovalPath.quadraticBezierTo(125.w, 25.h, 125.w, 25.h);
    ovalPath.quadraticBezierTo(125.w, 0, 125.w, 0);

    ovalPath.lineTo(0, height);

    ovalPath.close();

    paint.color = Colors.blue.shade600;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
