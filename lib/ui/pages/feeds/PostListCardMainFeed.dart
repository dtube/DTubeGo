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
      required this.videoSource})
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
                  navigateToPostDetailPage(context, widget.author, widget.link);
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
          children: [
            Text(
              '${widget.publishDate} - ' +
                  (widget.duration.inHours == 0
                      ? widget.duration.toString().substring(2, 7) + ' min'
                      : widget.duration.toString().substring(0, 7) + ' hours'),
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              '${widget.dtcValue}',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ],
    );
  }

  void navigateToPostDetailPage(
      BuildContext context, String author, String link) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: author,
        link: link,
        recentlyUploaded: false,
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
