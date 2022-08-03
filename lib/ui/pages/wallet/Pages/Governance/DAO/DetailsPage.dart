import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/DAO/Widgets/ContribOverview.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/DAO/Widgets/StateChart.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/DAO/Widgets/StateChip.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/DAO/Widgets/VoteOverview.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/Governance/DAO/Widgets/VotingDialog.dart';
import 'package:dtube_go/ui/widgets/players/VideoPlayerFromURL.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';
import 'package:dtube_go/utils/shortBalanceStrings.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
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

class ProposalDetailPage extends StatefulWidget {
  DAOItem daoItem;
  int daoThreshold;

  String phase;
  String status;

  ProposalDetailPage(
      {required this.daoItem,
      required this.daoThreshold,
      required this.phase,
      required this.status});

  @override
  _ProposalDetailPageState createState() => _ProposalDetailPageState();
}

class _ProposalDetailPageState extends State<ProposalDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MobileDaoDetails(
          daoItem: widget.daoItem,
          daoThreshold: widget.daoThreshold,
          phase: widget.phase,
          status: widget.status,
        ),
      ),
    );
  }
}

class MobileDaoDetails extends StatefulWidget {
  final DAOItem daoItem;
  final int daoThreshold;
  String phase;
  String status;

  MobileDaoDetails(
      {Key? key,
      required this.daoItem,
      required this.daoThreshold,
      required this.phase,
      required this.status})
      : super(key: key);

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
                phase: widget.phase,
                status: widget.status,
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
                        ..add(FetchPostEvent(postUrlAuthor, postUrlLink)),
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
                      Row(
                        children: [
                          Text((widget.status == "failed"
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
                      ),
                      widget.phase == "funding" || widget.phase == "execution"
                          ? Row(
                              children: [
                                Text((widget.status == "failed"
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
                          : SizedBox(height: 0),
                    ],
                  ),
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
                                    author: widget.daoItem.creator!),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Benficiary: ",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                AccountNavigationChip(
                                    author: widget.daoItem.receiver!),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AccountNavigationChip(
                                author: widget.daoItem.creator!),
                          ],
                        ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            // child: Text(widget.daoItem.description!),
            child: CollapsedDescription(
              description: widget.daoItem.description!,
              startCollapsed: true,
              showOpenLink: true,
              postAuthor: postUrlAuthor,
              postLink: postUrlLink,
            ),
          ),
          widget.status == "open"
              ? InputChip(
                  backgroundColor: globalRed,
                  avatar: FaIcon(
                    widget.phase == "voting"
                        ? FontAwesomeIcons.thumbsUp
                        : FontAwesomeIcons.arrowUpFromBracket,
                    size: globalIconSizeBig,
                  ),
                  label: Text(
                      widget.phase == "voting" ? "vote for it" : "donate",
                      style: Theme.of(context).textTheme.headlineLarge),
                  onSelected: ((bool) {
                    if (widget.daoItem.voters == null ||
                        !widget.daoItem.voters!
                            .contains(globals.applicationUsername)) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<PostBloc>(
                                create: (context) =>
                                    PostBloc(repository: PostRepositoryImpl())),
                            BlocProvider<UserBloc>(
                                create: (context) =>
                                    UserBloc(repository: UserRepositoryImpl())),
                          ],
                          child: VotingDialog(
                            txBloc: BlocProvider.of<TransactionBloc>(context),
                            daoItem: widget.daoItem,
                            //currentVT: state.vtBalance['v']! + 0.0,
                          ),
                        ),
                      );
                    } else {}
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
              phase: widget.phase,
              status: widget.status,
              raisedLabel: widget.phase == "voting"
                  ? 'approved\n' +
                      (widget.daoItem.approvals! / 100 / 1000)
                          .toStringAsFixed(2)
                          .toString() +
                      'k'
                  : widget.phase == "funding"
                      ? 'raised\n' +
                          (widget.daoItem.raised! / 100)
                              .toStringAsFixed(2)
                              .toString() +
                          'k'
                      : '',
              onTap: () {
                if (widget.phase == "voting") {
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

class CommentContainer extends StatelessWidget {
  const CommentContainer({
    Key? key,
    required double defaultVoteWeightComments,
    required int currentVT,
    required double defaultVoteTipComments,
    required this.blockedUsers,
    required bool fixedDownvoteActivated,
    required double fixedDownvoteWeight,
    required this.post,
  })  : _defaultVoteWeightComments = defaultVoteWeightComments,
        _currentVT = currentVT,
        _defaultVoteTipComments = defaultVoteTipComments,
        _fixedDownvoteActivated = fixedDownvoteActivated,
        _fixedDownvoteWeight = fixedDownvoteWeight,
        super(key: key);

  final Post post;
  final double _defaultVoteWeightComments;
  final int _currentVT;
  final double _defaultVoteTipComments;
  final String blockedUsers;
  final bool _fixedDownvoteActivated;
  final double _fixedDownvoteWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      child: ListView.builder(
        itemCount: post.comments!.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            CommentDisplay(
                post.comments![index],
                _defaultVoteWeightComments,
                _currentVT,
                post.author,
                post.link,
                _defaultVoteTipComments,
                context,
                blockedUsers.split(","),
                _fixedDownvoteActivated,
                _fixedDownvoteWeight),
            SizedBox(height: index == post.comments!.length - 1 ? 200 : 0)
          ],
        ),
      ),
    );
  }
}

