import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/ui/pages/post/widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class VotingButtons extends StatefulWidget {
  VotingButtons(
      {Key? key,
      this.upvotes,
      this.downvotes,
      required this.author,
      required this.link,
      required this.alreadyVoted,
      required this.alreadyVotedDirection,
      required this.defaultVotingWeight,
      required this.defaultVotingTip,
      required this.scale,
      required this.isPost,
      required this.focusVote,
      this.vertical,
      required this.iconColor,
      this.verticalModeCallbackVotingButtonsPressed,
      this.verticalModeCallbackVoteSent,
      required this.fadeInFromLeft,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight})
      : super(key: key);

  final String author;
  final String link;
  final List<Votes>? upvotes;
  final List<Votes>? downvotes;
  final bool alreadyVoted;
  final bool alreadyVotedDirection;
  final String focusVote;
  final bool? vertical; // only used in moments for now
  final VoidCallback?
      verticalModeCallbackVotingButtonsPressed; // only used in moments for now
  final VoidCallback?
      verticalModeCallbackVoteSent; // only used in moments for now

  final double defaultVotingWeight;
  final double defaultVotingTip;

  final double fixedDownvoteWeight;
  final bool fixedDownvoteActivated;

  final Color iconColor;

  final double scale;
  final bool isPost;
  final bool fadeInFromLeft;
  //final int voteVT = 0;

  @override
  _VotingButtonsState createState() => _VotingButtonsState();
}

class _VotingButtonsState extends State<VotingButtons> {
  bool _upvotePressed = false;
  bool _downvotePressed = false;

  int _currentVT = 0;
  int _voteVT = 0;

