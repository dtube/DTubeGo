import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';

import 'package:dtube_togo/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_togo/ui/pages/feeds/cards/PostListCardNarrow.dart';

import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/utils/friendlyTimestamp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

typedef Bool2VoidFunc = void Function(bool);

class StaggeredFeed extends StatelessWidget {
  StaggeredFeed({
    Key? key,
  }) : super(key: key);

  late FeedBloc postBloc;
  final ScrollController _scrollController = ScrollController();
  List<FeedItem> _feedItems = [];

  String? _nsfwMode;
  String? _hiddenMode;
  String? _applicationUser;

  Future<bool> getDisplayModes() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
    _applicationUser = await sec.getUsername();
    if (_nsfwMode == null) {
      _nsfwMode = 'Blur';
    }
    if (_hiddenMode == null) {
      _hiddenMode = 'Hide';
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding: EdgeInsets.only(top: (paddingTop)),
      padding: EdgeInsets.only(top: (0.0)),
      child: FutureBuilder<bool>(
          future: getDisplayModes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return buildLoading(context);
            } else {
              return Container(
                // height: MediaQuery.of(context).size.height - 250,
                height: MediaQuery.of(context).size.height,
                // color: globalAlmostBlack,

                child: BlocBuilder<FeedBloc, FeedState>(
                  // listener: (context, state) {
                  //   if (state is FeedErrorState) {
                  //     BlocProvider.of<FeedBloc>(context).isFetching = false;
                  //   }
                  //   return;
                  // },
                  builder: (context, state) {
                    if (state is FeedInitialState ||
                        state is FeedLoadingState && _feedItems.isEmpty) {
                      return buildLoading(context);
                    } else if (state is FeedLoadedState) {
                      _feedItems.addAll(state.feed);
                      BlocProvider.of<FeedBloc>(context).isFetching = false;
                    } else if (state is FeedErrorState) {
                      return buildErrorUi(state.message);
                    }
                    return buildPostList(_feedItems, context);
                  },
                ),
              );
            }
          }),
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(child: DTubeLogoPulse(size: 30.w));
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildPostList(List<FeedItem> feed, BuildContext context) {
    return StaggeredGridView.countBuilder(
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !BlocProvider.of<FeedBloc>(context).isFetching) {
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(
                  feedType: "HotFeed",
                  fromAuthor: feed[feed.length - 1].author,
                  fromLink: feed[feed.length - 1].link));
          }
          if (_scrollController.offset <=
                  _scrollController.position.minScrollExtent &&
              !BlocProvider.of<FeedBloc>(context).isFetching) {
            _feedItems.clear();
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchFeedEvent(
                feedType: "HotFeed",
              ));
          }
        }),
      padding: EdgeInsets.only(top: 19.h),
      crossAxisCount: 4,
      itemCount: feed.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          navigateToPostDetailPage(
              context, feed[index].author, feed[index].link, "none", false);
        },
        child: new CachedNetworkImage(
          imageUrl: feed[index].thumbUrl,
        ),
      ),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
