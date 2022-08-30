import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/ContribOverview.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/StateChart.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/StateChip.dart';
import 'package:dtube_go/ui/pages/Governance/Pages/Governance/DAO/Widgets/VoteOverview.dart';

import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/widgets/players/VideoPlayerFromURL.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';

import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProposalCard extends StatefulWidget {
  ProposalCard({Key? key, required this.daoItem, required this.daoThreshold})
      : super(key: key);

  final DAOItem daoItem;
  final int daoThreshold;
  String postUrlAuthor = "";
  String postUrlLink = "";

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard>
    with AutomaticKeepAliveClientMixin {
  double widthLabel = 25.w;
  @override
  bool get wantKeepAlive => true;
  late int _daoThreshold;

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

      widget.postUrlLink = urlParts.last;
      widget.postUrlAuthor = urlParts[urlParts.length - 2];
    } else {
      widget.postUrlAuthor = "";
      widget.postUrlLink = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToDaoDetailPage(context, widget.daoItem, _daoThreshold);
      },
      child: DTubeFormCard(
          avoidAnimation: globals.disableAnimations,
          waitBeforeFadeIn: Duration(seconds: 0),
          childs: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60.w,
                  child: Text(
                    widget.daoItem.title!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                ProposalStateChart(
                    daoItem: widget.daoItem,
                    votingThreshold: _daoThreshold,
                    centerRadius: 0,
                    height: 10.h,
                    outerRadius: 30.0,
                    startFromDegree: 270,
                    width: 20.w,
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
              ],
            ),
            widget.postUrlLink != ""
                ? BlocProvider<PostBloc>(
                    create: (BuildContext context) =>
                        PostBloc(repository: PostRepositoryImpl())
                          ..add(FetchPostEvent(widget.postUrlAuthor,
                              widget.postUrlLink, "ProposalCard.dart")),
                    child: VideoPlayerFromURL(url: widget.daoItem.url!))
                : Text("no video url detected")
          ]),
    );
  }
}
