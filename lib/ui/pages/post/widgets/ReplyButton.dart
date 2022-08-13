import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/postdetails/postdetails_bloc.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReplyButton extends StatefulWidget {
  final FaIcon icon;
  final String author;
  final String link;
  final String parentAuthor;
  final String parentLink;
  final double votingWeight;
  final double scale;
  final bool focusOnNewComment;
  final bool isMainPost;
  final PostBloc postBloc;
  final TransactionBloc txBloc;

  //final Comment comment;

  ReplyButton(
      {Key? key,
      required this.icon,
      required this.author,
      required this.link,
      required this.parentAuthor,
      required this.parentLink,
      required this.votingWeight,
      required this.scale,
      required this.focusOnNewComment,
      required this.isMainPost,
      required this.postBloc,
      required this.txBloc})
      : super(key: key);

  @override
  _ReplyButtonState createState() => _ReplyButtonState();
}

class _ReplyButtonState extends State<ReplyButton> {
  //static final _formKey = new GlobalKey<FormState>();
  TextEditingController _replyController = new TextEditingController();
  bool _replyPressed = false;
  bool _sendPressed = false;

  late UserBloc _userBloc;

  late int _currentVp;

  late int _voteVT = 0;

  @override
  void initState() {
    super.initState();
    if (widget.focusOnNewComment) {
      _replyPressed = true;
    }
    _replyController = new TextEditingController();

    _userBloc = BlocProvider.of<UserBloc>(context)..add(FetchDTCVPEvent());

    //_userBloc.add(FetchDTCVPEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: widget.txBloc,
      listener: (context, state) {
        if (state is TransactionSent) {
          setState(() {
            _replyController.text = "";
            _replyPressed = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.scale(
            scale: widget.scale,
            alignment: Alignment.topRight,
            child: globals.disableAnimations
                ? Visibility(
                    visible: globals.keyPermissions.contains(4),
                    child: InputChip(
                      label: widget.icon,
                      onPressed: () {
                        setState(() {
                          _replyPressed = !_replyPressed;
                        });
                      },
                    ),
                  )
                : RubberBand(
                    preferences: AnimationPreferences(
                        autoPlay: !_replyPressed && widget.isMainPost
                            ? AnimationPlayStates.Loop
                            : AnimationPlayStates.None,
                        offset: Duration(seconds: 6),
                        duration: Duration(seconds: 1),
                        magnitude: 0.7),
                    child: Visibility(
                      visible: globals.keyPermissions.contains(4),
                      child: InputChip(
                        label: widget.icon,
                        onPressed: () {
                          setState(() {
                            _replyPressed = !_replyPressed;
                          });
                        },
                      ),
                    ),
                  ),
          ),
          Visibility(
            visible: _replyPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70.w,
                  child: TextField(
                      autofocus: _replyPressed,
                      controller: _replyController,
                      cursorColor: globalRed,
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                BlocBuilder<UserBloc, UserState>(
                    bloc: _userBloc,
                    builder: (context, state) {
                      if (state is UserDTCVPLoadingState) {
                        return CircularProgressIndicator();
                      }
                      if (state is UserDTCVPLoadedState) {
                        _currentVp = state.vtBalance["v"]!;
                        _voteVT = int.parse((_currentVp.toDouble() *
                                (widget.votingWeight / 100))
                            .floor()
                            .toString());
                      }

                      return _sendPressed
                          ? Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: DTubeLogoPulse(
                                size: 10.w,
                              ),
                            )
                          : InputChip(
                              onPressed: () {
                                setState(() {
                                  _sendPressed = true;
                                });
                                print("SEND PRESSED");
                                UploadData _uploadData = new UploadData(
                                    link: "",
                                    parentAuthor: widget.author,
                                    parentPermlink: widget.link,
                                    title: "",
                                    description: _replyController.value.text,
                                    tag: "",
                                    vpPercent: widget.votingWeight,
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

                                widget.txBloc
                                    .add(SendCommentEvent(_uploadData));
                              },
                              label: Text(
                                  "send")); // TODO: only show send button when text is entered: https://flutter-examples.com/flutter-show-hide-button-on-text-field-input/
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
