import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/feeds/PostDetailPageInlineView.dart';
import 'package:dtube_togo/ui/pages/feeds/widgets/FullScreenButton.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/widgets/players/BetterPlayer.dart';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/widgets/players/YTplayerIframe.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/ui/pages/user/User.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostListCardLarge extends StatefulWidget {
  const PostListCardLarge(
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
  _PostListCardLargeState createState() => _PostListCardLargeState();
}

class _PostListCardLargeState extends State<PostListCardLarge> {
  double _avatarSize = 10.w;
  double _tagSpace = 20.w;
  bool _thumbnailTapped = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                navigateToUserDetailPage(context, widget.author);
              },
              child: AccountAvatarBase(
                username: widget.author,
                avatarSize: _avatarSize,
                showVerified: true,
                showName: true,
                nameFontSizeMultiply: 1,
                width: 40.w,
              ),
            ),
            SizedBox(width: 8),
            Container(
              width: _tagSpace,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.oc
                      ? FaIcon(
                          FontAwesomeIcons.award,
                          size: 5.w,
                        )
                      : SizedBox(width: 0),
                  InkWell(
                    onTap: () {
                      navigateToPostDetailPage(
                          context, widget.author, widget.link, "none", false);
                    },
                    child: InputChip(
                      label: Container(
                        width: 10.w,
                        //height: 40,
                        child: Center(
                          child: Text(
                            widget.mainTag,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: 90.w,
          child: InkWell(
            onTap: () {
              navigateToPostDetailPage(
                  context, widget.author, widget.link, "none", false);
            },
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        InkWell(
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
                    child: widget.blur
                        ? ClipRect(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaY: 5,
                                sigmaX: 5,
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl: widget.thumbnailUrl,
                                errorWidget: (context, url, error) => DTubeLogo(
                                  size: 50,
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: widget.thumbnailUrl,
                            fit: BoxFit.fitWidth,
                            errorWidget: (context, url, error) => DTubeLogo(
                              size: 50,
                            ),
                          )),
              ),
              Center(
                child: Visibility(
                  visible: _thumbnailTapped,
                  child: (["sia", "ipfs"].contains(widget.videoSource) &&
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
              Align(
                alignment: Alignment.topRight,
                child: FullScreenButton(
                  videoUrl: widget.videoUrl,
                  videoSource: widget.videoSource,
                  iconSize: 22,
                ),
              ),
            ],
          ),
          //),
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
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  '${widget.dtcValue}',
                  style: Theme.of(context).textTheme.bodyText1,
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
                      navigateToPostDetailPage(context, widget.author,
                          widget.link, "newcomment", false);
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
                          style: Theme.of(context).textTheme.bodyText1,
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
                            navigateToPostDetailPage(context, widget.author,
                                widget.link, "upvote", false);
                          }
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InputChip(
                        label: Text(
                          widget.downvotesCount.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
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
                            navigateToPostDetailPage(context, widget.author,
                                widget.link, "downvote", false);
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
