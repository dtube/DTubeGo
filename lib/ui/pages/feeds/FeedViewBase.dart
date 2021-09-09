import 'package:dtube_togo/ui/pages/feeds/lists/FeedList.dart';
import 'package:dtube_togo/ui/pages/feeds/PostDetailPageInlineView.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/utils/ResponsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class FeedViewBase extends StatefulWidget {
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
  State<FeedViewBase> createState() => _FeedViewBaseState();
}

class _FeedViewBaseState extends State<FeedViewBase> {
  String? postAuthor;
  String? postLink;
  ValueNotifier<List<String>> _notifierPost = ValueNotifier(["", ""]);

  void showPost(List<String> params) {
// params: author, link
    // setState(() {
    _notifierPost.value[0] = params[0];
    _notifierPost.value[1] = params[1];
    _notifierPost.value = [params[0], params[1]];
    //});
  }

  void dispose() {
    _notifierPost.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      portrait: FeedList(
        feedType: widget.feedType,
        largeFormat: widget.largeFormat,
        showAuthor: widget.showAuthor,
        scrollCallback: widget.scrollCallback,
        enableNavigation: true,
      ),
      landscape: Align(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 40.w,

              child: FeedList(
                  feedType: widget.feedType,
                  largeFormat: false,
                  showAuthor: widget.showAuthor,
                  scrollCallback: widget.scrollCallback,
                  topPaddingForFirstEntry: 5.h,
                  heightPerEntry: 10.h,
                  width: 40.w,
                  enableNavigation: false,
                  itemSelectedCallback: showPost),
              // child: Text("test")
            ),
            ValueListenableBuilder(
                valueListenable: _notifierPost,
                builder:
                    (BuildContext context, List<String> vals, Widget? child) {
                  print(vals);
                  return PostView(
                    postAuthor: vals[0],
                    postLink: vals[1],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class PostView extends StatefulWidget {
  String? postAuthor;
  String? postLink;
  PostView({Key? key, required this.postAuthor, required this.postLink})
      : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: "jlTUhhHSX00",
      params: YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: false,
          desktopMode: true,
          privacyEnhanced: true,
          useHybridComposition: true,
          autoPlay: false),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.postAuthor != null && widget.postAuthor != ""
        ? Container(
            width: 60.w,
            height: 300.h,
            child: PostDetailPageInlineView(
              author: widget.postAuthor!,
              link: widget.postLink!,
              directFocus: "none",
              recentlyUploaded: false,
              yTController: _controller,
            ),
          )
        : Container(
            width: 60.w,
            height: 100.h,
            child: Center(child: Text("no post selected")));
  }
}
