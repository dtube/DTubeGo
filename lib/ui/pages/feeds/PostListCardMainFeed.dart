import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/ui/pages/post/players/BetterPlayer.dart';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/post/players/YTplayerIframe.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostListCardMainFeed extends StatefulWidget {
  const PostListCardMainFeed(
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
      required this.downvotesCount})
      : super(key: key);

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

  @override
  _PostListCardMainFeedState createState() => _PostListCardMainFeedState();
}

class _PostListCardMainFeedState extends State<PostListCardMainFeed> {
  bool _thumbnailTapped = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: AccountAvatarBase(
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
                      context, widget.author, widget.link, "none");
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
        AspectRatio(
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
              : InkWell(
                  onTap: () {
                    setState(() {
                      _thumbnailTapped = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Visibility(
                        visible: !_thumbnailTapped,
                        child: AspectRatio(
                          aspectRatio: 8 / 5,
                          child: widget.thumbnailUrl != ''
                              ? CachedNetworkImage(
                                  imageUrl: widget.thumbnailUrl,
                                  fit: BoxFit.fitWidth,
                                )
                              : Image.asset(
                                  'assets/images/Image_of_none.svg.png',
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                      Center(
                        child: Visibility(
                          visible: _thumbnailTapped,
                          child:
                              (["sia", "ipfs"].contains(widget.videoSource) &&
                                      widget.videoUrl != "")
                                  ? BP(
                                      videoUrl: widget.videoUrl,
                                      autoplay: true,
                                      looping: false,
                                      localFile: false,
                                      controls: false,
                                    )
                                  : (widget.videoSource == 'youtube' &&
                                          widget.videoUrl != "")
                                      ? YTPlayerIFrame(
                                          videoUrl: widget.videoUrl,
                                          autoplay: true,
                                        )
                                      : Text("no player detected"),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: InputChip(
                    label: Text(
                      '',
                    ),
                    avatar: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: FaIcon(FontAwesomeIcons.reply,
                          color: widget.alreadyVoted &&
                                  !widget.alreadyVotedDirection
                              ? globalRed
                              : Colors.grey),
                    ),
                    onPressed: () {
                      navigateToPostDetailPage(
                          context, widget.author, widget.link, "newcomment");
                    },
                  ),
                ),
                Text(
                  '${widget.publishDate} - ' +
                      (widget.duration.inHours == 0
                          ? widget.duration.toString().substring(2, 7) + ' min'
                          : widget.duration.toString().substring(0, 7) +
                              ' hours'),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Row(
                    children: [
                      InputChip(
                        label: Text(
                          widget.upvotesCount.toString(),
                        ),
                        avatar: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: FaIcon(
                            FontAwesomeIcons.thumbsUp,
                            color: widget.alreadyVoted &&
                                    widget.alreadyVotedDirection
                                ? globalRed
                                : Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          if (!widget.alreadyVoted) {
                            navigateToPostDetailPage(
                                context, widget.author, widget.link, "vote");
                          }
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InputChip(
                        label: Text(
                          widget.downvotesCount.toString(),
                        ),
                        avatar: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: FaIcon(FontAwesomeIcons.thumbsDown,
                              color: widget.alreadyVoted &&
                                      !widget.alreadyVotedDirection
                                  ? globalRed
                                  : Colors.grey),
                        ),
                        onPressed: () {
                          if (!widget.alreadyVoted) {
                            navigateToPostDetailPage(
                                context, widget.author, widget.link, "vote");
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    '${widget.dtcValue}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void navigateToPostDetailPage(
      BuildContext context, String author, String link, String directFocus) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: author,
        link: link,
        recentlyUploaded: false,
        directFocus: directFocus,
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