  @override
  void initState() {
    super.initState();
    _voteVT = int.parse(
        (_currentVT.toDouble() * (widget.defaultVotingWeight / 100))
            .floor()
            .toString());
    if (widget.focusVote.contains("vote")) {
      if (widget.focusVote == "upvote") {
        _upvotePressed = true;
      } else {
        _downvotePressed = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vertical != null && widget.vertical! == true) {
      return Stack(children: [
        Visibility(
          visible: !_upvotePressed && !_downvotePressed,
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ShadowedIcon(
                      visible: globals.keyPermissions.contains(5),
                      icon: FontAwesomeIcons.heart,
                      color: widget.alreadyVoted && widget.alreadyVotedDirection
                          ? globalRed
                          : widget.iconColor,
                      shadowColor: Colors.black,
                      size: 5.w,
                    ),
                  ),
                  onPressed: () {
                    if (!widget.alreadyVoted) {
                      setState(() {
                        _upvotePressed = !_upvotePressed;
                        if (widget.verticalModeCallbackVotingButtonsPressed !=
                            null) {
                          widget.verticalModeCallbackVotingButtonsPressed;
                        }
                        if (_upvotePressed) {
                          _downvotePressed = false;
                        }
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ShadowedIcon(
                      icon: FontAwesomeIcons.flag,
                      color:
                          widget.alreadyVoted && !widget.alreadyVotedDirection
                              ? globalRed
                              : widget.iconColor,
                      shadowColor: Colors.black,
                      size: 5.w,
                    ),
                  ),
                  onPressed: () {
                    if (!widget.alreadyVoted) {
                      widget.verticalModeCallbackVotingButtonsPressed;
                      setState(() {
                        _downvotePressed = !_downvotePressed;

                        if (_downvotePressed) {
                          _upvotePressed = false;
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _upvotePressed || _downvotePressed,
          child: BlocProvider<UserBloc>(
            create: (BuildContext context) =>
                UserBloc(repository: UserRepositoryImpl()),
            child: VotingSlider(
              defaultVote: widget.defaultVotingWeight,
              defaultTip: widget.defaultVotingTip,
              author: widget.author,
              link: widget.link,
              downvote: _downvotePressed,
              //currentVT: state.vtBalance['v']! + 0.0,
              isPost: widget.isPost,
              vertical: widget.vertical,
            ),
          ),
        ),
      ]);
    } else {
      if (widget.fadeInFromLeft) {
        return globals.disableAnimations
            ? VotingButtonRow(
                upvotePressed: _upvotePressed,
                downvotePressed: _downvotePressed,
                widget: widget)
            : SlideInLeft(
                preferences:
                    AnimationPreferences(offset: Duration(milliseconds: 100)),
                child: VotingButtonRow(
                    upvotePressed: _upvotePressed,
                    downvotePressed: _downvotePressed,
                    widget: widget),
              );
      } else {
        return globals.disableAnimations
            ? VotingButtonRow(
                upvotePressed: _upvotePressed,
                downvotePressed: _downvotePressed,
                widget: widget)
            : SlideInRight(
                preferences:
                    AnimationPreferences(offset: Duration(milliseconds: 100)),
                child: VotingButtonRow(
                    upvotePressed: _upvotePressed,
                    downvotePressed: _downvotePressed,
                    widget: widget),
              );
      }
    }
  }
}

class VotingButtonRow extends StatelessWidget {
  const VotingButtonRow({
    Key? key,
    required bool upvotePressed,
    required bool downvotePressed,
    required this.widget,
  })  : _upvotePressed = upvotePressed,
        _downvotePressed = downvotePressed,
        super(key: key);

  final bool _upvotePressed;
  final bool _downvotePressed;

  final VotingButtons widget;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_upvotePressed && !_downvotePressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputChip(
            isEnabled: globals.keyPermissions.contains(5),
            label: Text(
              widget.upvotes != null && widget.upvotes!.isNotEmpty
                  ? (widget.upvotes!.length).toString()
                  : '0',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            avatar: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: FaIcon(
                FontAwesomeIcons.heart,
                color: widget.alreadyVoted && widget.alreadyVotedDirection
                    ? globalRed
                    : widget.iconColor,
              ),
            ),
            onPressed: () {
              if (!widget.alreadyVoted) {
                // setState(() {
                //   _upvotePressed = !_upvotePressed;
                //   if (_upvotePressed) {
                //     _downvotePressed = false;
                //   }
                // });
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<PostBloc>(
                          create: (context) =>
                              PostBloc(repository: PostRepositoryImpl())),
                      BlocProvider<UserBloc>(
                          create: (context) =>
                              UserBloc(repository: UserRepositoryImpl())),
                    ],
                    child: VotingDialog(
                      txBloc: BlocProvider.of<TransactionBloc>(context),
                      defaultVote: widget.defaultVotingWeight,
                      defaultTip: widget.defaultVotingTip,
                      author: widget.author,
                      link: widget.link,
                      downvote: false,
                      //currentVT: state.vtBalance['v']! + 0.0,
                      isPost: widget.isPost,
                      fixedDownvoteActivated: widget.fixedDownvoteActivated,
                      fixedDownvoteWeight: widget.fixedDownvoteWeight,
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(
            width: 8,
          ),
          InputChip(
            isEnabled: globals.keyPermissions.contains(5),
            label: Text(
              widget.downvotes != null && widget.downvotes!.isNotEmpty
                  ? (widget.downvotes!.length).toString()
                  : '0',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            avatar: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: FaIcon(FontAwesomeIcons.flag,
                  color: widget.alreadyVoted && !widget.alreadyVotedDirection
                      ? globalRed
                      : widget.iconColor),
            ),
            onPressed: () {
              if (!widget.alreadyVoted) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<PostBloc>(
                          create: (context) =>
                              PostBloc(repository: PostRepositoryImpl())),
                      BlocProvider<UserBloc>(
                          create: (context) =>
                              UserBloc(repository: UserRepositoryImpl())),
                    ],
                    child: VotingDialog(
                      txBloc: BlocProvider.of<TransactionBloc>(context),
                      defaultVote: widget.defaultVotingWeight,
                      defaultTip: widget.defaultVotingTip,
                      author: widget.author,
                      link: widget.link,
                      downvote: true,
                      //currentVT: state.vtBalance['v']! + 0.0,
                      isPost: widget.isPost,
                      fixedDownvoteActivated: widget.fixedDownvoteActivated,
                      fixedDownvoteWeight: widget.fixedDownvoteWeight,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class VotingSlider extends StatefulWidget {
  VotingSlider(
      {Key? key,
      required this.author,
      required this.link,
      required this.downvote,
      required this.defaultVote,
      required this.defaultTip,
      //required this.currentVT,
      required this.isPost,
      this.vertical,
      this.verticalModeCallbackVotingButtonsPressed})
      : super(key: key);

  String author;
  String link;
  double defaultVote;
  double defaultTip;
  //double currentVT;
  bool isPost;
  bool? vertical; // only used in moments for now

  bool downvote;
  VoidCallback?
      verticalModeCallbackVotingButtonsPressed; // only used in moments for now

  @override
  _VotingSliderState createState() => _VotingSliderState();
}

class _VotingSliderState extends State<VotingSlider> {
  late double _vpValue;
  late double _tipValue;
  late TransactionBloc _txBloc;
  late TextEditingController _tagController;

  late PostBloc _postBloc;
  late double _currentVT;
  bool _sendButtonPressed = false;
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _tagController = TextEditingController();
    _userBloc = BlocProvider.of<UserBloc>(context);

    _userBloc.add(FetchDTCVPEvent());

    _vpValue = widget.defaultVote;
    _tipValue = widget.defaultTip;
  }

  @override
  Widget build(BuildContext context) {
    // verical only used in moments for now
    if (widget.vertical != null && widget.vertical! == true) {
      return BlocBuilder<UserBloc, UserState>(
          bloc: _userBloc,
          builder: (context, state) {
            if (state is UserInitialState) {
              return SizedBox(width: 0);
            } else if (state is UserDTCVPLoadingState) {
              return SizedBox(width: 0);
            } else if (state is UserDTCVPLoadedState) {
              return BlocListener<TransactionBloc, TransactionState>(
                listener: (context, state) {
                  if (state is TransactionSent) {
                    _postBloc.add(FetchPostEvent(widget.author, widget.link));
                  }
                },
                child: !_sendButtonPressed
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 40.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              OverlayText(
                                text: widget.downvote ? "Downvote" : "Upvote",
                                bold: true,
                                sizeMultiply: 1.4,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      OverlayText(
                                        text: "weight: ",
                                        bold: true,
                                        sizeMultiply: 1,
                                        maxLines: 2,
                                      ),
                                      OverlayText(
                                        text: (_vpValue.floor() *
                                                    (widget.downvote ? -1 : 1))
                                                .toString() +
                                            '%',
                                        bold: true,
                                        sizeMultiply: 1,
                                      ),
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Slider(
                                          min: 1,
                                          max: 100.0,
                                          value: _vpValue,

                                          label: (widget.downvote ? "-" : "") +
                                              _vpValue.floor().toString() +
                                              "%",
                                          //divisions: 40,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _vpValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  widget.downvote
                                      ? SizedBox(width: 0)
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            OverlayText(
                                              text: "vote tip: ",
                                              bold: true,
                                              sizeMultiply: 1,
                                            ),
                                            OverlayText(
                                              text:
                                                  _tipValue.floor().toString() +
                                                      '%',
                                              bold: true,
                                              sizeMultiply: 1,
                                            ),
                                            RotatedBox(
                                              quarterTurns: 1,
                                              child: Slider(
                                                min: 0.0,
                                                max: 100.0,
                                                value: _tipValue,
                                                label: _tipValue
                                                        .floor()
                                                        .toString() +
                                                    "%",
                                                //divisions: 20,
                                                inactiveColor: globalBlue,
                                                activeColor: globalRed,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    _tipValue = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              Container(
                                width: 25.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    widget.isPost
                                        ? TextFormField(
                                            controller: _tagController,
                                            decoration: new InputDecoration(
                                              labelText: "curator tag",
                                            ),
                                          )
                                        : SizedBox(width: 0),
                                    SizedBox(height: 8),
                                    BlocBuilder<UserBloc, UserState>(
                                        builder: (context, state) {
                                      if (state is UserDTCVPLoadedState) {
                                        _currentVT =
                                            state.vtBalance["v"]!.toDouble();
                                        return ElevatedButton(
                                            onPressed: () {
                                              var voteValue = (_currentVT *
                                                      (_vpValue / 100))
                                                  .floor();
                                              int _txType = 5;
                                              TxData txdata = TxData(
                                                author: widget.author,
                                                link: widget.link,
                                                tag: _tagController.value.text,
                                                vt: voteValue *
                                                    (widget.downvote ? -1 : 1),
                                              );

                                              if (_tipValue > 0) {
                                                _txType = 19;
                                                txdata = TxData(
                                                    author: widget.author,
                                                    link: widget.link,
                                                    tag: _tagController
                                                        .value.text,
                                                    vt: voteValue,
                                                    tip: _tipValue.floor());
                                              }
                                              Transaction newTx = Transaction(
                                                  type: _txType, data: txdata);

                                              _txBloc.add(
                                                  SignAndSendTransactionEvent(
                                                      tx: newTx));
                                              setState(() {
                                                _sendButtonPressed = true;
                                              });
                                            },
                                            child: Text("send"));
                                      } else {
                                        return SizedBox(
                                          width: 0,
                                        );
                                      }
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
              );
            } else {
              return SizedBox(height: 0);
            }
          });
    } else {
      return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSent) {
            _postBloc.add(FetchPostEvent(widget.author, widget.link));
          }
        },
        child: !_sendButtonPressed
            ? Column(
                children: [
                  Text(widget.downvote ? "Downvote" : "Upvote",
                      style: Theme.of(context).textTheme.headline6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 60.w,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "voting weight: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        Text(
                                          (_vpValue.floor() *
                                                      (widget.downvote
                                                          ? -1
                                                          : 1))
                                                  .toString() +
                                              '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Slider(
                                    min: 1,
                                    max: 100.0,
                                    value: _vpValue,

                                    label: (widget.downvote ? "-" : "") +
                                        _vpValue.floor().toString() +
                                        "%",
                                    //divisions: 40,
                                    inactiveColor: globalBlue,
                                    activeColor: globalRed,
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _vpValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              widget.downvote
                                  ? SizedBox(width: 0)
                                  : Row(
                                      children: [
                                        Container(
                                          width: 25.w,
                                          child: Column(
                                            children: [
                                              Text(
                                                "vote tip: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              ),
                                              Text(
                                                _tipValue.floor().toString() +
                                                    '%',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Slider(
                                          min: 0.0,
                                          max: 100.0,
                                          value: _tipValue,
                                          label: _tipValue.floor().toString() +
                                              "%",
                                          //divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _tipValue = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          )),
                      Container(
                        width: 25.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.isPost
                                ? TextFormField(
                                    controller: _tagController,
                                    decoration: new InputDecoration(
                                      labelText: "curator tag",
                                    ),
                                  )
                                : SizedBox(width: 0),
                            SizedBox(height: 8),
                            BlocBuilder<UserBloc, UserState>(
                                builder: (context, state) {
                              if (state is UserDTCVPLoadedState) {
                                _currentVT = state.vtBalance["v"]!.toDouble();
                                return ElevatedButton(
                                    onPressed: () {
                                      var voteValue =
                                          (_currentVT * (_vpValue / 100))
                                              .floor();
                                      int _txType = 5;
                                      TxData txdata = TxData(
                                        author: widget.author,
                                        link: widget.link,
                                        tag: _tagController.value.text,
                                        vt: voteValue *
                                            (widget.downvote ? -1 : 1),
                                      );

                                      if (_tipValue > 0) {
                                        _txType = 19;
                                        txdata = TxData(
                                            author: widget.author,
                                            link: widget.link,
                                            tag: _tagController.value.text,
                                            vt: voteValue,
                                            tip: _tipValue.floor());
                                      }
                                      Transaction newTx = Transaction(
                                          type: _txType, data: txdata);

                                      _txBloc.add(SignAndSendTransactionEvent(
                                          tx: newTx));
                                      widget
                                          .verticalModeCallbackVotingButtonsPressed;
                                      setState(() {
                                        _sendButtonPressed = true;
                                      });
                                    },
                                    child: Text("send"));
                              } else {
                                return SizedBox(
                                  width: 0,
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      );
    }
  }
}

class VotingSliderStandalone extends StatefulWidget {
  VotingSliderStandalone({
    Key? key,
    required this.author,
    required this.link,
    required this.downvote,
    required this.defaultVote,
    required this.defaultTip,
    required this.currentVT,
    required this.isPost,
    this.sendCallback,
    this.cancelCallback,
  }) : super(key: key);

  String author;
  String link;
  double defaultVote;
  double defaultTip;
  double currentVT;
  bool isPost;

  bool downvote;
  VoidCallback? sendCallback;
  VoidCallback? cancelCallback;

  @override
  _VotingSliderStandaloneState createState() => _VotingSliderStandaloneState();
}

class _VotingSliderStandaloneState extends State<VotingSliderStandalone> {
  late double _vpValue;
  late double _tipValue;
  late TransactionBloc _txBloc;
  late TextEditingController _tagController;
  late bool _sendButtonPressed;

  @override
  void initState() {
    super.initState();
    _sendButtonPressed = false;
    _txBloc = BlocProvider.of<TransactionBloc>(context);

    _tagController = TextEditingController();
    //_userBloc.add(FetchDTCVPEvent());
    _vpValue = widget.defaultVote;
    _tipValue = widget.defaultTip;
  }

  @override
  Widget build(BuildContext context) {
    // verical only used in moments for now
    return !_sendButtonPressed
        ? Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 80.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OverlayText(
                      text: widget.downvote ? "Downvote" : "Upvote",
                      bold: true,
                      sizeMultiply: 1.8,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OverlayText(
                              text: "weight: ",
                              bold: true,
                              sizeMultiply: 1,
                              maxLines: 2,
                            ),
                            OverlayText(
                              text: (_vpValue.floor() *
                                          (widget.downvote ? -1 : 1))
                                      .toString() +
                                  '%',
                              bold: true,
                              sizeMultiply: 1,
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                min: 1,
                                max: 100.0,
                                value: _vpValue,

                                label: (widget.downvote ? "-" : "") +
                                    _vpValue.floor().toString() +
                                    "%",
                                //divisions: 40,
                                inactiveColor: globalBlue,
                                activeColor: globalRed,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    _vpValue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        widget.downvote
                            ? SizedBox(width: 0)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  OverlayText(
                                    text: "vote tip: ",
                                    bold: true,
                                    sizeMultiply: 1,
                                  ),
                                  OverlayText(
                                    text: _tipValue.floor().toString() + '%',
                                    bold: true,
                                    sizeMultiply: 1,
                                  ),
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Slider(
                                      min: 0.0,
                                      max: 100.0,
                                      value: _tipValue,
                                      label: _tipValue.floor().toString() + "%",
                                      //divisions: 20,
                                      inactiveColor: globalBlue,
                                      activeColor: globalRed,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          _tipValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        Container(
                          width: 35.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.isPost
                                  ? Container(
                                      height: 50,
                                      child: OverlayTextInput(
                                          textEditingController: _tagController,
                                          label: "curator tag",
                                          autoFocus: false),
                                    )
                                  : SizedBox(width: 0),
                              SizedBox(height: 8),
                              ElevatedButton(
                                child: Text("send"),
                                onPressed: () async {
                                  var voteValue =
                                      (widget.currentVT * (_vpValue / 100))
                                          .floor();
                                  int _txType = 5;
                                  TxData txdata = TxData(
                                    author: widget.author,
                                    link: widget.link,
                                    tag: _tagController.value.text,
                                    vt: voteValue * (widget.downvote ? -1 : 1),
                                  );

                                  if (_tipValue > 0) {
                                    _txType = 19;
                                    txdata = TxData(
                                        author: widget.author,
                                        link: widget.link,
                                        tag: _tagController.value.text,
                                        vt: voteValue,
                                        tip: _tipValue.floor());
                                  }
                                  Transaction newTx =
                                      Transaction(type: _txType, data: txdata);

                                  _txBloc.add(
                                      SignAndSendTransactionEvent(tx: newTx));
                                  setState(() {
                                    _sendButtonPressed = true;
                                  });

                                  if (widget.sendCallback != null) {
                                    widget.sendCallback!();
                                  }
                                },
                              ),
                              widget.cancelCallback != null
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: InputChip(
                                        label: Text(
                                          "cancel",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        onPressed: () {
                                          widget.cancelCallback!();
                                        },
                                      ),
                                    )
                                  : SizedBox(height: 0)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox(
            width: 0,
          );
  }
}
