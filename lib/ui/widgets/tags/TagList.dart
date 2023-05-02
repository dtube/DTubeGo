import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';
import 'package:dtube_go/bloc/search/search_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class TagList extends StatefulWidget {
  final String tagName;
  @override
  TagListState createState() => TagListState();

  TagList({Key? key, required this.tagName}) : super(key: key);
}

class TagListState extends State<TagList> {
  late SearchBloc searchBloc;
  late List<FeedItem> hashtagResults;
  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;
  String? _defaultCommentVotingWeight;
  String? _defaultPostVotingWeight;
  String? _defaultPostVotingTip;

  String? _fixedDownvoteActivated;
  String? _fixedDownvoteWeight;
  bool? _autoPauseVideoOnPopup;
  bool? _disableAnimations;

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
    _disableAnimations = await sec.getDisableAnimations() == "true";

    if (_nsfwMode == null) {
      _nsfwMode = 'Blur';
    }
    if (_hiddenMode == null) {
      _hiddenMode = 'Hide';
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchTagSearchResults(tags: widget.tagName));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading();
          } else {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: globalBGColor,
                elevation: 0,
                title: Text(
                  "#" + widget.tagName,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "videos with the tag #${widget.tagName} of the last 90 days: ",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: BlocBuilder<FeedBloc, FeedState>(
                            builder: (context, state) {
                          if (state is FeedInitialState ||
                              state is FeedLoadingState) {
                            return buildLoading();
                          } else if (state is FeedLoadedState) {
                            hashtagResults = state.feed;
                            BlocProvider.of<FeedBloc>(context).isFetching =
                                false;
                            return buildResultsListForTagResults(
                                hashtagResults);
                          } else if (state is FeedErrorState) {
                            return buildErrorUi(state.message);
                          } else {
                            return buildErrorUi('');
                          }
                        }),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget buildLoading() {
    return Container(
      height: 80.h,
      child: DtubeLogoPulseWithSubtitle(
        subtitle: "loading posts..",
        size: 20.w,
      ),
    );
  }

  Widget buildBlank() {
    return Container(
      height: 80.h,
      child: SizedBox(height: 0),
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

  Widget buildResultsListForTagResults(List<FeedItem> searchResults) {
    return Container(
      height: 100.h,
      alignment: Alignment.topLeft,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: searchResults.length,
          itemBuilder: (ctx, pos) {
            return PostListCardLarge(
              showDTCValue: true,
              width: 90.w,
              alreadyVoted: searchResults[pos].alreadyVoted!,
              alreadyVotedDirection: searchResults[pos].alreadyVotedDirection!,
              author: searchResults[pos].author,
              blur: false,
              defaultCommentVotingWeight: _defaultCommentVotingWeight!,
              defaultPostVotingTip: _defaultPostVotingTip!,
              defaultPostVotingWeight: _defaultPostVotingWeight!,
              description: searchResults[pos].jsonString!.desc!,
              downvotesCount: searchResults[pos].downvotes!.length,
              dtcValue:
                  (searchResults[pos].dist / 100).round().toString() + " DTC",
              duration: new Duration(
                  seconds:
                      int.tryParse(searchResults[pos].jsonString!.dur) != null
                          ? int.parse(searchResults[pos].jsonString!.dur)
                          : 0),
              indexOfList: pos,
              link: searchResults[pos].link,
              mainTag: searchResults[pos].jsonString!.tag,
              oc: searchResults[pos].jsonString!.oc == 1 ? true : false,
              publishDate: TimeAgo.timeInAgoTSShort(searchResults[pos].ts),
              thumbnailUrl: searchResults[pos].thumbUrl,
              title: searchResults[pos].jsonString!.title,
              upvotesCount: searchResults[pos].upvotes!.length,
              videoSource: searchResults[pos].videoSource,
              videoUrl: searchResults[pos].videoUrl,
              fixedDownvoteActivated: _fixedDownvoteActivated!,
              fixedDownvoteWeight: _fixedDownvoteWeight!,
              autoPauseVideoOnPopup: _autoPauseVideoOnPopup!,
            );
          }),
    );
  }
}
