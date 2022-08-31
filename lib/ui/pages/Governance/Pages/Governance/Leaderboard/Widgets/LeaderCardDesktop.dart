import 'package:another_flushbar/flushbar.dart';
import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/leaderboard/leaderboard_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';

import 'package:dtube_go/ui/widgets/AccountAvatar.dart';

import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/players/VideoPlayerFromURL.dart';
import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';

import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/ui/widgets/system/customSnackbar.dart';

class LeaderCardDesktop extends StatefulWidget {
  LeaderCardDesktop({
    Key? key,
    required this.leaderItem,
  }) : super(key: key);

  late Leader leaderItem;

  @override
  _LeaderCardDesktopState createState() => _LeaderCardDesktopState();
}

class _LeaderCardDesktopState extends State<LeaderCardDesktop>
    with AutomaticKeepAliveClientMixin {
  double widthLabel = 100;
  @override
  bool get wantKeepAlive => true;
  late int _daoThreshold;
  late String phase; // voting, funding, execution
  late String status; // open,failed, closed

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DTubeFormCard(
        avoidAnimation: globals.disableAnimations,
        waitBeforeFadeIn: Duration(seconds: 0),
        childs: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Center(
                            child: AccountIconBase(
                          avatarSize: 50,
                          showVerified: true,
                          username: widget.leaderItem.name!,
                        )),
                      ),
                      Container(
                        width: 100,
                        child: Text(
                          widget.leaderItem.name!,
                          style: Theme.of(context).textTheme.headline5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 150,
                    child: widget.leaderItem.jsonString != null &&
                            widget.leaderItem.jsonString!.profile != null &&
                            widget.leaderItem.jsonString!.profile!.website !=
                                null
                        ? OpenableHyperlink(
                            maxLines: 1,
                            url:
                                widget.leaderItem.jsonString!.profile!.website!,
                            alt: widget.leaderItem.jsonString!.profile!.website!
                                        .length >
                                    32
                                ? widget.leaderItem.jsonString!.profile!
                                        .website!
                                        .substring(0, 29) +
                                    '...'
                                : widget
                                    .leaderItem.jsonString!.profile!.website!,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.blue[300]),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "approved with:",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Row(
                    children: [
                      Text(
                        (widget.leaderItem.nodeAppr! / 100000)
                                .toStringAsFixed(2) +
                            'K',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: DTubeLogoShadowed(size: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  BlocProvider(
                    // gets its own tranactionbloc to avoid spamming snackbars
                    create: (context) => TransactionBloc(
                        repository: TransactionRepositoryImpl()),
                    child: VoteButton(
                      leader: widget.leaderItem.name!,
                    ),
                  ),
                ],
              )
            ],
          ),
        ]);
  }
}

class VoteButton extends StatefulWidget {
  VoteButton({
    Key? key,
    required this.leader,
  }) : super(key: key);

  final String leader;

  @override
  State<VoteButton> createState() => _VoteButtonState();
}

class _VoteButtonState extends State<VoteButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
      if (state is TransactionError) {
        showCustomFlushbarOnError(state.message, context);
      }
      if (state is TransactionSent) {
        BlocProvider.of<UserBloc>(context).add(FetchMyAccountDataEvent());
      }
    }, child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
      if (state is TransactionSinging) {
        return ColorChangeCircularProgressIndicator();
      }

      return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
        if (userState is UserLoadingState) {
          return ColorChangeCircularProgressIndicator();
        }
        if (userState is UserLoadedState) {
          return InputChip(
            label: Text(userState.user.approves != null &&
                    userState.user.approves!.contains(widget.leader)
                ? "cancel"
                : "vote"),
            backgroundColor: userState.user.approves != null &&
                    userState.user.approves!.contains(widget.leader)
                ? globalRed
                : userState.user.approves == null ||
                        userState.user.approves!.length < 5
                    ? globalRed
                    : Colors.grey[700],
            onSelected: (value) async {
              TxData txdata = TxData(
                target: widget.leader,
              );
              Transaction newTx = Transaction(
                  type: userState.user.approves != null &&
                          userState.user.approves!.contains(widget.leader)
                      ? 2
                      : 1,
                  data: txdata);
              BlocProvider.of<TransactionBloc>(context)
                  .add(SignAndSendTransactionEvent(tx: newTx));
            },
          );
        }

        return ColorChangeCircularProgressIndicator();
      });
    }));
  }
}
