import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/styledCustomWidgets.dart';

import 'package:dtube_go/ui/pages/feeds/widgets/FullScreenButton.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/TagChip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/ui/widgets/players/BetterPlayer.dart';

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';

import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
                                color: Colors.black.withAlpha(99),
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
                        color: Colors.black.withAlpha(95),
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
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: FullScreenButton(
                    videoUrl: widget.videoUrl,
                    videoSource: widget.videoSource,
                    iconSize: 22,
                  ),
                ),
              ),
            ],
          ),
          //),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                InkWell(
                  onTap: () {
                    navigateToUserDetailPage(context, widget.author, () {});
                  },
                  child: AccountAvatarBase(
                    username: widget.author,
                    avatarSize: _avatarSize,
                    showVerified: true,
                    showName: false,
                    nameFontSizeMultiply: 1,
                    width: 10.w,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  width: 65.w,
                  child: InkWell(
                    onTap: () {
                      navigateToPostDetailPage(context, widget.author,
                          widget.link, "none", false, () {});
                    },
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: 32.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.oc
                      ? Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: FaIcon(
                            FontAwesomeIcons.award,
                            size: 5.w,
                          ),
                        )
                      : SizedBox(width: 7.w),
                  // InkWell(
                  //   onTap: () {
                  //     navigateToPostDetailPage(context, widget.author,
                  //         widget.link, "none", false, () {});
                  //   },
                  //   child: InputChip(
                  //     padding: EdgeInsets.zero,
                  //     label: Container(
                  //       width: 10.w,
                  //       child: Center(
                  //         child: Text(
                  //           widget.mainTag,
                  //           overflow: TextOverflow.ellipsis,
                  //           style: Theme.of(context).textTheme.bodyText2,
                  //         ),
                  //       ),
                  //     ),
                  //     onPressed: () {},
                  //   ),
                  // ),
                  TagChip(
                    tagName: widget.mainTag,
                    width: 11.w,
                  ),
                  SpeedDial(
                      // icon: FontAwesomeIcons.bars,
                      child: ShadowedIcon(
                          icon: FontAwesomeIcons.ellipsisV,
                          color: Colors.white,
                          shadowColor: Colors.black,
                          size: 5.w),
                      activeIcon: FontAwesomeIcons.chevronLeft,
                      buttonSize: 5.w * 2,
                      direction: SpeedDialDirection.Up,
                      visible: true,
                      closeManually: false,
                      curve: Curves.bounceIn,
                      overlayColor: Colors.white,
                      overlayOpacity: 0,
                      onOpen: () => print('OPENING DIAL'),
                      onClose: () => print('DIAL CLOSED'),
                      tooltip: 'menu',
                      heroTag: 'submenu' + widget.title,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0.0,
                      shape: CircleBorder(),
                      gradientBoxShape: BoxShape.circle,
                      children: [
                        SpeedDialChild(
                            child: ShadowedIcon(
                                icon: FontAwesomeIcons.comment,
                                color: Colors.white,
                                shadowColor: Colors.black,
                                size: 5.w),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            // label: '',
                            // labelStyle: TextStyle(fontSize: 14.0),
                            // labelBackgroundColor: Colors.transparent,
                            onTap: () {
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
                        SpeedDialChild(
                            child: ShadowedIcon(
                                icon: FontAwesomeIcons.thumbsDown,
                                color: Colors.white,
                                shadowColor: Colors.black,
                                size: 5.w),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            // label: '',
                            // labelStyle: TextStyle(fontSize: 14.0),
                            // labelBackgroundColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                if (_showVotingBars && _votingDirection) {
                                  _votingDirection = false;
                                } else if (!_showVotingBars) {
                                  _userBloc.add(FetchDTCVPEvent());
                                  _showCommentInput = false;
                                  _showVotingBars = true;
                                  _votingDirection = false;
                                } else if (_showVotingBars &&
                                    !_votingDirection) {
                                  _showVotingBars = false;
                                }
                              });
                            }),
                        SpeedDialChild(
                            child: ShadowedIcon(
                                icon: FontAwesomeIcons.thumbsUp,
                                color: Colors.white,
                                shadowColor: Colors.black,
                                size: 5.w),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            // label: '',
                            // labelStyle: TextStyle(fontSize: 14.0),
                            // labelBackgroundColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                if (_showVotingBars && _votingDirection) {
                                  _showVotingBars = false;
                                } else if (_showVotingBars &&
                                    !_votingDirection) {
                                  _votingDirection = true;
                                } else if (!_showVotingBars) {
                                  _userBloc.add(FetchDTCVPEvent());
                                  _showCommentInput = false;
                                  _showVotingBars = true;
                                  _votingDirection = true;
                                }
                              });
                            }),
                      ]),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '@${widget.author} | ' +
                    '${widget.publishDate} - ' +
                    (widget.duration.inHours == 0
                        ? widget.duration.toString().substring(2, 7) + ' min'
                        : widget.duration.toString().substring(0, 7) +
                            ' hours'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Text(
                  '${widget.dtcValue}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Transform.scale(
        //       scale: 0.8,
        //       alignment: Alignment.centerLeft,
        //       child: InputChip(
        //           label: Text(
        //             '',
        //           ),
        //           avatar: Padding(
        //             padding: const EdgeInsets.only(left: 8.0),
        //             child: FaIcon(FontAwesomeIcons.comment,
        //                 color: widget.alreadyVoted &&
        //                         !widget.alreadyVotedDirection
        //                     ? globalRed
        //                     : Colors.grey),
        //           ),
        //           onPressed: () {
        //             setState(() {
        //               if (!_showCommentInput) {
        //                 _showCommentInput = true;
        //                 _showVotingBars = false;
        //                 _userBloc.add(FetchDTCVPEvent());
        //               } else {
        //                 _showCommentInput = false;
        //               }
        //             });
        //           }),
        //     ),
        //     Transform.scale(
        //       scale: 0.8,
        //       alignment: Alignment.centerRight,
        //       child: Row(
        //         children: [
        //           InputChip(
        //             label: Text(
        //               widget.upvotesCount.toString(),
        //               style: Theme.of(context).textTheme.bodyText1,
        //             ),
        //             avatar: Padding(
        //               padding: const EdgeInsets.only(left: 4.0),
        //               child: FaIcon(
        //                 FontAwesomeIcons.thumbsUp,
        //                 color: widget.alreadyVoted &&
        //                         widget.alreadyVotedDirection
        //                     ? globalRed
        //                     : Colors.grey,
        //               ),
        //             ),
        //             onPressed: () {
        //               // if (!widget.alreadyVoted) {
        //               //   navigateToPostDetailPage(context, widget.author,
        //               //       widget.link, "upvote", false, () {});
        //               // }
        //               setState(() {
        //                 if (_showVotingBars && _votingDirection) {
        //                   _showVotingBars = false;
        //                 } else if (_showVotingBars && !_votingDirection) {
        //                   _votingDirection = true;
        //                 } else if (!_showVotingBars) {
        //                   _userBloc.add(FetchDTCVPEvent());
        //                   _showCommentInput = false;
        //                   _showVotingBars = true;
        //                   _votingDirection = true;
        //                 }
        //               });
        //             },
        //           ),
        //           SizedBox(
        //             width: 8,
        //           ),
        //           InputChip(
        //             label: Text(
        //               widget.downvotesCount.toString(),
        //               style: Theme.of(context).textTheme.bodyText1,
        //             ),
        //             avatar: Padding(
        //               padding: const EdgeInsets.only(left: 4.0),
        //               child: FaIcon(FontAwesomeIcons.thumbsDown,
        //                   color: widget.alreadyVoted &&
        //                           !widget.alreadyVotedDirection
        //                       ? globalRed
        //                       : Colors.grey),
        //             ),
        //             onPressed: () {
        //               setState(() {
        //                 if (_showVotingBars && _votingDirection) {
        //                   _votingDirection = false;
        //                 } else if (!_showVotingBars) {
        //                   _userBloc.add(FetchDTCVPEvent());
        //                   _showCommentInput = false;
        //                   _showVotingBars = true;
        //                   _votingDirection = false;
        //                 } else if (_showVotingBars && !_votingDirection) {
        //                   _showVotingBars = false;
        //                 }
        //               });
        //             },
        //           ),
        //         ],
        //       ),
        //   ),
        // ],
        //),
      ],
    );
  }
}
