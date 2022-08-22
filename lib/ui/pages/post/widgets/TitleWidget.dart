import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {Key? key,
      required this.title,
      required this.author,
      required this.width})
      : super(key: key);

  final String title;
  final String author;
  final double width;
  final double chipWidth = 230;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width - 10 - chipWidth,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline3,
            maxLines: 3,
          ),
        ),
        Container(
          child: globals.disableAnimations
              ? AccountNavigationChip(
                  author: author,
                  size: chipWidth,
                )
              : SlideInDown(
                  preferences:
                      AnimationPreferences(offset: Duration(milliseconds: 500)),
                  child: AccountNavigationChip(author: author, size: chipWidth),
                ),
        ),
      ],
    );
  }
}
