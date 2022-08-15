import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class DTubeLogo extends StatelessWidget {
  final double size;
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
  final double size;
  DTubeLogoShadowed({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
