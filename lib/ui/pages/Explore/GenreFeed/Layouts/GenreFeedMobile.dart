import 'package:dtube_go/bloc/user/user_bloc.dart';
import 'package:dtube_go/bloc/user/user_repository.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardNarrow.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedList.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;


typedef Bool2VoidFunc = void Function(bool);

class GenreFeedMobile extends StatefulWidget {
  GenreFeedMobile({Key? key}) : super(key: key);
  List<FeedItem> _feedItems = [];

  @override
  State<GenreFeedMobile> createState() => _GenreFeedMobileState();
}

class _GenreFeedMobileState extends State<GenreFeedMobile> {

  late FeedBloc postBloc;
  final ScrollController _scrollController = ScrollController();
  //final ScrollController _scrollController = ScrollController();

  List<FontAwesomeIcons> genreIcons = [];
  List<String> genreSubTagStrings = [];
  List<FeedItem> _feedItems = [];
  double? topPaddingForFirstEntry;
  double? sidepadding;
  double? bottompadding;
  double? width;
  double? heightPerEntry;
  final bool enableNavigation = true;
  final itemSelectedCallback = (bool) {}; // only used in landscape mode for now
  double? topPadding;

  final Bool2VoidFunc scrollCallback = (bool) {};
  final int tabletCrossAxisCount = 4;
  final int desktopCrossAxisCount = 4;

  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;
  String? _defaultCommentVotingWeight;
  String? _defaultPostVotingWeight;
  String? _defaultPostVotingTip;

  String? _fixedDownvoteActivated;
  String? _fixedDownvoteWeight;

  bool? _autoPauseVideoOnPopup;
  bool? showBorder;
  bool? disablePlayback;
  bool? hideSpeedDial;

  Future<bool> getDisplayModes() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
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
    if (topPaddingForFirstEntry == null) {
      topPaddingForFirstEntry = 0;
    }
    if (topPadding == null) {
      topPadding = 0;
    }

    if (heightPerEntry == null) {
      heightPerEntry = 10.h;
    }
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
    return MasonryGridView.count(
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
      crossAxisCount: 2,
      itemCount: feed.length,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 4.0,
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
            : PostListCard(
          width: 100.w,
          heightPerEntry: heightPerEntry!,
          largeFormat: false,
          showAuthor: true,
          blur: (_nsfwMode == 'Blur' &&
              feed[index].jsonString?.nsfw == 1) ||
              (_hiddenMode == 'Blur' &&
                  feed[index].summaryOfVotes < 0)
              ? true
              : false,
          title: feed[index].jsonString!.title,
          description: feed[index].jsonString!.desc != null
              ? feed[index].jsonString!.desc!
              : "",
          author: feed[index].author,
          link: feed[index].link,
          publishDate: TimeAgo.timeInAgoTSShort(feed[index].ts),
          dtcValue: (feed[index].dist / 100).round().toString(),
          showDTCValue: false,
          duration: new Duration(
              seconds: int.tryParse(feed[index].jsonString!.dur) != null
                  ? int.parse(feed[index].jsonString!.dur)
                  : 0),
          thumbnailUrl: feed[index].thumbUrl!,
          videoUrl: feed[index].videoUrl,
          videoSource: feed[index].videoSource,
          alreadyVoted: feed[index].alreadyVoted!,
          alreadyVotedDirection: feed[index].alreadyVotedDirection!,
          upvotesCount: feed[index].upvotes!.length,
          downvotesCount: feed[index].downvotes!.length,
          indexOfList: index,
          mainTag: feed[index].jsonString!.tag,
          oc: feed[index].jsonString!.oc == 1 ? true : false,
          enableNavigation: enableNavigation,
          itemSelectedCallback: itemSelectedCallback,
          feedType: "explore",
          defaultCommentVotingWeight: _defaultCommentVotingWeight,
          defaultPostVotingWeight: _defaultPostVotingWeight,
          defaultPostVotingTip: _defaultPostVotingTip,
          fixedDownvoteActivated: _fixedDownvoteActivated,
          fixedDownvoteWeight: _fixedDownvoteWeight,
          parentContext: context,
          autoPauseVideoOnPopup: _autoPauseVideoOnPopup,
        ),
        //Text(pos.toString())
      ),
                //Text(pos.toString())

      );
      //staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
  }
}
