import 'package:another_flushbar/flushbar.dart';
import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_response_model.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/OverlayInputs.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotingDialog extends StatefulWidget {
  VotingDialog({
    Key? key,
    required this.txBloc,
    required this.daoItem,
    this.vertical,
    this.verticalModeCallbackVotingButtonsPressed,
    this.okCallback,
    this.cancelCallback,
  }) : super(key: key);
  final TransactionBloc txBloc;

  final DAOItem daoItem;

  final bool? vertical; // only used in moments for now
  final VoidCallback? verticalModeCallbackVotingButtonsPressed;

  final VoidCallback? okCallback;
  final VoidCallback? cancelCallback;

  @override
  _VotingDialogState createState() => _VotingDialogState();
}

class _VotingDialogState extends State<VotingDialog> {
  late double _voteValue = 1;

  late TransactionBloc _txBloc;
  late TextEditingController _tagController;

  late PostBloc _postBloc;
  late UserBloc _userBloc;
  late double _currentVT;
  bool _sendButtonPressed = false;
  bool downvote = false;

  @override
  void initState() {
    super.initState();
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchDTCVPEvent());
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
          FontAwesomeIcons.checkToSlot,
          size: 10.w,
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
                child: !_sendButtonPressed
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Voting",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "The amount of DTube coins you use to vote here will get locked for as long as the voting period is going. " +
                                  "You still can vote for other proposals with the same DTube coins but you will not be able to transfer it or burn it.\n\n" +
                                  "When the voting period ends (failed or approved) your coins will get unlocked again and you can use them as usual.",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                child: Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                      color: !downvote ? globalRed : globalBlue,
                                      border: Border.all(
                                        color:
                                            !downvote ? globalRed : globalBlue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.thumbsUp,
                                      size: globalIconSizeBig,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    downvote = false;
                                  });
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                      color: downvote ? globalRed : globalBlue,
                                      border: Border.all(
                                        color:
                                            downvote ? globalRed : globalBlue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.thumbsDown,
                                      size: globalIconSizeBig,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    downvote = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Slider(
                                        min: 1,
                                        max: 100.0,
                                        value: _voteValue,

                                        label: _voteValue.floor().toString() +
                                            "DTC",
                                        //divisions: 40,
                                        inactiveColor: globalBlue,
                                        activeColor: globalRed,
                                        onChanged: (dynamic value) {
                                          setState(() {
                                            _voteValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                        shortDTC((state.dtcBalance /
                                                    100 *
                                                    _voteValue)
                                                .floor()) +
                                            " DTube",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: globalRed,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: Text(
                                "Send Vote",
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () async {
                              int _txType = 35;
                              DAOTxData txdata = DAOTxData(
                                  id: widget.daoItem.iId,
                                  amount:
                                      ((state.dtcBalance / 100 * _voteValue) *
                                              (downvote ? -1 : 1))
                                          .floor());

                              DAOTransaction newTx =
                                  DAOTransaction(type: _txType, data: txdata);

                              _txBloc.add(
                                  SignAndSendDAOTransactionEvent(tx: newTx));
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
              );
            } else {
              return DtubeLogoPulseWithSubtitle(
                  subtitle: "loading your balance...", size: 30.w);
            }
          },
        ),
      ),
    );
  }
}
