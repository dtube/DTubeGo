import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/post/widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Comments/CommentDialog.dart';
import 'package:dtube_go/ui/widgets/FullScreenButton.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/pages/post/widgets/VoteButtons.dart';
import 'package:dtube_go/ui/widgets/InputFields/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/gifts/GiftDialog.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:dtube_go/utils/randomGenerator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';
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
import 'package:shimmer_animation/shimmer_animation.dart';

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
  TextEditingController _giftMemoController = new TextEditingController();
  TextEditingController _giftDTCController = new TextEditingController();

  late bool _showVotingBars;

  late bool _votingDirection; // true = upvote | false = downvote

  late bool _showCommentInput;
  late bool _showGiftInput;

  late UserBloc _userBloc;
  int _currentVp = 0;

  @override
  void initState() {
    super.initState();
    _showVotingBars = false;
    _votingDirection = true;
    _showCommentInput = false;
    _showGiftInput = false;
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
                  aspectRatio: 16 / 9,
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
                      :
                      // shimmer creates a light color cast even if the animation is not present
                      Shimmer(
                          duration: Duration(seconds: 5),
                          interval: Duration(seconds: generateRandom(3, 15)),
                          color: globalAlmostWhite,
                          colorOpacity: 0.1,
                          child: CachedNetworkImage(
                            imageUrl: widget.thumbnailUrl,
                            fit: BoxFit.fitWidth,
                            errorWidget: (context, url, error) => DTubeLogo(
                              size: 50,
                            ),
                          ),
                        ),
                ),
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
                          portraitVideoPadding: 30.w,
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
              // VOTING DIALOG
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
                            return DtubeLogoPulseWithSubtitle(
                                subtitle: "loading your balances...",
                                size: 30.w);
                          }
                          if (state is UserDTCVPLoadedState) {
                            _currentVp = state.vtBalance["v"]!;

                            return AspectRatio(
                              aspectRatio: 8 / 5,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  color: Colors.black.withAlpha(99),
                                  child: VotingSliderStandalone(
                                    defaultVote: double.parse(
                                        widget.defaultPostVotingWeight),
                                    defaultTip: double.parse(
                                        widget.defaultPostVotingTip),
                                    author: widget.author,
                                    link: widget.link,
                                    downvote: !_votingDirection,
                                    currentVT: _currentVp + 0.0,
                                    isPost: true,
                                    cancelCallback: () {
                                      setState(() {
                                        _showVotingBars = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                          return DtubeLogoPulseWithSubtitle(
                              subtitle: "loading your balances...", size: 30.w);
                        },
                      ),
                    ),
                  )),
              // COMMENT DIALOG
              Visibility(
                  visible: _showCommentInput,
                  child: AspectRatio(
                    aspectRatio: 8 / 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        //color: Colors.black.withAlpha(95),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.0),
                                  Colors.black.withAlpha(95),
                                  Colors.black.withAlpha(95),
                                  Colors.black.withOpacity(0.0),
                                ],
                                stops: [
                                  0.0,
                                  0.2,
                                  0.8,
                                  1.0
                                ])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.w,
                              child: Padding(
                                  padding: EdgeInsets.all(5.w),
                                  child: OverlayTextInput(
                                    autoFocus: _showCommentInput,
                                    label: 'Share some feedback',
                                    textEditingController: _replyController,
                                  )),
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

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InputChip(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          UploadData _uploadData =
                                              new UploadData(
                                                  link: "",
                                                  parentAuthor: widget.author,
                                                  parentPermlink: widget.link,
                                                  title: "",
                                                  description: _replyController
                                                      .value.text,
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
                                              .add(SendCommentEvent(
                                                  _uploadData));
                                          setState(() {
                                            _showCommentInput = false;
                                            _replyController.text = '';
                                          });
                                        },
                                        backgroundColor: globalRed,
                                        label: Padding(
                                          padding: EdgeInsets.all(
                                              globalIconSizeBig / 4),
                                          child: FaIcon(
                                            FontAwesomeIcons.paperPlane,
                                            size: globalIconSizeBig,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: InputChip(
                                          label: Text(
                                            "cancel",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _showCommentInput = false;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  )),
              // GIFT DIALOG
              Visibility(
                  visible: _showGiftInput,
                  child: AspectRatio(
                    aspectRatio: 8 / 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        //color: Colors.black.withAlpha(95),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.0),
                                  Colors.black.withAlpha(95),
                                  Colors.black.withAlpha(95),
                                  Colors.black.withOpacity(0.0),
                                ],
                                stops: [
                                  0.0,
                                  0.2,
                                  0.8,
                                  1.0
                                ])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 5.h),
                                Container(
                                  width: 80.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40.w,
                                        child: OverlayNumberInput(
                                          autoFocus: _showGiftInput,
                                          textEditingController:
                                              _giftDTCController,
                                          label: "your gift",
                                        ),
                                      ),
                                      Text(" DTC",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 80.w,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.w),
                                    child: OverlayTextInput(
                                        autoFocus: false,
                                        textEditingController:
                                            _giftMemoController,
                                        label: "Add some kind words"),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InputChip(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    String _memo = "";

                                    if (widget.link != "") {
                                      _memo =
                                          "Gift sent through https://d.tube/#!/v/${widget.author}/${widget.link}";
                                      if (_giftMemoController.value.text !=
                                          "") {
                                        _memo = _memo +
                                            ": ${_giftMemoController.value.text}";
                                      }
                                    } else {
                                      _memo = _giftMemoController.value.text;
                                    }
                                    TxData txdata = TxData(
                                        receiver: widget.author,
                                        amount: (double.parse(_giftDTCController
                                                    .value.text) *
                                                100)
                                            .floor(),
                                        memo: _memo);
                                    Transaction newTx =
                                        Transaction(type: 3, data: txdata);
                                    BlocProvider.of<TransactionBloc>(context)
                                        .add(
                                            SignAndSendTransactionEvent(newTx));
                                    setState(() {
                                      _showGiftInput = false;
                                    });
                                  },
                                  backgroundColor: globalRed,
                                  label: Padding(
                                    padding:
                                        EdgeInsets.all(globalIconSizeBig / 4),
                                    child: FaIcon(
                                      FontAwesomeIcons.paperPlane,
                                      size: globalIconSizeBig,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: InputChip(
                                    label: Text(
                                      "cancel",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showGiftInput = false;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
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
                    iconSize: globalIconSizeSmall,
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
                FadeIn(
                  preferences: AnimationPreferences(
                      offset: Duration(milliseconds: 500),
                      duration: Duration(seconds: 1)),
                  child: InkWell(
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
                        height: _avatarSize),
                  ),
                ),
                SizedBox(width: 2.w),
                FadeInLeftBig(
                  preferences: AnimationPreferences(
                    offset: Duration(milliseconds: 100),
                    duration: Duration(milliseconds: 350),
                  ),
                  child: Container(
                    width: 63.w,
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
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: 38.w,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.oc
                          ? FadeIn(
                              preferences: AnimationPreferences(
                                  offset: Duration(milliseconds: 700),
                                  duration: Duration(seconds: 1)),
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: FaIcon(
                                  FontAwesomeIcons.award,
                                  size: globalIconSizeSmall,
                                ),
                              ),
                            )
                          : SizedBox(width: globalIconSizeSmall),
                      TagChip(
                        waitBeforeFadeIn: Duration(milliseconds: 600),
                        fadeInFromLeft: false,
                        tagName: widget.mainTag,
                        width: 20.w,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SpeedDial(
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.w),
                          child: FadeIn(
                            preferences: AnimationPreferences(
                                offset: Duration(milliseconds: 700),
                                duration: Duration(seconds: 1)),
                            child: Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: HeartBeat(
                                preferences: AnimationPreferences(
                                    magnitude: 1.2,
                                    offset: Duration(seconds: 3),
                                    autoPlay: AnimationPlayStates.Loop),
                                child: ShadowedIcon(
                                    icon: FontAwesomeIcons.ellipsisV,
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeSmall),
                              ),
                            ),
                          ),
                        ),
                        activeChild: Padding(
                          padding: EdgeInsets.only(left: 7.w),
                          child: ShadowedIcon(
                              icon: FontAwesomeIcons.sortDown,
                              color: Colors.white,
                              shadowColor: Colors.black,
                              size: globalIconSizeSmall),
                        ),
                        buttonSize: globalIconSizeSmall * 2,
                        useRotationAnimation: false,
                        direction: SpeedDialDirection.Up,
                        visible: true,
                        spacing: 0.0,
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
                        children: [
                          // COMMENT BUTTON
                          SpeedDialChild(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: ShadowedIcon(
                                    icon: FontAwesomeIcons.comment,
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeBig),
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      BlocProvider<UserBloc>(
                                    create: (context) => UserBloc(
                                        repository: UserRepositoryImpl()),
                                    child: CommentDialog(
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      originAuthor: widget.author,
                                      originLink: widget.link,
                                      defaultCommentVote: double.parse(
                                          widget.defaultCommentVotingWeight),
                                    ),
                                  ),
                                );
                              }),
                          // DOWNVOTE BUTTON
                          SpeedDialChild(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: ShadowedIcon(
                                    icon: FontAwesomeIcons.thumbsDown,
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeBig),
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              onTap: () {
                                if (!widget.alreadyVoted) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        MultiBlocProvider(
                                      providers: [
                                        BlocProvider<PostBloc>(
                                            create: (context) => PostBloc(
                                                repository:
                                                    PostRepositoryImpl())),
                                        BlocProvider<UserBloc>(
                                            create: (context) => UserBloc(
                                                repository:
                                                    UserRepositoryImpl())),
                                      ],
                                      child: VotingDialog(
                                        txBloc:
                                            BlocProvider.of<TransactionBloc>(
                                                context),
                                        defaultVote: double.parse(
                                            widget.defaultPostVotingWeight),
                                        defaultTip: double.parse(
                                            widget.defaultPostVotingTip),
                                        author: widget.author,
                                        link: widget.link,
                                        downvote: true,
                                        //currentVT: state.vtBalance['v']! + 0.0,
                                        isPost: true,
                                      ),
                                    ),
                                  );
                                }
                              }),
                          // UPVOTE BUTTON

                          SpeedDialChild(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: ShadowedIcon(
                                    icon: FontAwesomeIcons.thumbsUp,
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeBig),
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              onTap: () {
                                if (!widget.alreadyVoted) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        MultiBlocProvider(
                                      providers: [
                                        BlocProvider<PostBloc>(
                                            create: (context) => PostBloc(
                                                repository:
                                                    PostRepositoryImpl())),
                                        BlocProvider<UserBloc>(
                                            create: (context) => UserBloc(
                                                repository:
                                                    UserRepositoryImpl())),
                                      ],
                                      child: VotingDialog(
                                        txBloc:
                                            BlocProvider.of<TransactionBloc>(
                                                context),
                                        defaultVote: double.parse(
                                            widget.defaultPostVotingWeight),
                                        defaultTip: double.parse(
                                            widget.defaultPostVotingTip),
                                        author: widget.author,
                                        link: widget.link,
                                        downvote: false,
                                        //currentVT: state.vtBalance['v']! + 0.0,
                                        isPost: true,
                                      ),
                                    ),
                                  );
                                }
                              }),
                          // GIFT BUTTON
                          SpeedDialChild(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: ShadowedIcon(
                                    icon: FontAwesomeIcons.gift,
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    size: globalIconSizeBig),
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => GiftDialog(
                                    txBloc: BlocProvider.of<TransactionBloc>(
                                        context),
                                    receiver: widget.author,
                                    originLink: widget.link,
                                  ),
                                );
                              }),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        FadeInDown(
          preferences:
              AnimationPreferences(offset: Duration(milliseconds: 500)),
          child: Padding(
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
                  padding: EdgeInsets.only(right: 0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.dtcValue}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: DTubeLogoShadowed(size: 5.w),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
