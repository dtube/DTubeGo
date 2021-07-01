import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';

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
      required this.currentVT,
      required this.scale,
      required this.isPost})
      : super(key: key);

  final String author;
  final String link;
  final List<Votes>? upvotes;
  final List<Votes>? downvotes;
  final bool alreadyVoted;
  final bool alreadyVotedDirection;

  final double defaultVotingWeight;
  final double defaultVotingTip;
  final int currentVT;
  final double scale;
  final bool isPost;
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

    // _userBloc = BlocProvider.of<UserBloc>(context);
    // _userBloc.add(FetchDTCVPEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Visibility(
        visible: !_upvotePressed && !_downvotePressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: widget.scale,
              child: InputChip(
                label: Text(
                  widget.upvotes != null && widget.upvotes!.isNotEmpty
                      ? (widget.upvotes!.length).toString()
                      : '0',
                ),
                avatar: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: FaIcon(
                    FontAwesomeIcons.thumbsUp,
                    color: widget.alreadyVoted && widget.alreadyVotedDirection
                        ? globalRed
                        : Colors.grey,
                  ),
                ),
                onPressed: () {
                  if (!widget.alreadyVoted) {
                    setState(() {
                      _upvotePressed = !_upvotePressed;
                      if (_upvotePressed) {
                        _downvotePressed = false;
                      }
                    });
                  }
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Transform.scale(
              scale: widget.scale,
              child: InputChip(
                label: Text(
                    widget.downvotes != null && widget.downvotes!.isNotEmpty
                        ? (widget.downvotes!.length).toString()
                        : '0'),
                avatar: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: FaIcon(FontAwesomeIcons.thumbsDown,
                      color:
                          widget.alreadyVoted && !widget.alreadyVotedDirection
                              ? globalRed
                              : Colors.grey),
                ),
                onPressed: () {
                  if (!widget.alreadyVoted) {
                    setState(() {
                      _downvotePressed = !_downvotePressed;
                      if (_downvotePressed) {
                        _upvotePressed = false;
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Visibility(
          visible: _upvotePressed || _downvotePressed,
          child: BlocProvider<TransactionBloc>(
              create: (context) =>
                  TransactionBloc(repository: TransactionRepositoryImpl()),
              child: VotingSlider(
                defaultVote: _downvotePressed
                    ? widget.defaultVotingWeight * -1
                    : widget.defaultVotingWeight,
                defaultTip: widget.defaultVotingTip,
                author: widget.author,
                link: widget.link,
                downvote: _downvotePressed,
                currentVT: _currentVT.toDouble(),
                isPost: widget.isPost,
              )))
    ]);
  }
}

class VotingSlider extends StatefulWidget {
  VotingSlider({
    Key? key,
    required this.author,
    required this.link,
    required this.downvote,
    required this.defaultVote,
    required this.defaultTip,
    required this.currentVT,
    required this.isPost,
  }) : super(key: key);

  String author;
  String link;
  double defaultVote;
  double defaultTip;
  double currentVT;
  bool isPost;

  bool downvote;

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

  @override
  void initState() {
    super.initState();
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _tagController = TextEditingController();
    //_userBloc.add(FetchDTCVPEvent());
    _vpValue = widget.defaultVote;
    _tipValue = widget.defaultTip;
  }

  @override
  Widget build(BuildContext context) {
    //int _currentVp = 0;

    return BlocBuilder<TransactionBloc, TransactionState>(
        //bloc: _txBloc,
        builder: (context, state) {
      if (state is TransactionSent) {
        _postBloc.add(FetchPostEvent(widget.author, widget.link));
      }
      return Container(
          //width: 200,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "voting weight: ",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      _vpValue.floor().toString() + '%',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
              Slider(
                min: widget.downvote ? -100.0 : 1,
                max: widget.downvote ? -1 : 100.0,
                value: _vpValue,

                label: _vpValue.floor().toString() + "%",
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
                      width: 100,
                      child: Column(
                        children: [
                          Text(
                            "vote tip: ",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            _tipValue.floor().toString() + '%',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                    Slider(
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
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isPost
                  ? Container(
                      width: 200,
                      child: TextFormField(
                        controller: _tagController,
                        decoration:
                            new InputDecoration(labelText: "curator tag"),
                      ),
                    )
                  : SizedBox(width: 0),
              SizedBox(width: 8),
              BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state is UserDTCVPLoadedState) {
                  _currentVT = state.vtBalance["v"]!.toDouble();
                  return ElevatedButton(
                      onPressed: () {
                        var voteValue = (_currentVT * (_vpValue / 100)).floor();
                        int _txType = 5;
                        TxData txdata = TxData(
                          author: widget.author,
                          link: widget.link,
                          tag: _tagController.value.text,
                          vt: voteValue,
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
                        _txBloc.add(SignAndSendTransactionEvent(newTx));
                      },
                      child: Text("send"));
                } else {
                  return SizedBox(
                    width: 0,
                  );
                }
              }),
            ],
          ),
        ],
      )
          //   ],
          // ),
          );
    });
  }
}
