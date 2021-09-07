import 'package:sizer/sizer.dart';

import 'dart:async';

import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/bloc/config/txTypes.dart';
import 'package:dtube_togo/bloc/search/search_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/Explore/ResultCards/PostResultCard.dart';
import 'package:dtube_togo/ui/Explore/ResultCards/UserResultCard.dart';
import 'package:dtube_togo/ui/widgets/AccountAvatar.dart';
import 'package:dtube_togo/utils/navigationShortcuts.dart';
import 'package:dtube_togo/utils/shortBalanceStrings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:dtube_togo/bloc/notification/notification_bloc_full.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();

  SearchScreen({
    Key? key,
  }) : super(key: key);
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc searchBloc;
  late TextEditingController searchTextController;
  String _searchEntity = "Users";
  final _debouncer = Debounce(milliseconds: 700);
  String currentSearch = "";
  List<String> _searchEntities = ["Users", "Posts"];
  List<IconData> _searchEntityIcons = [
    FontAwesomeIcons.user,
    FontAwesomeIcons.alignJustify
  ];
  int _selectedEntity = 0;
  late SearchResults results;

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

  void _sendRequest() {
    if (searchTextController.text.length >= 3 &&
        searchTextController.text != currentSearch) {
      _debouncer.run(() {
        currentSearch = searchTextController.text;
        searchBloc.add(FetchSearchResultsEvent(
            searchQuery: searchTextController.text,
            searchEntity: _searchEntity));
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
          size: 15,
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
              searchBloc.add(FetchSearchResultsEvent(
                  searchQuery: searchTextController.text,
                  searchEntity: _searchEntity));
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
                    width: deviceWidth - 140,
                    child: TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(hintText: "Search"),
                      cursorColor: globalRed,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 100, child: _buildChips()),
                ],
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitialState) {
                    return buildBlank();
                  } else if (state is SearchLoadingState) {
                    return buildLoading();
                  } else if (state is SearchLoadedState) {
                    results = state.searchResults;
                    return buildResultsList(results);
                  } else if (state is SearchErrorState) {
                    return buildErrorUi(state.message);
                  } else {
                    return buildErrorUi('test');
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

  Widget buildResultsList(SearchResults searchResults) {
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
