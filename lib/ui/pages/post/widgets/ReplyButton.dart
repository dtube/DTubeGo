import 'package:dtube_togo/bloc/postdetails/postdetails_bloc.dart';
import 'package:dtube_togo/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/utils/randomPermlink.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
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

  //final Comment comment;

  const ReplyButton({
    Key? key,
    required this.icon,
    required this.author,
    required this.link,
    required this.parentAuthor,
    required this.parentLink,
    required this.votingWeight,
    required this.scale,
  }) : super(key: key);

  @override
  _ReplyButtonState createState() => _ReplyButtonState();
}

class _ReplyButtonState extends State<ReplyButton> {
  //static final _formKey = new GlobalKey<FormState>();
  TextEditingController _replyController = new TextEditingController();
  bool _replyPressed = false;

  late UserBloc _userBloc;
  late PostBloc _postBloc;

  late int _currentVp;

  late int _voteVT = 0;

  @override
  void initState() {
    super.initState();
    _replyController = new TextEditingController();

    _userBloc = BlocProvider.of<UserBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);

    //_userBloc.add(FetchDTCVPEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        //bloc: _txBloc,
        builder: (context, state) {
      if (state is TransactionSent) {
        print(widget.author + '/' + widget.link);
        _postBloc.add(FetchPostEvent(widget.parentAuthor, widget.parentLink));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.scale(
            scale: widget.scale,
            child: InputChip(
              label: widget.icon,
              onPressed: () {
                setState(() {
                  _replyPressed = !_replyPressed;
                });
              },
            ),
          ),
          Visibility(
            visible: _replyPressed,
            child:
                //Expanded(
                //flex: 2,
                //child:
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300, // TODO: make this dynamic
                  child: TextField(
                    //key: UniqueKey(),
                    autofocus: _replyPressed,
                    controller: _replyController,
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
                        _voteVT = int.parse((_currentVp.toDouble() *
                                (widget.votingWeight / 100))
                            .floor()
                            .toString());
                      }

                      return InputChip(
                          onPressed: () {
                            Map<String, dynamic> jsonmeta = {};
                            String permlink = randomPermlink(11);
                            TxData txdata = TxData(
                              link: permlink,
                              jsonmetadata: {
                                "description": _replyController.value.text,
                                "title": ""
                              },
                              vt: _voteVT,
                              tag: "",
                              pa: widget.author,
                              pp: widget.link,
                            );
                            Transaction newTx =
                                Transaction(type: 4, data: txdata);
                            print(newTx.toJson().toString());
                            BlocProvider.of<TransactionBloc>(context)
                                .add(SignAndSendTransactionEvent(newTx));
                          },
                          label: Text(
                              "send")); // TODO: only show send button when text is entered: https://flutter-examples.com/flutter-show-hide-button-on-text-field-input/
                    }),
              ],
            ),
          ),
          SizedBox(height: 16)
        ],
      );
    });
  }
}
