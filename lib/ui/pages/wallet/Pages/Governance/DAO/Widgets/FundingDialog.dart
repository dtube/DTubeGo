import 'package:another_flushbar/flushbar.dart';
import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/dao/dao_response_model.dart';
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

class FundingDialog extends StatefulWidget {
  FundingDialog({
    Key? key,
    required this.txBloc,
    required this.daoItem,
    this.vertical,
    this.verticalModeCallbackVotingButtonsPressed,
    this.okCallback,
    this.cancelCallback,
  }) : super(key: key);
  TransactionBloc txBloc;

  DAOItem daoItem;

  bool? vertical; // only used in moments for now
  VoidCallback? verticalModeCallbackVotingButtonsPressed;

  VoidCallback? okCallback;
  VoidCallback? cancelCallback;

  @override
  _FundingDialogState createState() => _FundingDialogState();
}

class _FundingDialogState extends State<FundingDialog> {
  late double _fundValue = 1;

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
                                  "Funding",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "The amount of DTube coins you use to fund will get locked and potentially sent to the beneficiary / creator of this fund request!\n\n" +
                                    "Only when the funding goal is not getting reached or the proposal does not get executed you will receive those funds back.\n\n" +
                                    "So only use funds you are willing to donate for supporting this proposal!",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 1.h, bottom: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Slider(
                                              min: 1,
                                              max: 100.0,
                                              value: _fundValue,

                                              label: _fundValue
                                                      .floor()
                                                      .toString() +
                                                  "DTC",
                                              //divisions: 40,
                                              inactiveColor: globalBlue,
                                              activeColor: globalRed,
                                              onChanged: (dynamic value) {
                                                setState(() {
                                                  _fundValue = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                              shortDTC((state.dtcBalance /
                                                          100 *
                                                          _fundValue)
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
                              ],
                            ),
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
                                  // widget.downvote ? "Flag now!" : "Send Vote",
                                  "Send Funds",
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onTap: () async {
                                int _txType = 32;
                                DAOTxData txdata = DAOTxData(
                                    id: widget.daoItem.iId,
                                    amount:
                                        ((state.dtcBalance / 100 * _fundValue) >
                                                    (widget.daoItem.requested! -
                                                        widget.daoItem.raised!)
                                                ? (widget.daoItem.requested! -
                                                    widget.daoItem.raised!)
                                                : (state.dtcBalance /
                                                    100 *
                                                    _fundValue))
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
                          ])
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
