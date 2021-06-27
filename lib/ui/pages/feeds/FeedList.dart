// TODO: known issue - no lazy loading for now.
// implement this to lazy load more entries:
// https://pub.dev/packages/loadmore
// https://github.com/dtube/javalon/blob/45d47cb38eefde0b84f29ba06be5571faecfa0ab/index.js#L105

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/ui/pages/upload/uploaderTabContainer.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/pages/post/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';

import 'package:intl/intl.dart';

import 'package:dtube_togo/res/strings/strings.dart';

import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatefulWidget {
  String feedType;
  String? username;
  bool bigThumbnail;
  bool showAuthor;

  @override
  _FeedPageState createState() => _FeedPageState();

  FeedPage({
    required this.feedType,
    this.username,
    required this.bigThumbnail,
    required this.showAuthor,
    Key? key,
  }) : super(key: key);
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: globalAlmostBlack,
      body: FeedList(
        feedType: widget.feedType,
        username: widget.username,
        bigThumbnail: widget.bigThumbnail,
        showAuthor: widget.showAuthor,
      ),
    );
  }
}

class FeedList extends StatefulWidget {
  String feedType;
  String? username;
  bool bigThumbnail;
  bool showAuthor;

  @override
  _FeedListState createState() => _FeedListState();

  FeedList({
    required this.feedType,
    this.username,
    required this.bigThumbnail,
    required this.showAuthor,
    Key? key,
  }) : super(key: key);
}

class _FeedListState extends State<FeedList> {
  String? nsfwMode;
  String? hiddenMode;

  late FeedBloc postBloc;

  void getDisplayModes() async {
    hiddenMode = await sec.getShowHidden();
    nsfwMode = await sec.getNSFW();
    if (nsfwMode == null) {
      nsfwMode = 'blur';
    }
    if (hiddenMode == null) {
      hiddenMode = 'hide';
    }
  }

