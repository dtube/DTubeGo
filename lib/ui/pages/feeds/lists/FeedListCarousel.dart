import 'package:carousel_slider/carousel_slider.dart';
import 'package:dtube_go/utils/randomGenerator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardNarrow.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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

  String header;

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
    required this.header,
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
            return buildLoading(context, feedType);
          } else {
            return BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedInitialState ||
                    state is FeedLoadingState && _feedItems.isEmpty) {
                  return buildLoading(context, feedType);
                } else if (state is FeedLoadedState) {
                  if (state.feedType == feedType) {
                    if (_feedItems.isNotEmpty) {
                      if (_feedItems.first.link == state.feed.first.link) {
                        _feedItems.clear();
                      } else {
                        _feedItems.removeLast();
                      }
                    }
                    for (var f in state.feed) {
                      if (f.jsonString!.files?.youtube != null ||
                          f.jsonString!.files?.ipfs != null ||
                          f.jsonString!.files?.sia != null) {
                        if ((_nsfwMode == 'Hide' && f.jsonString?.nsfw == 1) ||
                            (_hiddenMode == 'Hide' && f.summaryOfVotes < 0) ||
                            (f.jsonString!.hide == 1 &&
                                f.author != _applicationUser)) {
                          print("skip item" + f.link);
                        } else {
                          _feedItems.add(f);
                        }
                      }
                    }
                  }
                  BlocProvider.of<FeedBloc>(context).isFetching = false;
                } else if (state is FeedErrorState) {
                  return buildErrorUi(state.message);
                }
                return buildPostList(
                    _feedItems, largeFormat, true, context, feedType, header);
              },
            );
          }
        });
  }

  Widget buildLoading(BuildContext context, feedType) {
    return feedType == 'UserFeed'
        ? Center(
            child: DtubeLogoPulseWithSubtitle(
              subtitle: "Loading uploads...",
              size: 40.w,
            ),
          )
        : SizedBox(height: 0);
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
      BuildContext context, String gpostType, String header) {
    if (feed.length > 0) {
      return Container(
        height: 52.h,
        width: width,
        child: Column(
          children: [
            Text(header, style: Theme.of(context).textTheme.headline5),
            Container(
              height: 45.h,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                    //aspectRatio: 2.0,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    disableCenter: true,
                    autoPlayInterval: Duration(seconds: generateRandom(4, 7))),
                itemCount: feed.length,
                itemBuilder: (ctx, index, realIdx) {
                  if (feed[index].jsonString!.files?.youtube != null ||
                      feed[index].jsonString!.files?.ipfs != null ||
                      feed[index].jsonString!.files?.sia != null) {
                    if ((_nsfwMode == 'Hide' &&
                            feed[index].jsonString?.nsfw == 1) ||
                        (_hiddenMode == 'Hide' &&
                            feed[index].summaryOfVotes < 0) ||
                        (feed[index].jsonString!.hide == 1 &&
                            feed[index].author != _applicationUser)) {
                      return SizedBox(
                        height: 0,
                      );
                    } else {
                      return BlocProvider<UserBloc>(
                        create: (context) =>
                            UserBloc(repository: UserRepositoryImpl()),
                        child: PostListCardNarrow(
                          width: width!,
                          height: heightPerEntry!,
                          blur: (_nsfwMode == 'Blur' &&
                                      feed[index].jsonString?.nsfw == 1) ||
                                  (_hiddenMode == 'Blur' &&
                                      feed[index].summaryOfVotes < 0)
                              ? true
                              : false,
                          thumbnailUrl: feed[index].thumbUrl,
                          title: feed[index].jsonString!.title,
                          description: feed[index].jsonString!.desc != null
                              ? feed[index].jsonString!.desc!
                              : "",
                          author: feed[index].author,
                          link: feed[index].link,
                          publishDate: TimeAgo.timeInAgoTSShort(feed[index].ts),
                          duration: new Duration(
                              seconds:
                                  int.tryParse(feed[index].jsonString!.dur) !=
                                          null
                                      ? int.parse(feed[index].jsonString!.dur)
                                      : 0),
                          dtcValue: (feed[index].dist / 100).round().toString(),
                          indexOfList: index,
                          enableNavigation: enableNavigation,
                          itemSelectedCallback: itemSelectedCallback,
                          userPage: true,
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      height: 0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
