import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/ContribOverview.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/FundingDialog.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/StateChart.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/StateChip.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/VoteOverview.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/DAO/DAO/Widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/players/VideoPlayerFromURL.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:dtube_go/utils/Strings/shortBalanceStrings.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_go/ui/widgets/AccountAvatar.dart';
import 'package:dtube_go/ui/pages/post/widgets/CollapsedDescription.dart';
import 'package:dtube_go/ui/pages/post/widgets/Comments.dart';
import 'package:dtube_go/ui/pages/post/widgets/ReplyButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ProposalDetailPageMobile extends StatefulWidget {
  final int proposalId;
  final int daoThreshold;

  ProposalDetailPageMobile(
      {required this.daoThreshold, required this.proposalId});

  @override
  _ProposalDetailPageMobileState createState() =>
      _ProposalDetailPageMobileState();
}

class _ProposalDetailPageMobileState extends State<ProposalDetailPageMobile> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
        bloc: BlocProvider.of<TransactionBloc>(context),
        listener: (context, state) {
          if (state is TransactionSent) {
            BlocProvider.of<DaoBloc>(context)
                .add(FetchProsposalEvent(id: widget.proposalId));
          }
        },
        child: Scaffold(
            // resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            // backgroundColor: Colors.transparent,
            appBar: kIsWeb
                ? null
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: 10.h,
                  ),
            body: BlocBuilder<DaoBloc, DaoState>(builder: (context, state) {
              if (state is ProposalLoadedState) {
                DAOItem _daoItem = state.daoItem;
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MobileDaoDetails(
                      daoItem: _daoItem,
                      daoThreshold: widget.daoThreshold,
                    ));
              }
              return Center(
                child: DtubeLogoPulseWithSubtitle(
                  subtitle: "loading proposal..",
                  size: 30.w,
                ),
              );
            })));
  }
}

class MobileDaoDetails extends StatefulWidget {
  final DAOItem daoItem;
  final int daoThreshold;

  MobileDaoDetails({
    Key? key,
    required this.daoItem,
    required this.daoThreshold,
  }) : super(key: key);

  @override
  _MobileDaoDetailsState createState() => _MobileDaoDetailsState();
}

class _MobileDaoDetailsState extends State<MobileDaoDetails> {
  late int _daoThreshold;
  late String postUrlLink;
  late String postUrlAuthor;

