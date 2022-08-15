import 'package:dtube_go/ui/pages/feeds/lists/FeedList.dart';
import 'package:dtube_go/ui/pages/feeds/PostDetailPageInlineView.dart';
import 'package:dtube_go/utils/WIdgets/ResponsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

typedef Bool2VoidFunc = void Function(bool);

class FeedViewBase extends StatefulWidget {
  final String feedType;

  final bool largeFormat;
  final bool showAuthor;
  final double? topPadding;

  final Bool2VoidFunc scrollCallback;

  FeedViewBase(
      {Key? key,
      required this.feedType,
      required this.largeFormat,
      required this.showAuthor,
      required this.scrollCallback,
      this.topPadding})
      : super(key: key);

  @override
  State<FeedViewBase> createState() => _FeedViewBaseState();
}

class _FeedViewBaseState extends State<FeedViewBase>
    with AutomaticKeepAliveClientMixin<FeedViewBase> {
  String? postAuthor;
  String? postLink;
  ValueNotifier<List<String>> _notifierPost = ValueNotifier(["", ""]);

  void showPost(List<String> params) {
    _notifierPost.value[0] = params[0];
    _notifierPost.value[1] = params[1];
    _notifierPost.value = [params[0], params[1]];
  }

  @override
  void dispose() {
    _notifierPost.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FeedList(
        feedType: widget.feedType,
        largeFormat: widget.largeFormat,
        showAuthor: widget.showAuthor,
        scrollCallback: widget.scrollCallback,
        enableNavigation: true,
        topPadding: widget.topPadding != null ? widget.topPadding : 0);
  }
}

class PostView extends StatefulWidget {
  final String? postAuthor;
  final String? postLink;
  PostView({Key? key, required this.postAuthor, required this.postLink})
      : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.postAuthor != null && widget.postAuthor != ""
        ? Container(
            width: 53.w,
            height: 300.h,
            decoration: BoxDecoration(border: Border()),
            child: Align(
              alignment: Alignment.topLeft,
              child: PostDetailPageInlineView(
                author: widget.postAuthor!,
                link: widget.postLink!,
                directFocus: "none",
                recentlyUploaded: false,
              ),
            ),
          )
        : Container(
            width: 50.w,
            height: 100.h,
            child: Center(child: Text("no post selected")));
  }
}
