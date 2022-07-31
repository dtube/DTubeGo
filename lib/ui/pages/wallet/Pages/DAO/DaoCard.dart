import 'dart:io';

import 'package:dtube_go/bloc/dao/dao_bloc_full.dart';
import 'package:dtube_go/bloc/postdetails/postdetails_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/ui/pages/feeds/cards/widets/CollapsedDescription.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/DAO/Widgets/DaoStateChart.dart';
import 'package:dtube_go/ui/pages/wallet/Pages/DAO/Widgets/DaoStateChip.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/players/VideoPlayerFromURL.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DaoCard extends StatefulWidget {
  DaoCard({Key? key, required this.daoItem, required this.daoThreshold})
      : super(key: key);

  late DAOItem daoItem;
  late int daoThreshold;
  late String postUrlAuthor;
  late String postUrlLink;

  @override
  _DaoCardState createState() => _DaoCardState();
}

class _DaoCardState extends State<DaoCard> with AutomaticKeepAliveClientMixin {
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
    return DTubeFormCard(
        avoidAnimation: globals.disableAnimations,
        waitBeforeFadeIn: Duration(seconds: 0),
        childs: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DaoStateChip(
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
              DaoStateChart(
                daoItem: widget.daoItem,
                votingThreshold: _daoThreshold,
              ),
            ],
          ),
          widget.postUrlLink != ""
              ? BlocProvider<PostBloc>(
                  create: (BuildContext context) =>
                      PostBloc(repository: PostRepositoryImpl())
                        ..add(FetchPostEvent(
                            widget.postUrlAuthor, widget.postUrlLink)),
                  child: VideoPlayerFromURL(url: widget.daoItem.url!))
              : Text("no video url detected")
        ]);
  }
}
