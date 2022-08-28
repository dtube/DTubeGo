import 'package:dtube_go/ui/pages/feeds/cards/PostListCardDesktop.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardSuggestions.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardNarrow.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef ListOfString2VoidFunc = void Function(List<String>);

class FeedListSuggestedPosts extends StatelessWidget {
  final String feedType;

  final double width;

  final Bool2VoidFunc scrollCallback;
  late YoutubePlayerController _youtubePlayerController;

  FeedListSuggestedPosts({
    required this.feedType,
    required this.scrollCallback,
    required this.width,
    required this.clickedCallback,
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

  bool? _autoPauseVideoOnPopup;
  VoidCallback clickedCallback;

  Future<bool> getSettings() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    _defaultCommentVotingWeight = await sec.getDefaultVoteComments();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();

    _fixedDownvoteActivated = await sec.getFixedDownvoteActivated();
    _fixedDownvoteWeight = await sec.getFixedDownvoteWeight();
    _autoPauseVideoOnPopup = await sec.getVideoAutoPause() == "true";

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
    return Container(
      height: 100.h,
      width: width,
      child: FutureBuilder<bool>(
          future: getSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return buildLoading(context);
            } else {
              return BlocBuilder<FeedBloc, FeedState>(
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
                  return buildPostListNarrow(_feedItems, context);
                },
              );
            }
          }),
    );
  }

  Widget buildLoading(BuildContext context) {
    return feedType == "UserFeed"
        ? SizedBox(height: 0, width: 0)
        : Center(
            child: DtubeLogoPulseWithSubtitle(
              subtitle: "loading suggestions..",
              size: 10.w,
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

  Widget buildPostListNarrow(List<FeedItem> feed, BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        key: new PageStorageKey('suggestedposts_listview'),
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: feed.length,
        controller: _scrollController,
        itemBuilder: (ctx, pos) {
          // work on more sources
          if (feed[pos].jsonString!.files?.youtube != null ||
              feed[pos].jsonString!.files?.ipfs != null ||
              feed[pos].jsonString!.files?.sia != null) {
            if ((_nsfwMode == 'Hide' && feed[pos].jsonString?.nsfw == 1) ||
                (_hiddenMode == 'Hide' && feed[pos].summaryOfVotes < 0) ||
                (feed[pos].jsonString!.hide == 1 &&
                    feed[pos].author != _applicationUser)) {
              return SizedBox(
                height: 0,
              );
            } else {
              return BlocProvider<UserBloc>(
                create: (context) => UserBloc(repository: UserRepositoryImpl()),
                child: PostListCard(
                  width: width,
                  blur: (_nsfwMode == 'Blur' &&
                              feed[pos].jsonString?.nsfw == 1) ||
                          (_hiddenMode == 'Blur' &&
                              feed[pos].summaryOfVotes < 0)
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
                  feedType: feedType,
                  defaultCommentVotingWeight: _defaultCommentVotingWeight,
                  defaultPostVotingWeight: _defaultPostVotingWeight,
                  defaultPostVotingTip: _defaultPostVotingTip,
                  fixedDownvoteActivated: _fixedDownvoteActivated,
                  fixedDownvoteWeight: _fixedDownvoteWeight,
                  parentContext: context,
                  autoPauseVideoOnPopup: _autoPauseVideoOnPopup,
                  clickedCallback: clickedCallback,
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
      ),
    );
  }
}

class PostListCard extends StatefulWidget {
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

  final String feedType;
  final String? defaultCommentVotingWeight;
  final String? defaultPostVotingWeight;
  final String? defaultPostVotingTip;

  final String? fixedDownvoteActivated;
  final String? fixedDownvoteWeight;
  final bool? autoPauseVideoOnPopup;

  final BuildContext parentContext;
  final VoidCallback clickedCallback;

  PostListCard(
      {Key? key,
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
      required this.feedType,
      this.defaultCommentVotingWeight,
      this.defaultPostVotingWeight,
      this.defaultPostVotingTip,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight,
      required this.parentContext,
      required this.autoPauseVideoOnPopup,
      required this.clickedCallback})
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
    return PostListCardSuggestions(
      width: widget.width,
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
      clickedCallback: widget.clickedCallback,

      //),
    );
  }
}
