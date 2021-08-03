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
import 'package:dtube_togo/utils/navigationShortcuts.dart';
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
      required this.downvotesCount,
      required this.indexOfList,
      required this.mainTag,
      required this.oc})
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
  final int indexOfList;
  final String mainTag;
  final bool oc;

  @override
  _PostListCardMainFeedState createState() => _PostListCardMainFeedState();
}

class _PostListCardMainFeedState extends State<PostListCardMainFeed> {
  double _avatarSize = 50;
  double _tagSpace = 150;
  bool _thumbnailTapped = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
                width: _avatarSize,
                height: _avatarSize,
                child: AccountAvatarBase(
                    username: widget.author, size: _avatarSize),
              ),
            ),
            SizedBox(width: 8),
            Container(
              width: deviceWidth - _avatarSize - _tagSpace - 8 - 16,
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
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      widget.author,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: _tagSpace,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.oc
                      ? Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.centerRight,
                          child: FaIcon(FontAwesomeIcons.award),
                        )
                      : SizedBox(width: 0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        navigateToPostDetailPage(
                            context, widget.author, widget.link, "none");
                      },
                      child: Transform.scale(
                        scale: 0.8,
                        alignment: Alignment.centerRight,
                        child: InputChip(
                          label: Text(widget.mainTag),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
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
                                      controls: true,
                                      usedAsPreview: false,
                                      allowFullscreen: false)
                                  : (widget.videoSource == 'youtube' &&
                                          widget.videoUrl != "")
                                      ? YTPlayerIFrame(
                                          videoUrl: widget.videoUrl,
                                          autoplay: true,
                                          allowFullscreen: false)
                                      : Text("no player detected"),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.8,
                  alignment: Alignment.centerLeft,
                  child: InputChip(
                    label: Text(
                      '',
                    ),
                    avatar: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FaIcon(FontAwesomeIcons.comment,
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
                Transform.scale(
                  scale: 0.8,
                  alignment: Alignment.centerRight,
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
              ],
            ),
          ],
        ),
      ],
    );
  }
}
