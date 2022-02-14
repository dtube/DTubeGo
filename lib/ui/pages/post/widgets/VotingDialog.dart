import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotingDialog extends StatefulWidget {
  VotingDialog(
      {Key? key,
      required this.txBloc,
      required this.author,
      required this.link,
      required this.downvote,
      required this.defaultVote,
      required this.defaultTip,
      //required this.currentVT,
      required this.isPost,
      this.vertical,
      this.verticalModeCallbackVotingButtonsPressed,
      this.okCallback,
      this.cancelCallback,
      required this.fixedDownvoteActivated,
      required this.fixedDownvoteWeight})
      : super(key: key);
  TransactionBloc txBloc;

  String author;
  String link;
  double defaultVote;
  double defaultTip;
  double fixedDownvoteWeight;
  bool fixedDownvoteActivated;
  // double currentVT;
  bool isPost;
  bool? vertical; // only used in moments for now

  bool downvote;
  VoidCallback? verticalModeCallbackVotingButtonsPressed;

  VoidCallback? okCallback;
  VoidCallback? cancelCallback;

  @override
  _VotingDialogState createState() => _VotingDialogState();
}

class _VotingDialogState extends State<VotingDialog> {
  late double _vpValue;
  late double _tipValue;
  late TransactionBloc _txBloc;
  late TextEditingController _tagController;

  late PostBloc _postBloc;
  late UserBloc _userBloc;
  late double _currentVT;
  bool _sendButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _tagController = TextEditingController();
    _userBloc.add(FetchDTCVPEvent());
    _vpValue = widget.defaultVote;
    if (!widget.downvote) {
      _tipValue = widget.defaultTip;
    } else {
      _tipValue = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.cancelCallback != null) {
          widget.cancelCallback!();
        }
        return true;
      },
      child: PopUpDialogWithTitleLogo(
        titleWidgetPadding: 5.w,
        titleWidgetSize: 20.w,
        callbackOK: () {},
        titleWidget: FaIcon(
          widget.downvote ? FontAwesomeIcons.flag : FontAwesomeIcons.heart,
          size: 20.w,
          color: widget.downvote ? globalRed : globalBGColor,
        ),
        showTitleWidget: true,
        child: BlocBuilder<UserBloc, UserState>(
          bloc: _userBloc,
          builder: (context, state) {
            if (state is UserInitialState) {
              return DtubeLogoPulseWithSubtitle(
                  subtitle: "loading your balance...", size: 30.w);
            } else if (state is UserDTCVPLoadingState) {
              return DtubeLogoPulseWithSubtitle(
                  subtitle: "loading your balance...", size: 30.w);
            } else if (state is UserDTCVPLoadedState) {
              return SingleChildScrollView(
                child: BlocListener<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    if (state is TransactionSent) {
                      _postBloc.add(FetchPostEvent(widget.author, widget.link));
                    }
                  },
                  child: !_sendButtonPressed
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.downvote && widget.fixedDownvoteActivated
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 2.w,
                                        right: 2.w,
                                        top: 1.h,
                                        bottom: 2.h),
                                    child: Column(
                                      children: [
                                        Text(
                                            "Flagging this content will permanently hide it from your user interface." +
                                                " If the curation team agrees it will get removed from the whole platform.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        Padding(
                                          padding: EdgeInsets.only(top: 1.h),
                                          child: Text(
                                            "You can not undo this action!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(color: globalRed),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text("weight: ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5),
                                                Text(
                                                    (_vpValue.floor() *
                                                                (widget.downvote
                                                                    ? -1
                                                                    : 1))
                                                            .toString() +
                                                        '%',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5),
                                              ],
                                            ),
                                            RotatedBox(
                                              quarterTurns:
                                                  widget.downvote ? 1 : 3,
                                              child: Slider(
                                                min: 1,
                                                max: 100.0,
                                                value: _vpValue,

                                                label: (widget.downvote
                                                        ? "-"
                                                        : "") +
                                                    _vpValue
                                                        .floor()
                                                        .toString() +
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
                                            Text(
                                                shortVP((state.vtBalance['v']! /
                                                            100 *
                                                            _vpValue)
                                                        .floor()) +
                                                    " VP",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                          ],
                                        ),
                                        widget.downvote
                                            ? SizedBox(width: 0)
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(left: 4.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("vote tip: ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5),
                                                        Text(
                                                            _tipValue
                                                                    .floor()
                                                                    .toString() +
                                                                '%',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5),
                                                      ],
                                                    ),
                                                    RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Slider(
                                                        min: 0.0,
                                                        max: 100.0,
                                                        value: _tipValue,
                                                        label: _tipValue
                                                                .floor()
                                                                .toString() +
                                                            "%",
                                                        //divisions: 20,
                                                        inactiveColor:
                                                            globalBlue,
                                                        activeColor: globalRed,
                                                        onChanged:
                                                            (dynamic value) {
                                                          setState(() {
                                                            _tipValue = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text("",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                            widget.isPost &&
                                    !(widget.downvote &&
                                        widget.fixedDownvoteActivated)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w,
                                        right: 20.w,
                                        top: 1.h,
                                        bottom: 2.h),
                                    child: Container(
                                      height: 8.h,
                                      child: OverlayTextInput(
                                        textEditingController: _tagController,
                                        label: "curator tag",
                                        autoFocus: false,
                                      ),
                                    ),
                                  )
                                : SizedBox(width: 0),
                            InkWell(
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: globalRed,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)),
                                ),
                                child: Text(
                                  widget.downvote ? "Flag now!" : "Send Vote",
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onTap: () async {
                                var voteValue =
                                    (state.vtBalance['v']! * (_vpValue / 100))
                                        .floor();
                                int _txType = 5;
                                TxData txdata = TxData(
                                  author: widget.author,
                                  link: widget.link,
                                  tag: _tagController.value.text,
                                  vt: voteValue * (widget.downvote ? -1 : 1),
                                );

                                if (_tipValue > 0 && !widget.downvote) {
                                  _txType = 19;
                                  txdata = TxData(
                                      author: widget.author,
                                      link: widget.link,
                                      tag: _tagController.value.text,
                                      vt: voteValue *
                                          (widget.downvote ? -1 : 1),
                                      tip: _tipValue.floor());
                                }
                                Transaction newTx =
                                    Transaction(type: _txType, data: txdata);

                                _txBloc.add(
                                    SignAndSendTransactionEvent(tx: newTx));
                                Navigator.of(context).pop();

                                if (widget.okCallback != null) {
                                  widget.okCallback!();
                                }
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
              );
            } else {
              return DtubeLogoPulseWithSubtitle(
                  subtitle: "loading your balance...", size: 30.w);
            }
          },
        ),
      ),
    );

    //   }),
    // );
  }
}
