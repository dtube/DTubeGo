import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomChoiceCard extends StatelessWidget {
  CustomChoiceCard(
      {Key? key,
      required this.backgroundColor,
      required this.height,
      required this.icon,
      required this.iconColor,
      required this.iconSize,
      required this.label,
      required this.onTapped,
      required this.textStyle,
      required this.width})
      : super(key: key);

  final VoidCallback onTapped;
  final double width;
  final double height;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String label;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: GestureDetector(
          child: Card(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: FaIcon(icon, size: iconSize, color: iconColor)),
                    Text(label, style: textStyle)
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            onTapped();
          }),
    );
  }
}
