import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';

import 'package:dtube_togo/ui/pages/feeds/widgets/FullScreenButton.dart';
import 'package:dtube_togo/ui/pages/post/widgets/VoteButtons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_togo/style/ThemeData.dart';

import 'package:dtube_togo/ui/widgets/players/BetterPlayer.dart';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_togo/ui/widgets/players/YTplayerIframe.dart';

import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter/material.dart';

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
      required this.oc,
      required this.defaultCommentVotingWeight,
      required this.defaultPostVotingWeight,
      required this.defaultPostVotingTip})
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
  final String defaultCommentVotingWeight;
  final String defaultPostVotingWeight;
  final String defaultPostVotingTip;

  @override
  _PostListCardLargeState createState() => _PostListCardLargeState();
}

class _PostListCardLargeState extends State<PostListCardLarge> {
  double _avatarSize = 10.w;
  double _tagSpace = 20.w;
  bool _thumbnailTapped = false;
  TextEditingController _replyController = new TextEditingController();

  late bool _showVotingBars;

  late bool _votingDirection;

  late bool _showCommentInput; // true = upvote | false = downvote

  late UserBloc _userBloc;
  int _currentVp = 0;

  @override
  void initState() {
    super.initState();
    _showVotingBars = false;
    _votingDirection = true;
    _showCommentInput = false;
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
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
                navigateToUserDetailPage(context, widget.author, () {});
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
                      navigateToPostDetailPage(context, widget.author,
                          widget.link, "none", false, () {});
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
                  context, widget.author, widget.link, "none", false, () {});
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
                          allowFullscreen: false,
                          portraitVideoPadding: 50.0,
                        )
                      : (widget.videoSource == 'youtube' &&
                              widget.videoUrl != "")
                          ? YTPlayerIFrame(
                              videoUrl: widget.videoUrl,
                              autoplay: true,
                              allowFullscreen: false)
                          : Text("no player detected"),
                ),
              ),
              Visibility(
                  visible: _showVotingBars,
                  child: AspectRatio(
                    aspectRatio: 8 / 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: BlocBuilder<UserBloc, UserState>(
                        bloc: _userBloc,
                        builder: (context, state) {
                          // TODO error handling

                          if (state is UserDTCVPLoadingState) {
                            return CircularProgressIndicator();
                          }
                          if (state is UserDTCVPLoadedState) {
                            _currentVp = state.vtBalance["v"]!;
                          }
                          return AspectRatio(
                            aspectRatio: 8 / 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.black.withAlpha(85),
                                child: VotingSliderStandalone(
                                  defaultVote: double.parse(
                                      widget.defaultPostVotingWeight),
                                  defaultTip:
                                      double.parse(widget.defaultPostVotingTip),
                                  author: widget.author,
                                  link: widget.link,
                                  downvote: !_votingDirection,
                                  currentVT: _currentVp + 0.0,
                                  isPost: true,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
              Visibility(
                  visible: _showCommentInput,
                  child: AspectRatio(
                    aspectRatio: 8 / 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.black.withAlpha(75),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 80.w, // TODO: make this dynamic
                              child: Padding(
                                padding: EdgeInsets.all(5.w),
                                child: TextField(
                                  //key: UniqueKey(),
                                  autofocus: _showCommentInput,
                                  controller: _replyController,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                            BlocBuilder<UserBloc, UserState>(
                                bloc: _userBloc,
                                builder: (context, state) {
                                  // TODO error handling

                                  if (state is UserDTCVPLoadingState) {
                                    return CircularProgressIndicator();
                                  }
                                  if (state is UserDTCVPLoadedState) {
                                    _currentVp = state.vtBalance["v"]!;
                                  }

                                  return Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: InputChip(
                                      onPressed: () {
                                        UploadData _uploadData = new UploadData(
                                            link: "",
                                            parentAuthor: widget.author,
                                            parentPermlink: widget.link,
                                            title: "",
                                            description:
                                                _replyController.value.text,
                                            tag: "",
                                            vpPercent: double.parse(widget
                                                .defaultCommentVotingWeight),
                                            vpBalance: _currentVp,
                                            burnDtc: 0,
                                            dtcBalance:
                                                0, // TODO promoted comment implementation missing
                                            isPromoted: false,
                                            duration: "",
                                            thumbnailLocation: "",
                                            localThumbnail: false,
                                            videoLocation: "",
                                            localVideoFile: false,
                                            originalContent: false,
                                            nSFWContent: false,
                                            unlistVideo: false,
                                            isEditing: false,
                                            videoSourceHash: "",
                                            video240pHash: "",
                                            video480pHash: "",
                                            videoSpriteHash: "",
                                            thumbnail640Hash: "",
                                            thumbnail210Hash: "",
                                            uploaded: false,
                                            crossPostToHive: false);

                                        BlocProvider.of<TransactionBloc>(
                                                context)
                                            .add(SendCommentEvent(_uploadData));
                                        setState(() {
                                          _showCommentInput = false;
                                          _replyController.text = '';
                                        });
                                      },
                                      label:
                                          FaIcon(FontAwesomeIcons.paperPlane),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  )),
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
                        //   navigateToPostDetailPage(context, widget.author,
                        //       widget.link, "newcomment", false, () {});
                        // },
                        setState(() {
                          if (!_showCommentInput) {
                            _showCommentInput = true;
                            _showVotingBars = false;
                            _userBloc.add(FetchDTCVPEvent());
                          } else {
                            _showCommentInput = false;
                          }
                        });
                      }),
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
                          // if (!widget.alreadyVoted) {
                          //   navigateToPostDetailPage(context, widget.author,
                          //       widget.link, "upvote", false, () {});
                          // }
                          setState(() {
                            if (_showVotingBars && _votingDirection) {
                              _showVotingBars = false;
                            } else if (_showVotingBars && !_votingDirection) {
                              _votingDirection = true;
                            } else if (!_showVotingBars) {
                              _userBloc.add(FetchDTCVPEvent());
                              _showCommentInput = false;
                              _showVotingBars = true;
                              _votingDirection = true;
                            }
                          });
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
                          setState(() {
                            if (_showVotingBars && _votingDirection) {
                              _votingDirection = false;
                            } else if (!_showVotingBars) {
                              _userBloc.add(FetchDTCVPEvent());
                              _showCommentInput = false;
                              _showVotingBars = true;
                              _votingDirection = false;
                            } else if (_showVotingBars && !_votingDirection) {
                              _showVotingBars = false;
                            }
                          });
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
