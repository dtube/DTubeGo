import 'package:flutter_animator/flutter_animator.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/tags/TagList.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagChip extends StatelessWidget {
  String tagName;
  bool fadeInFromLeft;
  double width;
  Duration waitBeforeFadeIn;
  TextStyle? fontStyle;
  TagChip(
      {Key? key,
      required this.tagName,
      required this.width,
      required this.fadeInFromLeft,
      required this.waitBeforeFadeIn,
      this.fontStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fadeInFromLeft) {
      return FadeInLeftBig(
        preferences: AnimationPreferences(
            offset: waitBeforeFadeIn, duration: Duration(seconds: 1)),
        child: TagChipWidget(
          tagName: tagName,
          width: width,
          fontStyle: fontStyle,
        ),
      );
    } else {
      return FadeInRightBig(
        preferences: AnimationPreferences(
            offset: waitBeforeFadeIn, duration: Duration(seconds: 1)),
        child:
            TagChipWidget(tagName: tagName, width: width, fontStyle: fontStyle),
      );
    }
  }
}

class TagChipWidget extends StatelessWidget {
  TagChipWidget(
      {Key? key,
      required this.tagName,
      required this.width,
      required this.fontStyle})
      : super(key: key);

  final String tagName;
  final double width;
  TextStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                  create: (context) =>
                      UserBloc(repository: UserRepositoryImpl())),
              BlocProvider(
                  create: (context) =>
                      FeedBloc(repository: FeedRepositoryImpl())),
            ],
            child: TagList(
              tagName: tagName,
            ),
          );
        }));
      },
      label: Container(
        width: width,
        child: Center(
          child: Text(
            tagName,
            style: fontStyle != null
                ? fontStyle
                : Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
