import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:async';

import 'package:dtube_togo/bloc/search/search_bloc_full.dart';

import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';

import 'package:dtube_togo/ui/pages/Explore/ResultCards/PostResultCard.dart';
import 'package:dtube_togo/ui/pages/Explore/ResultCards/UserResultCard.dart';

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
          size: Device.orientation == Orientation.portrait ? 5.w : 5.h,
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
              if (_selectedEntity == 2) {
                BlocProvider.of<FeedBloc>(context)
                  ..isFetching = true
                  ..add(FetchTagSearchResults(tag: currentSearch));
              } else {
                _searchEntity = _searchEntities[i];
                searchBloc.add(FetchSearchResultsEvent(
                    searchQuery: searchTextController.text,
                    searchEntity: _searchEntity));
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
    double deviceWidth = MediaQuery.of(context).size.width;
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
                    width: 50.w,
                    child: TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(hintText: "Search"),
                      cursorColor: globalRed,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(width: 30.w, child: _buildChips()),
                ],
              ),
              _selectedEntity == 2
                  ? BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
                      if (state is FeedInitialState ||
                          state is FeedLoadingState) {
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
              return PostResultCard(
                id: searchResults.hits!.hits![pos].sId,
                author: searchResults.hits!.hits![pos].sSource!.author!,
                dist: searchResults.hits!.hits![pos].sSource!.dist!,
                link: searchResults.hits!.hits![pos].sSource!.link!,
                tags: searchResults.hits!.hits![pos].sSource!.tags!,
                title:
                    searchResults.hits!.hits![pos].sSource!.jsonstring!.title!,
                ts: searchResults.hits!.hits![pos].sSource!.ts!,
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
