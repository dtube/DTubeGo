import 'package:dtube_togo/bloc/user/user_bloc_full.dart';

import 'package:dtube_togo/utils/randomPermlink.dart';

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

class ReplyButton extends StatefulWidget {
  final String title;
  final String author;
  final String link;
  final double votingWeight;
  final double scale;

  //final Comment comment;

  const ReplyButton({
    Key? key,
    required this.title,
    required this.author,
    required this.link,
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

  late int _currentVp;

  late int _voteVT = 0;

  @override
  void initState() {
    super.initState();
    _replyController = new TextEditingController();

    _userBloc = BlocProvider.of<UserBloc>(context);

    //_userBloc.add(FetchDTCVPEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
        create: (context) =>
            TransactionBloc(repository: TransactionRepositoryImpl()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Transform.scale(
              scale: widget.scale,
              child: InputChip(
                label: Text(
                  widget.title,
                  // style: Theme.of(context).textTheme.button,
                ),
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
                              // BlocProvider.of<TransactionBloc>(context)
                              //     .add(SignAndSendTransactionEvent(newTx));
                            },
                            label: Text(
                                "send")); // TODO: only show send button when text is entered: https://flutter-examples.com/flutter-show-hide-button-on-text-field-input/
                      }),
                ],
              ),
            ),
            SizedBox(height: 16)
          ],
        ));
  }
}
