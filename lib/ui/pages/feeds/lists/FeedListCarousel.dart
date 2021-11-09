import 'package:carousel_slider/carousel_slider.dart';
import 'package:dtube_go/utils/randomGenerator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';

import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardNarrow.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class FeedListCarousel extends StatelessWidget {
  String feedType;
  String? username;
  bool largeFormat;
  bool showAuthor;
  double? topPaddingForFirstEntry;
  double? sidepadding;
  double? bottompadding;
  double? width;
  double? heightPerEntry;
  bool enableNavigation;
  ListOfString2VoidFunc?
      itemSelectedCallback; // only used in landscape mode for now

  Bool2VoidFunc scrollCallback;
  late YoutubePlayerController _youtubePlayerController;

  FeedListCarousel({
    required this.feedType,
    this.username,
    required this.largeFormat,
    required this.showAuthor,
    required this.scrollCallback,
    this.topPaddingForFirstEntry,
    this.sidepadding,
    this.bottompadding,
    this.width,
    this.heightPerEntry,
    required this.enableNavigation,
    this.itemSelectedCallback,
    Key? key,
  }) : super(key: key);

  late FeedBloc postBloc;
  final ScrollController _scrollController = ScrollController();
  List<FeedItem> _feedItems = [];

  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;
  String? _defaultCommentVotingWeight;
  String? _defaultPostVotingWeight;
  String? _defaultPostVotingTip;

  Future<bool> getSettings() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultCommentVotingWeight = await sec.getDefaultVoteComments();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();

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
      topPaddingForFirstEntry = 16.h;
    }

    if (width == null) {
      width = 100.w;
    }

    if (heightPerEntry == null) {
      heightPerEntry = 10.h;
    }

    return FutureBuilder<bool>(
        future: getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return Container(
              height: 42.h,
              width: width,
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state is FeedInitialState ||
                      state is FeedLoadingState && _feedItems.isEmpty) {
                    return buildLoading(context);
                  } else if (state is FeedLoadedState) {
                    if (state.feedType == feedType) {
                      if (_feedItems.isNotEmpty) {
                        if (_feedItems.first.link == state.feed.first.link) {
                          _feedItems.clear();
                        } else {
                          _feedItems.removeLast();
                        }
                      }
                      _feedItems.addAll(state.feed);
                    }
                    BlocProvider.of<FeedBloc>(context).isFetching = false;
                  } else if (state is FeedErrorState) {
                    return buildErrorUi(state.message);
                  }
                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: sidepadding != null ? sidepadding! : 0.0,
                          right: sidepadding != null ? sidepadding! : 0.0,
                        ),
                        child: buildPostList(
                            _feedItems, largeFormat, true, context, feedType),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: feedType == "UserFeed" ? 0.h : 15.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black.withOpacity(0.0),
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ])),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return feedType == "UserFeed"
        ? SizedBox(height: 0, width: 0)
        : Center(
            child: DtubeLogoPulseWithSubtitle(
              subtitle: "loading feed..",
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

  Widget buildPostList(List<FeedItem> feed, bool bigThumbnail, bool showAuthor,
      BuildContext context, String gpostType) {
    return Container(
      height: 50.h,
      child: CarouselSlider.builder(
        options: CarouselOptions(
            //aspectRatio: 2.0,
            enlargeCenterPage: true,
            autoPlay: true,
            disableCenter: true,
            autoPlayInterval: Duration(seconds: generateRandom(4, 7))),
        itemCount: feed.length,
        itemBuilder: (ctx, index, realIdx) {
          if (feed[index].jsonString!.files?.youtube != null ||
              feed[index].jsonString!.files?.ipfs != null ||
              feed[index].jsonString!.files?.sia != null) {
            if ((_nsfwMode == 'Hide' && feed[index].jsonString?.nsfw == 1) ||
                (_hiddenMode == 'Hide' && feed[index].summaryOfVotes < 0) ||
                (feed[index].jsonString!.hide == 1 &&
                    feed[index].author != _applicationUser)) {
              return SizedBox(
                height: 0,
              );
            } else {
              return BlocProvider<UserBloc>(
                create: (context) => UserBloc(repository: UserRepositoryImpl()),
                child: PostListCard(
                  width: width!,
                  heightPerEntry: heightPerEntry!,
                  largeFormat: largeFormat,
                  showAuthor: showAuthor,
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
                  duration: new Duration(
                      seconds: int.tryParse(feed[index].jsonString!.dur) != null
                          ? int.parse(feed[index].jsonString!.dur)
                          : 0),
                  thumbnailUrl: feed[index].thumbUrl,
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
                  feedType: feedType,
                  defaultCommentVotingWeight: _defaultCommentVotingWeight,
                  defaultPostVotingWeight: _defaultPostVotingWeight,
                  defaultPostVotingTip: _defaultPostVotingTip,
                ),
                //Text(pos.toString())
              );
            }
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  top: index == 0 ? topPaddingForFirstEntry! : 0.0),
              child: SizedBox(
                height: 0,
              ),
            );
          }
        },
      ),
    );
  }
}

class PostListCard extends StatefulWidget {
  final bool showAuthor;
  final bool largeFormat;
  final bool blur;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;
  final Duration duration;
  final String dtcValue;
  final String videoUrl;
  final String videoSource;
  final bool alreadyVoted;
  final bool alreadyVotedDirection;
  final int upvotesCount;
  final int downvotesCount;
  final int indexOfList;
  final String mainTag;
  final bool oc;
  final double width;
  final double heightPerEntry;
  final bool enableNavigation;
  ListOfString2VoidFunc? itemSelectedCallback;
  final String feedType;
  final String? defaultCommentVotingWeight;
  final String? defaultPostVotingWeight;
  final String? defaultPostVotingTip;

  PostListCard(
      {Key? key,
      required this.showAuthor,
      required this.largeFormat,
      required this.blur,
      required this.thumbnailUrl,
      required this.title,
      required this.description,
      required this.author,
      required this.link,
      required this.publishDate,
      required this.duration,
      required this.dtcValue,
      required this.videoUrl,
      required this.videoSource,
      required this.alreadyVoted,
      required this.alreadyVotedDirection,
      required this.upvotesCount,
      required this.downvotesCount,
      required this.indexOfList,
      required this.mainTag,
      required this.oc,
      required this.width,
      required this.heightPerEntry,
      required this.enableNavigation,
      this.itemSelectedCallback,
      required this.feedType,
      this.defaultCommentVotingWeight,
      this.defaultPostVotingWeight,
      this.defaultPostVotingTip})
      : super(key: key);

  @override
  State<PostListCard> createState() => _PostListCardState();
}

class _PostListCardState extends State<PostListCard>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return PostListCardNarrow(
      width: widget.width,
      height: widget.heightPerEntry,
      blur: widget.blur,
      thumbnailUrl: widget.thumbnailUrl,
      title: widget.title,
      description: widget.description,
      author: widget.author,
      link: widget.link,
      publishDate: widget.publishDate,
      duration: widget.duration,
      dtcValue: widget.dtcValue,
      indexOfList: widget.indexOfList,
      enableNavigation: widget.enableNavigation,
      itemSelectedCallback: widget.itemSelectedCallback,
      userPage: widget.feedType == "UserFeed",
      //),
    );
  }
}
