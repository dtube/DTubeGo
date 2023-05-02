import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardNarrow.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class FeedListSuggested extends StatelessWidget {
  String feedType;
  String? username;
  bool largeFormat;
  bool showAuthor;
  double? sidepadding;

  double width;
  double? heightPerEntry;
  bool enableNavigation;
  ListOfString2VoidFunc?
      itemSelectedCallback; // only used in landscape mode for now
  double? topPadding;

  Bool2VoidFunc scrollCallback;
  late YoutubePlayerController _youtubePlayerController;

  FeedListSuggested({
    required this.feedType,
    this.username,
    required this.largeFormat,
    required this.showAuthor,
    required this.scrollCallback,
    this.sidepadding,
    required this.width,
    this.heightPerEntry,
    required this.enableNavigation,
    this.itemSelectedCallback,
    this.topPadding,
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

  String? _fixedDownvoteActivated;
  String? _fixedDownvoteWeight;
  bool? _autoPauseOnPopup;
  bool? _disableAnimation;

  Future<bool> getSettings() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultCommentVotingWeight = await sec.getDefaultVoteComments();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();

    _fixedDownvoteActivated = await sec.getFixedDownvoteActivated();
    _fixedDownvoteWeight = await sec.getFixedDownvoteWeight();
    _autoPauseOnPopup = await sec.getVideoAutoPause() == "true";
    _disableAnimation = await sec.getDisableAnimations() == "true";

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
    if (heightPerEntry == null) {
      heightPerEntry = 10.h;
    }

    return Center(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: sidepadding != null ? sidepadding! : 0.0,
              right: sidepadding != null ? sidepadding! : 0.0,
            ),
            child: FutureBuilder<bool>(
                future: getSettings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return buildLoading(context);
                  } else {
                    return Container(
                      // height: heightPerEntry! * 1.5,
                      width: width,
                      child: BlocBuilder<FeedBloc, FeedState>(
                        builder: (context, state) {
                          if (state is FeedInitialState ||
                              state is FeedLoadingState && _feedItems.isEmpty) {
                            return buildLoading(context);
                          } else if (state is FeedLoadedState) {
                            if (state.feedType == feedType) {
                              if (state.feedType == "tagSearch") {
                                _feedItems.clear();
                              }
                              if (_feedItems.isNotEmpty) {
                                if (_feedItems.first.link ==
                                    state.feed.first.link) {
                                  _feedItems.clear();
                                } else {
                                  _feedItems.removeLast();
                                }
                              }
                              _feedItems.addAll(state.feed);
                            }
                            BlocProvider.of<FeedBloc>(context).isFetching =
                                false;
                          } else if (state is FeedErrorState) {
                            return buildErrorUi(state.message);
                          }
                          return buildPostList(
                              _feedItems, largeFormat, true, context, feedType);
                        },
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return feedType == "UserFeed"
        ? SizedBox(height: 0, width: 0)
        : Center(
            child: DtubeLogoPulseWithSubtitle(
              subtitle: "loading feed..",
              size: kIsWeb ? 10.w : 40.w,
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
    return ListView.builder(
      key: new PageStorageKey(gpostType + 'listview'),
      addAutomaticKeepAlives: true,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: feed.length,
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !BlocProvider.of<FeedBloc>(context).isFetching &&
              feedType != "UserFeed" &&
              feedType != "tagSearch") {
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(
                  //feedType: widget.feedType,
                  feedType: feedType,
                  fromAuthor: feed[feed.length - 1].author,
                  fromLink: feed[feed.length - 1].link));
          }
          if (_scrollController.offset <=
                  _scrollController.position.minScrollExtent &&
              !BlocProvider.of<FeedBloc>(context).isFetching &&
              feedType != "UserFeed" &&
              feedType != "tagSearch") {
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(
                //feedType: widget.feedType,
                feedType: feedType,
              ));
          }
        }),
      itemBuilder: (ctx, pos) {
        // work on more sources
        if (feed[pos].jsonString!.files?.youtube != null ||
            feed[pos].jsonString!.files?.ipfs != null ||
            feed[pos].jsonString!.files?.sia != null) {
          if ((_nsfwMode == 'Hide' && feed[pos].jsonString?.nsfw == 1) ||
              (_hiddenMode == 'Hide' && feed[pos].summaryOfVotes < 0) ||
              (feed[pos].jsonString!.hide == 1 &&
                  feed[pos].author != _applicationUser)) {
            return Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: SizedBox(
                height: 0,
              ),
            );
          } else {
            return BlocProvider<UserBloc>(
              create: (context) => UserBloc(repository: UserRepositoryImpl()),

              child: PostListCard(
                width: width,
                heightPerEntry: heightPerEntry!,
                largeFormat: largeFormat,
                showAuthor: showAuthor,
                blur: (_nsfwMode == 'Blur' &&
                            feed[pos].jsonString?.nsfw == 1) ||
                        (_hiddenMode == 'Blur' && feed[pos].summaryOfVotes < 0)
                    ? true
                    : false,
                title: feed[pos].jsonString!.title,
                description: feed[pos].jsonString!.desc != null
                    ? feed[pos].jsonString!.desc!
                    : "",
                author: feed[pos].author,
                link: feed[pos].link,
                publishDate: TimeAgo.timeInAgoTSShort(feed[pos].ts),
                dtcValue: (feed[pos].dist / 100).round().toString(),
                duration: new Duration(
                    seconds: int.tryParse(feed[pos].jsonString!.dur) != null
                        ? int.parse(feed[pos].jsonString!.dur)
                        : 0),
                thumbnailUrl: feed[pos].thumbUrl,
                videoUrl: feed[pos].videoUrl,
                videoSource: feed[pos].videoSource,
                alreadyVoted: feed[pos].alreadyVoted!,
                alreadyVotedDirection: feed[pos].alreadyVotedDirection!,
                upvotesCount: feed[pos].upvotes!.length,
                downvotesCount: feed[pos].downvotes!.length,
                indexOfList: pos,
                mainTag: feed[pos].jsonString!.tag,
                oc: feed[pos].jsonString!.oc == 1 ? true : false,
                enableNavigation: enableNavigation,
                itemSelectedCallback: itemSelectedCallback,
                feedType: feedType,
                defaultCommentVotingWeight: _defaultCommentVotingWeight,
                defaultPostVotingWeight: _defaultPostVotingWeight,
                defaultPostVotingTip: _defaultPostVotingTip,
                fixedDownvoteActivated: _fixedDownvoteActivated,
                fixedDownvoteWeight: _fixedDownvoteWeight,
                parentContext: context,
                autoPauseOnPopup: _autoPauseOnPopup,
              ),
              //Text(pos.toString())
            );
          }
        } else {
          return SizedBox(
            height: 0,
          );
        }
      },
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

  final String? fixedDownvoteActivated;
  final String? fixedDownvoteWeight;
  final BuildContext parentContext;
  final bool? autoPauseOnPopup;

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
      this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.parentContext,
      required this.autoPauseOnPopup})
      : super(key: key);

  @override
  State<PostListCard> createState() => _PostListCardState();
}