  @override
  void initState() {
    super.initState();
    if (widget.daoItem.threshold == null) {
      _daoThreshold = widget.daoThreshold;
    } else {
      _daoThreshold = widget.daoItem.threshold!;
    }
    if (widget.daoItem.url != null && widget.daoItem.url!.contains('/v/')) {
      List<String> urlParts = widget.daoItem.url!.split('/');

      postUrlLink = urlParts.last;
      postUrlAuthor = urlParts[urlParts.length - 2];
    } else {
      postUrlAuthor = "";
      postUrlLink = "";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProposalStateChip(
                daoItem: widget.daoItem,
                daoThreshold: _daoThreshold,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Text(
              widget.daoItem.title!,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          widget.daoItem.url != ""
              ? BlocProvider<PostBloc>(
                  create: (BuildContext context) =>
                      PostBloc(repository: PostRepositoryImpl())
                        ..add(FetchPostEvent(
                            postUrlAuthor, postUrlLink, "DAODetailsPage.dart")),
                  child: VideoPlayerFromURL(url: widget.daoItem.url!))
              : Text("no video url detected"),
          Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("created: " +
                          TimeAgo.timeInAgoTSShort(widget.daoItem.ts!)),
                      widget.daoItem.type == 1
                          ? Row(
                              children: [
                                Text(([1, 4, 7].contains(widget.daoItem.status!)
                                        ? "asked for: "
                                        : "asks for: ") +
                                    (widget.daoItem.requested! > 99900
                                        ? (widget.daoItem.requested! / 100000)
                                                .toStringAsFixed(2) +
                                            'K'
                                        : (widget.daoItem.requested! / 100)
                                            .round()
                                            .toString())),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: DTubeLogo(size: 4.w),
                                )
                              ],
                            )
                          : SizedBox(
                              width: 0,
                            ),
                      widget.daoItem.type == 1 && widget.daoItem.status! > 1
                          ? Row(
                              children: [
                                Text(([5, 7].contains(widget.daoItem.status!)
                                        ? "released: "
                                        : "received: ") +
                                    (widget.daoItem.raised! > 99900
                                        ? (widget.daoItem.raised! / 100000)
                                                .toStringAsFixed(2) +
                                            'K'
                                        : (widget.daoItem.raised! / 100)
                                            .round()
                                            .toString())),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: DTubeLogo(size: 4.w),
                                )
                              ],
                            )
                          : SizedBox(width: 0),
                    ],
                  ),
                  widget.daoItem.receiver != null &&
                          widget.daoItem.creator! != widget.daoItem.receiver!
                      ? Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Created by: ",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                AccountNavigationChip(
                                    author: widget.daoItem.creator!,
                                    size: 40.w),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            widget.daoItem.type == 1
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Benficiary: ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      AccountNavigationChip(
                                          author: widget.daoItem.receiver!,
                                          size: 40.w),
                                    ],
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AccountNavigationChip(
                                size: 40.w, author: widget.daoItem.creator!),
                          ],
                        ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            // child: Text(widget.daoItem.description!),
            child: CollapsedDescription(
              description: widget.daoItem.description!,
              startCollapsed: false,
              showOpenLink: true,
              postAuthor: postUrlAuthor,
              postLink: postUrlLink,
            ),
          ),
          (widget.daoItem.type == 1 && // if porposal is fund request
                      [0, 2].contains(widget.daoItem
                          .status!)) // and status is open voting / open funding
                  ||
                  (widget.daoItem.type == 2 &&
                      widget.daoItem.status ==
                          0) // or proposal is chain update and open voting
              ? widget.daoItem.status == 0 &&
                      widget.daoItem.voters!
                          .contains(globals.applicationUsername)
                  ? Text("You have already voted for it!")
                  : InputChip(
                      backgroundColor: globalRed,
                      avatar: FaIcon(
                        widget.daoItem.status == 0
                            ? FontAwesomeIcons.thumbsUp
                            : FontAwesomeIcons.arrowUpFromBracket,
                        size: globalIconSizeMedium,
                      ),
                      label: Text(
                          widget.daoItem.status == 0 &&
                                  widget.daoItem.type ==
                                      1 // if voting open and fund request
                              ? "vote for it"
                              : "help to fund it",
                          style: Theme.of(context).textTheme.headline3),
                      onSelected: ((bool) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => MultiBlocProvider(
                              providers: [
                                BlocProvider<UserBloc>(
                                    create: (context) => UserBloc(
                                        repository: UserRepositoryImpl())),
                              ],
                              child: widget.daoItem.status == 0 &&
                                      !widget.daoItem.voters!
                                          .contains(globals.applicationUsername)
                                  ? VotingDialog(
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      daoItem: widget.daoItem,
                                      //currentVT: state.vtBalance['v']! + 0.0,
                                    )
                                  : FundingDialog(
                                      txBloc: BlocProvider.of<TransactionBloc>(
                                          context),
                                      daoItem: widget.daoItem,
                                      //currentVT: state.vtBalance['v']! + 0.0,
                                    )),
                        );
                        //     } else {}
                        // }
                      }),
                    )
              : SizedBox(
                  height: 0,
                ),
          ProposalStateChart(
              daoItem: widget.daoItem,
              votingThreshold: _daoThreshold,
              centerRadius: 0,
              height: 30.h,
              outerRadius: 100.0,
              startFromDegree: 270,
              width: 100.w,
              showLabels: true,
              raisedLabel: [0, 1].contains(widget.daoItem.status!)
                  ? 'approved\n' +
                      (widget.daoItem.approvals! / 100 / 1000)
                          .toStringAsFixed(2)
                          .toString() +
                      'k'
                  : widget.daoItem.status == 2
                      ? 'raised\n' +
                          (widget.daoItem.raised! / 100)
                              .toStringAsFixed(2)
                              .toString() +
                          'k'
                      : '',
              onTap: () {
                if ([0, 1].contains(widget.daoItem.status!)) {
                  if (widget.daoItem.votes != null &&
                      widget.daoItem.votes!.isNotEmpty) {
                    showDialog<String>(
                        context: context,
                        builder: (context) {
                          return ProposalVoteOverview(
                            daoItem: widget.daoItem,
                            //currentVT: state.vtBalance['v']! + 0.0,
                          );
                        });
                  }
                } else {
                  if (widget.daoItem.contrib != null &&
                      widget.daoItem.contrib!.isNotEmpty) {
                    showDialog<String>(
                        context: context,
                        builder: (context) {
                          return ProposalContribOverview(
                            daoItem: widget.daoItem,
                            //currentVT: state.vtBalance['v']! + 0.0,
                          );
                        });
                  }
                }
              }),
          SizedBox(height: 10.h)
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

class VotesOverview extends StatefulWidget {
  VotesOverview({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;

  @override
  _VotesOverviewState createState() => _VotesOverviewState();
}

class _VotesOverviewState extends State<VotesOverview> {
  List<Votes> _allVotes = [];

  @override
  void initState() {
    super.initState();
    _allVotes = widget.post.upvotes!;
    if (widget.post.downvotes != null) {
      _allVotes = _allVotes + widget.post.downvotes!;
    }
    // sorting the list would be perhaps useful
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor: globalAlmostBlack,
      content: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: 45.h,
              width: 90.w,
              child: ListView.builder(
                itemCount: _allVotes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 10.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              navigateToUserDetailPage(
                                  context, _allVotes[index].u, () {});
                            },
                            child: Row(
                              children: [
                                Container(
                                    height: 10.w,
                                    width: 10.w,
                                    child: AccountIconBase(
                                      avatarSize: 10.w,
                                      showVerified: true,
                                      username: _allVotes[index].u,
                                    )),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 30.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _allVotes[index].u,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Text(
                                        TimeAgo.timeInAgoTSShort(
                                            _allVotes[index].ts),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FaIcon(_allVotes[index].vt > 0
                              ? FontAwesomeIcons.heart
                              : FontAwesomeIcons.flag),
                          Container(
                            width: 20.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          (_allVotes[index].claimable != null
                                              ? shortDTC(_allVotes[index]
                                                  .claimable!
                                                  .floor())
                                              : "0"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Container(
                                          width: 5.w,
                                          child: Center(
                                            child: DTubeLogoShadowed(size: 5.w),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          shortVP(_allVotes[index].vt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Container(
                                          width: 5.w,
                                          child: Center(
                                            child: ShadowedIcon(
                                              icon: FontAwesomeIcons.bolt,
                                              shadowColor: Colors.black,
                                              color: globalAlmostWhite,
                                              size: 5.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
            // ),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        InputChip(
          backgroundColor: globalRed,
          onPressed: () async {
            Navigator.of(context).pop();
          },
          label: Text(
            'Close',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}