class ShareAndCommentChips extends StatelessWidget {
  const ShareAndCommentChips({
    Key? key,
    required this.author,
    required this.directFocus,
    required this.link,
    required double defaultVoteWeightComments,
  })  : _defaultVoteWeightComments = defaultVoteWeightComments,
        super(key: key);

  final String author;
  final String link;
  final double _defaultVoteWeightComments;
  final String directFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputChip(
              label: FaIcon(FontAwesomeIcons.shareAlt),
              onPressed: () {
                Share.share('https://d.tube/#!/v/' + author + '/' + link);
              },
            ),
            SizedBox(width: 8),
            ReplyButton(
              icon: FaIcon(FontAwesomeIcons.comment),
              author: author,
              link: link,
              parentAuthor: author,
              parentLink: link,
              votingWeight: _defaultVoteWeightComments,
              scale: 1,
              focusOnNewComment: directFocus == "newcomment",
              isMainPost: true,
            ),
          ],
        ),
      ],
    );
  }
}

class DtubeCoinsChip extends StatelessWidget {
  const DtubeCoinsChip({
    Key? key,
    required this.dist,
    required this.post,
  }) : super(key: key);

  final double dist;
  final Post post;
  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Row(
        children: [
          Text(
            (dist / 100).round().toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: DTubeLogoShadowed(size: 5.w),
          ),
        ],
      ),
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => VotesOverview(post: post),
        );
      },
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

class AccountNavigationChip extends StatelessWidget {
  const AccountNavigationChip({
    Key? key,
    required this.author,
  }) : super(key: key);

  final String author;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: AccountAvatarBase(
        username: author,
        avatarSize: 12.w,
        showVerified: true,
        showName: true,
        nameFontSizeMultiply: 0.8,
        width: 35.w,
        height: 5.h,
      ),
      onPressed: () {
        navigateToUserDetailPage(context, author, () {});
      },
    );
  }
}

class VotesOverview extends StatefulWidget {
  VotesOverview({
    Key? key,
    required this.post,
  }) : super(key: key);
  Post post;

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
                                  child: AccountAvatarBase(
                                    username: _allVotes[index].u,
                                    avatarSize: 10.w,
                                    showVerified: true,
                                    showName: false,
                                    width: 10.w,
                                    height: 5.h,
                                  ),
                                ),
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
