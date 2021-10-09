import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:flutter/services.dart';

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
      required this.currentVT,
      required this.isPost,
      this.vertical,
      this.verticalModeCallbackVotingButtonsPressed})
      : super(key: key);
  TransactionBloc txBloc;

  String author;
  String link;
  double defaultVote;
  double defaultTip;
  double currentVT;
  bool isPost;
  bool? vertical; // only used in moments for now

  bool downvote;
  VoidCallback? verticalModeCallbackVotingButtonsPressed;

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
    _tipValue = widget.defaultTip;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: globalAlmostBlack,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Builder(
        builder: (context) {
          return Container(
            height: 65.h,
            width: 100.w,
            child: SingleChildScrollView(
              child: BlocListener<TransactionBloc, TransactionState>(
                listener: (context, state) {
                  if (state is TransactionSent) {
                    _postBloc.add(FetchPostEvent(widget.author, widget.link));
                  }
                },
                child: !_sendButtonPressed
                    ? Column(
                        children: [
                          FaIcon(
                            widget.downvote
                                ? FontAwesomeIcons.thumbsDown
                                : FontAwesomeIcons.thumbsUp,
                            size: 25.w,
                            color: globalAlmostWhite,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      quarterTurns: widget.downvote ? 1 : 3,
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
                                    : Padding(
                                        padding: EdgeInsets.only(left: 4.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text("vote tip: ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5),
                                                Text(
                                                    _tipValue
                                                            .floor()
                                                            .toString() +
                                                        '%',
                                                    style: Theme.of(context)
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
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.isPost
                                    ? TextFormField(
                                        controller: _tagController,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: new InputDecoration(
                                            labelText: "curator tag",
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      )
                                    : SizedBox(width: 0),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: BlocBuilder<UserBloc, UserState>(
                                      builder: (context, state) {
                                    if (state is UserDTCVPLoadedState) {
                                      _currentVT =
                                          state.vtBalance["v"]!.toDouble();
                                      return InputChip(
                                          backgroundColor: globalRed,
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
                                                  tag:
                                                      _tagController.value.text,
                                                  vt: voteValue *
                                                      (widget.downvote
                                                          ? -1
                                                          : 1),
                                                  tip: _tipValue.floor());
                                            }
                                            Transaction newTx = Transaction(
                                                type: _txType, data: txdata);

                                            _txBloc.add(
                                                SignAndSendTransactionEvent(
                                                    newTx));
                                            widget
                                                .verticalModeCallbackVotingButtonsPressed;
                                            setState(() {
                                              _sendButtonPressed = true;
                                            });
                                          },
                                          label: Text(
                                            "send",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ));
                                    } else {
                                      return SizedBox(
                                        width: 0,
                                      );
                                    }
                                  }),
                                )
                              ],
                            ),
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
            ),
          );
        },
      ),
    );
  }
}
