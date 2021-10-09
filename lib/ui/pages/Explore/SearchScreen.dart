import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/utils/friendlyTimestamp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:async';

import 'package:dtube_go/bloc/search/search_bloc_full.dart';

import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';

import 'package:dtube_go/ui/pages/Explore/ResultCards/PostResultCard.dart';
import 'package:dtube_go/ui/pages/Explore/ResultCards/UserResultCard.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();

  SearchScreen({
    Key? key,
  }) : super(key: key);
}

class SearchScreenState extends State<SearchScreen> {
  late SearchBloc searchBloc;
  late TextEditingController searchTextController;
  String _searchEntity = "Users";
  final _debouncer = Debounce(milliseconds: 700);
  String currentSearch = "";
  List<String> _searchEntities = ["Users", "Posts", "Tags"];
  List<IconData> _searchEntityIcons = [
    FontAwesomeIcons.user,
    FontAwesomeIcons.alignJustify,
    FontAwesomeIcons.hashtag
  ];
  int _selectedEntity = 0;
  late SearchResults searchResults;
  late List<FeedItem> hashtagResults;

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchTextController = TextEditingController();
    searchTextController.addListener(_sendRequest);
    //  searchBloc.add(FetchNotificationsEvent([])); // statements;
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void prefillForm(String search, int searchEntity) {
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchTextController = TextEditingController();
    searchTextController.addListener(_sendRequest);

    super.initState();
    setState(() {
      searchTextController.text = search;
      _selectedEntity = searchEntity;
    });
  }

  void _sendRequest() {
    if (searchTextController.text.length >= 3 &&
        searchTextController.text != currentSearch) {
      _debouncer.run(() {
        currentSearch = searchTextController.text;
        if (_selectedEntity == 2) {
          BlocProvider.of<FeedBloc>(context)
            ..isFetching = true
            ..add(FetchTagSearchResults(tag: currentSearch));
        } else {
          searchBloc.add(FetchSearchResultsEvent(
              searchQuery: searchTextController.text,
              searchEntity: _searchEntity));
        }
      });
    }
  }