class _PostListCardState extends State<PostListCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    if (widget.largeFormat) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(repository: UserRepositoryImpl()),
          child: PostListCardLarge(
            showDTCValue: true,
            width: 80.w,
            blur: widget.blur,
            thumbnailUrl: widget.thumbnailUrl,
            title: widget.title,
            description: widget.description,
            author: widget.author,
            link: widget.link,
            publishDate: widget.publishDate,
            duration: widget.duration,
            dtcValue: widget.dtcValue,
            videoUrl: widget.videoUrl,
            videoSource: widget.videoSource,
            alreadyVoted: widget.alreadyVoted,
            alreadyVotedDirection: widget.alreadyVotedDirection,
            upvotesCount: widget.upvotesCount,
            downvotesCount: widget.downvotesCount,
            indexOfList: widget.indexOfList,
            mainTag: widget.mainTag,
            oc: widget.oc,
            defaultCommentVotingWeight: widget.defaultCommentVotingWeight!,
            defaultPostVotingWeight: widget.defaultPostVotingWeight!,
            defaultPostVotingTip: widget.defaultPostVotingTip!,
            fixedDownvoteActivated: widget.fixedDownvoteActivated!,
            fixedDownvoteWeight: widget.fixedDownvoteWeight!,
            autoPauseVideoOnPopup: widget.autoPauseOnPopup!,
          ),
        ),
      );
    } else {
          // Padding(
          //   padding: EdgeInsets.only(left: 5.w),
          //   child:
      return PostListCardNarrow(
        showDTCValue: true,
        // width: widget.width * 0.85,
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
}
