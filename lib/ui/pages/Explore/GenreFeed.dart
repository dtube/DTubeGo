import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Bool2VoidFunc = void Function(bool);

class GenreFeed extends StatefulWidget {
  GenreFeed({Key? key}) : super(key: key);

  @override
  State<GenreFeed> createState() => _GenreFeedState();
}

class _GenreFeedState extends State<GenreFeed> {
  late FeedBloc postBloc;

  //final ScrollController _scrollController = ScrollController();

  List<FontAwesomeIcons> genreIcons = [];
  List<String> genreSubTagStrings = [];
  List<FeedItem> _feedItems = [];

  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;

  Future<bool> getDisplayModes() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    if (_nsfwMode == null) {
      _nsfwMode = 'Blur';
    }
    if (_hiddenMode == null) {
      _hiddenMode = 'Hide';
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getDisplayModes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return Container(
              height: 100.h,
              child: Stack(
                children: [
                  BlocBuilder<FeedBloc, FeedState>(
                    builder: (context, state) {
                      if (state is FeedInitialState ||
                          state is FeedLoadingState) {
                        _feedItems = [];
                        return buildLoading(context);
                      } else if (state is FeedLoadedState) {
                        _feedItems = [];
                        _feedItems.addAll(state.feed);
                        BlocProvider.of<FeedBloc>(context).isFetching = false;
                      } else if (state is FeedErrorState) {
                        return buildErrorUi(state.message);
                      }
                      return buildPostList(_feedItems, context);
                    },
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return Container(
      height: 100.h,
      child: DtubeLogoPulseWithSubtitle(
        subtitle: "loading posts..",
        size: 40.w,
      ),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildPostList(List<FeedItem> feed, BuildContext context) {
    return StaggeredGridView.countBuilder(
      // controller: _scrollController
      //   ..addListener(() {
      //     if (_scrollController.offset >=
      //             _scrollController.position.maxScrollExtent &&
      //         !BlocProvider.of<FeedBloc>(context).isFetching) {
      //       BlocProvider.of<FeedBloc>(context)
      //         ..isFetching = true
      //         ..add(FetchFeedEvent(
      //             feedType: "HotFeed",
      //             fromAuthor: feed[feed.length - 1].author,
      //             fromLink: feed[feed.length - 1].link));
      //     }

      //     if (_scrollController.offset <=
      //             _scrollController.position.minScrollExtent &&
      //         !BlocProvider.of<FeedBloc>(context).isFetching) {
      //       _feedItems.clear();
      //       if (widget.searchTags != "") {
      //         BlocProvider.of<FeedBloc>(context)
      //           ..isFetching = true
      //           ..add(FetchTagSearchResults(tags: widget.searchTags));
      //       } else {
      //         BlocProvider.of<FeedBloc>(context)
      //           ..isFetching = true
      //           ..add(FetchFeedEvent(feedType: "HotFeed"));
      //       }
      //     }
      //   }),
      padding: EdgeInsets.only(top: 19.h),
      crossAxisCount: 4,
      itemCount: feed.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToPostDetailPage(context, feed[index].author,
              feed[index].link, "none", false, () {});
        },
        child: (feed[index].summaryOfVotes < 0 ||
                feed[index].jsonString?.hide == 1 ||
                feed[index].jsonString?.nsfw == 1)
            ? SizedBox(
                height: 0,
              )
            : new CachedNetworkImage(
                imageUrl: feed[index].thumbUrl,
                placeholder: (context, url) => Container(
                    //width: widget.avatarSize,
                    height: 15.h,
                    child: Container(
                      height: 10.h,
                      child: DTubeLogoPulse(
                        size: 10.h,
                      ),
                    )),
                errorWidget: (context, url, error) => Container(
                    color: globalBGColor,
                    //width: widget.avatarSize,
                    height: 20.h,
                    child: Container(
                        height: 10.h,
                        child: Image.asset(
                          'assets/images/dtube_logo_white.png',
                          fit: BoxFit.fitHeight,
                        ))),
              ),
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
