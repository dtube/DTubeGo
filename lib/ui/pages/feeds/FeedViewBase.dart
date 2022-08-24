import 'package:dtube_go/ui/pages/feeds/lists/FeedList.dart';

import 'package:flutter/material.dart';

typedef Bool2VoidFunc = void Function(bool);

class FeedViewBase extends StatelessWidget {
  const FeedViewBase(
      {Key? key,
      required this.feedType,
      required this.largeFormat,
      required this.showAuthor,
      required this.scrollCallback,
      this.topPadding})
      : super(key: key);
  final String feedType;

  final bool largeFormat;
  final bool showAuthor;
  final double? topPadding;

  final Bool2VoidFunc scrollCallback;

  @override
  Widget build(BuildContext context) {
    return FeedList(
      feedType: feedType,
      largeFormat: largeFormat,
      showAuthor: showAuthor,
      scrollCallback: scrollCallback,
      enableNavigation: true,
      topPadding: topPadding != null ? topPadding : 0,
      tabletCrossAxisCount: 2,
      desktopCrossAxisCount: 5,
    );
  }
}
