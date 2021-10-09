import 'package:dtube_go/utils/randomGenerator.dart';
import 'package:flutter_animator/flutter_animator.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/tags/TagList.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagChip extends StatelessWidget {
  String tagName;
  bool fadeInFromLeft;
  double width;
  Duration waitBeforeFadeIn;
  TagChip(
      {Key? key,
      required this.tagName,
      required this.width,
      required this.fadeInFromLeft,
      required this.waitBeforeFadeIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fadeInFromLeft) {
      return FadeInLeftBig(
        preferences: AnimationPreferences(
            offset: waitBeforeFadeIn, duration: Duration(seconds: 1)),
        child: TagChipWidget(tagName: tagName, width: width),
      );
    } else {
      return FadeInRightBig(
        preferences: AnimationPreferences(
            offset: waitBeforeFadeIn, duration: Duration(seconds: 1)),
        child: TagChipWidget(tagName: tagName, width: width),
      );
    }
  }
}

class TagChipWidget extends StatelessWidget {
  const TagChipWidget({
    Key? key,
    required this.tagName,
    required this.width,
  }) : super(key: key);

  final String tagName;
  final double width;

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
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
