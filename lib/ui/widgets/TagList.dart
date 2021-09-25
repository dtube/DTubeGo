import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:async';

import 'package:dtube_go/bloc/search/search_bloc_full.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/style/dtubeLoading.dart';

import 'package:dtube_go/ui/pages/Explore/ResultCards/PostResultCard.dart';
import 'package:dtube_go/ui/pages/Explore/ResultCards/UserResultCard.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagList extends StatefulWidget {
  String tagName;
  @override
  TagListState createState() => TagListState();

  TagList({Key? key, required this.tagName}) : super(key: key);
}

class TagListState extends State<TagList> {
  late SearchBloc searchBloc;
  late List<FeedItem> hashtagResults;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchTagSearchResults(tag: widget.tagName));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "other current videos with the tag \"${widget.tagName}\"",
                  style: Theme.of(context).textTheme.headline5,
                ),
                BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
                  if (state is FeedInitialState || state is FeedLoadingState) {
                    return buildLoading();
                  } else if (state is FeedLoadedState) {
                    hashtagResults = state.feed;
                    BlocProvider.of<FeedBloc>(context).isFetching = false;
                    return buildResultsListForTagResults(hashtagResults);
                  } else if (state is FeedErrorState) {
                    return buildErrorUi(state.message);
                  } else {
                    return buildErrorUi('');
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      height: 400,
      child: Center(
        child: DTubeLogoPulse(
          size: 100,
        ),
      ),
    );
  }

  Widget buildBlank() {
    return Container(
      height: 400,
      child: SizedBox(height: 0),
    );
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

  Widget buildResultsListForTagResults(List<FeedItem> searchResults) {
    return Container(
      height: 800,
      alignment: Alignment.topLeft,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: searchResults.length,
          itemBuilder: (ctx, pos) {
            return PostResultCard(
              id: searchResults[pos].sId,
              author: searchResults[pos].author,
              dist: searchResults[pos].dist,
              link: searchResults[pos].link,
              tags: searchResults[pos].tags[0],
              title: searchResults[pos].jsonString!.title,
              ts: searchResults[pos].ts,
            );
          }),
    );
  }
}