  Widget _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _searchEntityIcons.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedEntity == i,
        padding: EdgeInsets.zero,
        label: FaIcon(
          _searchEntityIcons[i],
          size: globalIconSizeSmall,
          color: Colors.white,
        ),
        elevation: 0,
        pressElevation: 5,
        shadowColor: Colors.teal,
        backgroundColor: Colors.black54,
        selectedColor: Colors.blue,
        onSelected: (bool selected) async {
          searchBloc.add(SetSearchInitialState());

          //Future.delayed(Duration(milliseconds: 500));
          setState(() {
            if (selected) {
              _selectedEntity = i;
              _searchEntity = _searchEntities[i];
              if (searchTextController.text.length > 2) {
                if (_selectedEntity == 2) {
                  BlocProvider.of<FeedBloc>(context)
                    ..isFetching = true
                    ..add(FetchTagSearchResults(tag: currentSearch));
                } else {
                  searchBloc.add(FetchSearchResultsEvent(
                      searchQuery: searchTextController.text,
                      searchEntity: _searchEntity));
                }
              }
            }
          });
        },
      );

      chips.add(SizedBox(width: 40, height: 40, child: choiceChip));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 60.w,
                    child: TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(hintText: "Search"),
                      cursorColor: globalRed,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(width: 40.w, child: _buildChips()),
                ],
              ),
              _selectedEntity == 2
                  ? BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
                      if (state is FeedInitialState) {
                        return buildBlank();
                      } else if (state is FeedLoadingState) {
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
                  : BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchInitialState) {
                          return buildBlank();
                        } else if (state is SearchLoadingState) {
                          return buildLoading();
                        } else if (state is SearchLoadedState) {
                          searchResults = state.searchResults;
                          return buildResultsListForSearchResults(
                              searchResults);
                        } else if (state is SearchErrorState) {
                          return buildErrorUi(state.message);
                        } else {
                          return buildErrorUi('');
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      height: 400,
      child: DtubeLogoPulseWithSubtitle(
        subtitle: "searching..",
        size: 30.w,
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

  Widget buildResultsListForSearchResults(SearchResults searchResults) {
    return Container(
      height: 800,
      alignment: Alignment.topLeft,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: searchResults.hits!.hits!.length,
        itemBuilder: (ctx, pos) {
          switch (_searchEntity) {
            case "Users":
              return UserResultCard(
                id: searchResults.hits!.hits![pos].sId,
                name: searchResults.hits!.hits![pos].sSource!.name!,
                dtcValue:
                    searchResults.hits!.hits![pos].sSource!.balance! + 0.0,
                vpBalance: searchResults.hits!.hits![pos].sSource!.vt! + 0.0,
              );
            case "Posts":
              return PostListCardLarge(
                alreadyVoted:
                    searchResults.hits!.hits![pos].sSource!.alreadyVoted!,
                alreadyVotedDirection: searchResults
                    .hits!.hits![pos].sSource!.alreadyVotedDirection!,
                author: searchResults.hits!.hits![pos].sSource!.author!,
                blur: false,
                defaultCommentVotingWeight: "25",
                defaultPostVotingTip: "25",
                defaultPostVotingWeight: "25",
                description:
                    searchResults.hits!.hits![pos].sSource!.jsonstring!.desc!,
                downvotesCount:
                    searchResults.hits!.hits![pos].sSource!.downvotes!.length,
                dtcValue: (searchResults.hits!.hits![pos].sSource!.dist! / 100)
                        .round()
                        .toString() +
                    " DTC",
                duration: new Duration(
                    seconds: int.tryParse(searchResults
                                .hits!.hits![pos].sSource!.jsonstring!.dur!) !=
                            null
                        ? int.parse(searchResults
                            .hits!.hits![pos].sSource!.jsonstring!.dur!)
                        : 0),
                indexOfList: pos,
                link: searchResults.hits!.hits![pos].sSource!.link!,
                mainTag:
                    searchResults.hits!.hits![pos].sSource!.jsonstring!.tag!,
                oc: searchResults.hits!.hits![pos].sSource!.jsonstring!.oc == 1
                    ? true
                    : false,
                publishDate: TimeAgo.timeInAgoTSShort(
                    searchResults.hits!.hits![pos].sSource!.ts!),
                thumbnailUrl: searchResults.hits!.hits![pos].sSource!.thumbUrl,
                title:
                    searchResults.hits!.hits![pos].sSource!.jsonstring!.title!,
                upvotesCount:
                    searchResults.hits!.hits![pos].sSource!.upvotes!.length,
                videoSource:
                    searchResults.hits!.hits![pos].sSource!.videoSource,
                videoUrl: searchResults.hits!.hits![pos].sSource!.videoUrl,
              );
            default:
              return UserResultCard(
                id: searchResults.hits!.hits![pos].sId,
                name: searchResults.hits!.hits![pos].sSource!.name!,
                dtcValue:
                    searchResults.hits!.hits![pos].sSource!.balance! + 0.0,
                vpBalance: searchResults.hits!.hits![pos].sSource!.vt! + 0.0,
              );
          }
        },
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
            return PostListCardLarge(
              alreadyVoted: searchResults[pos].alreadyVoted!,
              alreadyVotedDirection: searchResults[pos].alreadyVotedDirection!,
              author: searchResults[pos].author,
              blur: false,
              defaultCommentVotingWeight: "25",
              defaultPostVotingTip: "25",
              defaultPostVotingWeight: "25",
              description: searchResults[pos].jsonString!.desc!,
              downvotesCount: searchResults[pos].downvotes != null
                  ? searchResults[pos].downvotes!.length
                  : 0,
              dtcValue:
                  (searchResults[pos].dist / 100).round().toString() + " DTC",
              duration: new Duration(
                  seconds:
                      int.tryParse(searchResults[pos].jsonString!.dur) != null
                          ? int.parse(searchResults[pos].jsonString!.dur)
                          : 0),
              indexOfList: pos,
              link: searchResults[pos].link,
              mainTag: searchResults[pos].jsonString!.tag,
              oc: searchResults[pos].jsonString!.oc == 1 ? true : false,
              publishDate: TimeAgo.timeInAgoTSShort(searchResults[pos].ts),
              thumbnailUrl: searchResults[pos].thumbUrl,
              title: searchResults[pos].jsonString!.title,
              upvotesCount: searchResults[pos].upvotes!.length,
              videoSource: searchResults[pos].videoSource,
              videoUrl: searchResults[pos].videoUrl,
            );
          }),
    );
  }
}

class Debounce {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce({required this.milliseconds});

  void initState() {}
  run(VoidCallback action) {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
