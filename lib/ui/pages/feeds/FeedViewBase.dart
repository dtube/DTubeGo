import 'package:dtube_togo/ui/pages/feeds/lists/FeedList.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

typedef Bool2VoidFunc = void Function(bool);

class FeedViewBase extends StatelessWidget {
  String feedType;

  bool largeFormat;
  bool showAuthor;

  Bool2VoidFunc scrollCallback;
  FeedViewBase({
    Key? key,
    required this.feedType,
    required this.largeFormat,
    required this.showAuthor,
    required this.scrollCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (SizerUtil.orientation == Orientation.portrait) {
      return FeedList(
          feedType: feedType,
          largeFormat: largeFormat,
          showAuthor: showAuthor,
          scrollCallback: scrollCallback);
    } else {
      return Align(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 80.w,
              child: FeedList(
                  feedType: feedType,
                  largeFormat: false,
                  showAuthor: showAuthor,
                  scrollCallback: scrollCallback),
            ),
            //Container(width: 20.w, child: Text("test"))
          ],
        ),
      );
    }
  }
}
