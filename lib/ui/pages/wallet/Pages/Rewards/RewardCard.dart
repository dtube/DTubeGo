import 'package:dtube_go/bloc/rewards/rewards_bloc_full.dart';
import 'package:dtube_go/ui/pages/post/postDetailPage.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RewardsCard extends StatefulWidget {
  RewardsCard({Key? key, required this.reward, required this.parentWidget})
      : super(key: key);

  final Reward reward;
  final Widget parentWidget;

  @override
  _RewardsCardState createState() => _RewardsCardState();
}

class _RewardsCardState extends State<RewardsCard>
    with AutomaticKeepAliveClientMixin {
  double widthLabel = 25.w;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToPostDetailPage(
            context, widget.reward.author, widget.reward.link);
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AccountIconBase(
                      username: widget.reward.author,
                      avatarSize: 20.w,
                      showVerified: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: AccountNameBase(
                        username: widget.reward.author,
                        width: 40.w,
                        height: 10.h,
                        mainStyle: Theme.of(context).textTheme.headline4!,
                        subStyle: Theme.of(context).textTheme.bodyText1!,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "content:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Container(
                        width: 30.w,
                        child: Text(
                          widget.reward.author + '/' + widget.reward.link,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "spent:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Text(
                      (widget.reward.vt / 1000).toStringAsFixed(2) + 'K',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "voted on:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(widget.reward.ts)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: widthLabel,
                        child: Text(
                          "published on:",
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              widget.reward.contentTs)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 22.w,
              //height: 10.h,
              child: widget.reward.claimed != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (widget.reward.claimable / 100)
                                  .toStringAsFixed(2),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: DTubeLogoShadowed(size: 5.w),
                            ),
                          ],
                        ),
                        Text(
                          "claimed",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          TimeAgo.timeInAgoTS(widget.reward.claimed!),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    )
                  : timestampGreater7Days(widget.reward.ts)
                      ? BlocProvider(
                          // gets its own tranactionbloc to avoid spamming snackbars
                          create: (context) => TransactionBloc(
                              repository: TransactionRepositoryImpl()),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: ClaimRewardButton(
                              author: widget.reward.author,
                              claimable: widget.reward.claimable,
                              link: widget.reward.link,
                              topLevelWidget: widget.parentWidget,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (widget.reward.claimable / 100)
                                      .toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 1.w),
                                  child: DTubeLogoShadowed(size: 5.w),
                                ),
                              ],
                            ),
                            Text(
                              'claimable ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              TimeAgo.timeAgoClaimIn(widget.reward.ts),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      )),
    );
  }

  void navigateToPostDetailPage(
      BuildContext context, String author, String link) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: author,
        link: link,
        recentlyUploaded: false,
        directFocus: "none",
      );
    }));
  }
}

class ClaimRewardButton extends StatefulWidget {
  ClaimRewardButton(
      {Key? key,
      required this.author,
      required this.link,
      required this.claimable,
      required this.topLevelWidget})
      : super(key: key);

  final String author;
  final String link;
  final double claimable;
  final Widget topLevelWidget;

  @override
  _ClaimRewardButtonState createState() => _ClaimRewardButtonState();
}

class _ClaimRewardButtonState extends State<ClaimRewardButton> {
  late TransactionBloc _txBloc;

  @override
  void initState() {
    super.initState();
    _txBloc = BlocProvider.of<TransactionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
      if (state is TransactionSent) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'claimed',
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (widget.claimable / 100).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 1.w),
                  child: DTubeLogoShadowed(size: 5.w),
                ),
              ],
            ),
          ],
        );
      } else {
        if (state is TransactionSinging || state is TransactionSigned) {
          return ColorChangeCircularProgressIndicator();
        } else {
          return ElevatedButton(
            onPressed: !globals.keyPermissions.contains(17)
                ? null
                : () {
                    TxData txdata = TxData(
                      author: widget.author,
                      link: widget.link,
                    );
                    Transaction newTx = Transaction(type: 17, data: txdata);
                    _txBloc.add(SignAndSendTransactionEvent(tx: newTx));
                  },
            child: Padding(
              padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'claim',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (widget.claimable / 100).toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1.w),
                        child: DTubeLogoShadowed(size: 5.w),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }
    });
  }
}