  @override
  void initState() {
    super.initState();
    postBloc = BlocProvider.of<FeedBloc>(context);
    getDisplayModes();
    if (widget.feedType != "UserFeed") {
      postBloc.add(FetchFeedEvent(feedType: widget.feedType));
    } else {
      postBloc.add(FetchUserFeedEvent(widget.username!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      // color: globalAlmostBlack,
      child: BlocListener<FeedBloc, FeedState>(
        listener: (context, state) {
          if (state is FeedErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedInitialState) {
              return buildLoading();
            } else if (state is FeedLoadingState) {
              return buildLoading();
            } else if (state is FeedLoadedState) {
              return buildPostList(state.feed, widget.bigThumbnail, true);
            } else if (state is FeedErrorState) {
              return buildErrorUi(state.message);
            } else {
              return buildErrorUi('test');
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
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

  Widget buildPostList(
      List<FeedItem> feed, bool bigThumbnail, bool showAuthor) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: feed.length,
      itemBuilder: (ctx, pos) {
        // work on more sources
        if (feed[pos].json_string!.files?.youtube != null ||
            feed[pos].json_string!.files?.ipfs != null) {
          if ((nsfwMode == 'hide' && feed[pos].json_string?.nsfw == 1) ||
              (hiddenMode == 'hide' && feed[pos].json_string?.hide == 1)) {
            return SizedBox(
              height: 0,
            );
          } else {
            return BlocProvider<UserBloc>(
              create: (context) => UserBloc(repository: UserRepositoryImpl()),
              child: Padding(
                padding:
                    EdgeInsets.only(top: pos == 0 && bigThumbnail ? 90.0 : 0.0),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: PostListCard(
                      bigThumbnail: bigThumbnail,
                      showAuthor: showAuthor,
                      blur: (nsfwMode == 'blur' && feed[pos].json_string?.nsfw == 1) ||
                              (hiddenMode == 'blur' &&
                                  feed[pos].json_string?.hide == 1)
                          ? true
                          : false,
                      title: feed[pos].json_string!.title,
                      description: feed[pos].json_string!.desc!,
                      author: feed[pos].author,
                      link: feed[pos].link,
                      // publishDate: .toString(),
                      publishDate: DateFormat('yyyy-MM-dd kk:mm').format(
                          DateTime.fromMicrosecondsSinceEpoch(feed[pos].ts * 1000)
                              .toLocal()),
                      dtcValue:
                          (feed[pos].dist / 100).round().toString() + " DTC",
                      duration: new Duration(
                          seconds: int.tryParse(feed[pos].json_string!.dur) != null
                              ? int.parse(feed[pos].json_string!.dur)
                              : 0),
                      thumbnailUrl: feed[pos].json_string!.files!.youtube != null
                          ? "https://img.youtube.com/vi/" +
                              feed[pos].json_string!.files!.youtube! +
                              "/mqdefault.jpg"
                          : AppStrings.ipfsSnapUrl +
                              feed[pos].json_string!.files!.ipfs!.img!.s360!),
                ),
              ),
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

class PostDescription extends StatelessWidget {
  const PostDescription({
    Key? key,
    required this.title,
    required this.description,
    required this.author,
    required this.publishDate,
    required this.dtcValue,
    required this.duration,
  }) : super(key: key);

  final String title;
  final String description;
  final String author;
  final String publishDate;
  final String dtcValue;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                author,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$publishDate - $duration',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '$dtcValue',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PostListCard extends StatelessWidget {
  final bool showAuthor;
  final bool bigThumbnail;
  final bool blur;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;
  final Duration duration;
  final String dtcValue;
  const PostListCard({
    Key? key,
    required this.showAuthor,
    required this.bigThumbnail,
    required this.blur,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.link,
    required this.publishDate,
    required this.duration,
    required this.dtcValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bigThumbnail) {
      return Container(
        height: (MediaQuery.of(context).size.width / 16 * 9) + 100,
        child: PostListCardBigThumbnail(
            blur: blur,
            thumbnailUrl: thumbnailUrl,
            title: title,
            description: description,
            author: author,
            link: link,
            publishDate: publishDate,
            duration: duration,
            dtcValue: dtcValue),
      );
    } else {
      return PostListCardSmallThumbnail(
          blur: blur,
          thumbnailUrl: thumbnailUrl,
          title: title,
          description: description,
          author: author,
          link: link,
          publishDate: publishDate,
          duration: duration,
          dtcValue: dtcValue);
    }
  }
}

class PostListCardBigThumbnail extends StatefulWidget {
  const PostListCardBigThumbnail({
    Key? key,
    required this.blur,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.link,
    required this.publishDate,
    required this.duration,
    required this.dtcValue,
  }) : super(key: key);

  final bool blur;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;
  final Duration duration;
  final String dtcValue;

  @override
  _PostListCardBigThumbnailState createState() =>
      _PostListCardBigThumbnailState();
}

class _PostListCardBigThumbnailState extends State<PostListCardBigThumbnail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserErrorState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  navigateToUserDetailPage(context, widget.author);
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: AccoutnAvatarBase(
                    username: widget.author,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: MediaQuery.of(context).size.width - 50 - 50,
                child: InkWell(
                  onTap: () {
                    navigateToPostDetailPage(
                        context, widget.author, widget.link);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        widget.author,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              navigateToPostDetailPage(context, widget.author, widget.link);
            },
            child: AspectRatio(
              aspectRatio: 8 / 5,
              child: widget.blur
                  ? ClipRect(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaY: 5,
                          sigmaX: 5,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.thumbnailUrl,
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.thumbnailUrl,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.publishDate} - ' +
                    (widget.duration.inHours == 0
                        ? widget.duration.toString().substring(2, 7) + ' min'
                        : widget.duration.toString().substring(0, 7) +
                            ' hours'),
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                '${widget.dtcValue}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void navigateToPostDetailPage(
      BuildContext context, String author, String link) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: author,
        link: link,
      );
    }));
  }

  void navigateToUserDetailPage(BuildContext context, String username) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      // return BlocProvider<UserBloc>(
      //   create: (context) {
      //     return UserBloc(repository: UserRepositoryImpl())

      //   },
      //   child:
      return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl())
                  ..add(FetchAccountDataEvent(username)),
          ),
          BlocProvider<TransactionBloc>(
            create: (BuildContext context) =>
                TransactionBloc(repository: TransactionRepositoryImpl()),
          ),
        ],
        child: UserPage(
          username: username,
          ownUserpage: false,
        ),
      );
    }));
  }
}

class PostListCardSmallThumbnail extends StatefulWidget {
  const PostListCardSmallThumbnail({
    Key? key,
    required this.blur,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.link,
    required this.publishDate,
    required this.duration,
    required this.dtcValue,
  }) : super(key: key);

  final bool blur;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String author;
  final String link;
  final String publishDate;
  final Duration duration;
  final String dtcValue;

  @override
  _PostListCardSmallThumbnailState createState() =>
      _PostListCardSmallThumbnailState();
}

class _PostListCardSmallThumbnailState
    extends State<PostListCardSmallThumbnail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToPostDetailPage(context, widget.author, widget.link);
      },
      child: Card(
        color: globalBGColor,
        elevation: 0,
        child: Container(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 75,
              child: AspectRatio(
                aspectRatio: 8 / 5,
                child: widget.blur
                    ? ClipRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaY: 5,
                            sigmaX: 5,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.thumbnailUrl,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.thumbnailUrl,
                        fit: BoxFit.fitWidth,
                      ),
              ),
              // ),
            ),
            SizedBox(width: 8),
            Container(
              width: (MediaQuery.of(context).size.width - 50) / 3 * 2,
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.publishDate} - ' +
                              (widget.duration.inHours == 0
                                  ? widget.duration.toString().substring(2, 7)
                                  : widget.duration.toString().substring(0, 7)),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          '${widget.dtcValue}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void navigateToPostDetailPage(
      BuildContext context, String author, String link) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: author,
        link: link,
      );
    }));
  }
}
