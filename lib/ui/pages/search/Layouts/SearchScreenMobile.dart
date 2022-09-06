import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/AppBar/DTubeSubAppBarMobile.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';
import 'package:dtube_go/bloc/search/search_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/pages/search/ResultCards/UserResultCard/UserResultCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreenMobile extends StatefulWidget {
  @override
  SearchScreenMobileState createState() => SearchScreenMobileState();

  SearchScreenMobile({
    Key? key,
  }) : super(key: key);
}

class SearchScreenMobileState extends State<SearchScreenMobile> {
  late List<String> blockedUsers;
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

  String? _defaultCommentVotingWeight;
  String? _defaultPostVotingWeight;
  String? _defaultPostVotingTip;

  String? _fixedDownvoteActivated;
  String? _fixedDownvoteWeight;

  String? _nsfwMode;
  String? _hiddenMode;
  bool? _autoPauseVideoOnPopup;
  bool? _disableAnimation;

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchTextController = TextEditingController();
    searchTextController.addListener(_sendRequest);
    getSettings();

    //  searchBloc.add(FetchNotificationsEvent([])); // statements;
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<bool> getSettings() async {
    String _blockedUsersString = await sec.getBlockedUsers();
    blockedUsers = _blockedUsersString.split(",");
    _defaultCommentVotingWeight = await sec.getDefaultVoteComments();
    _defaultPostVotingWeight = await sec.getDefaultVote();
    _defaultPostVotingTip = await sec.getDefaultVoteTip();
    _fixedDownvoteActivated = await sec.getFixedDownvoteActivated();
    _fixedDownvoteWeight = await sec.getFixedDownvoteWeight();
    _autoPauseVideoOnPopup = await sec.getVideoAutoPause() == "true";
    _disableAnimation = await sec.getDisableAnimations() == "true";

    _nsfwMode = await sec.getNSFW();
    _hiddenMode = await sec.getShowHidden();
    return true;
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
            ..add(FetchTagSearchResults(tags: currentSearch));
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
          color: globalAlmostWhite,
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
                    ..add(FetchTagSearchResults(tags: currentSearch));
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

      chips.add(SizedBox(
          width: globalIconSizeBig,
          height: globalIconSizeBig,
          child: choiceChip));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getSettings(), // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar:
                    dtubeSubAppBarMobile(true, "Global Search", context, null),
                resizeToAvoidBottomInset: true,
                body: Align(
                    alignment: Alignment.topCenter,
                    child: Center(
                        child: DtubeLogoPulseWithSubtitle(
                            subtitle: "loading results", size: 20.w))));
          } else {
            if (snapshot.hasError)
              return Scaffold(
                  appBar: dtubeSubAppBarMobile(
                      true, "Global Search", context, null),
                  resizeToAvoidBottomInset: true,
                  body: Align(
                      alignment: Alignment.topCenter,
                      child: Center(
                          child: DtubeLogoPulseWithSubtitle(
                              subtitle: "an error happened... ", size: 20.w))));
            else
              return Scaffold(
                appBar:
                    dtubeSubAppBarMobile(true, "Global Search", context, null),
                resizeToAvoidBottomInset: true,
                body: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 95.w,
                            child: DTubeFormCard(
                              avoidAnimation: true,
                              waitBeforeFadeIn: Duration(seconds: 0),
                              childs: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 60.w,
                                      child: TextField(
                                        autofocus: true,
                                        controller: searchTextController,
                                        decoration:
                                            InputDecoration(hintText: "Search"),
                                        cursorColor: globalRed,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 20.w, child: _buildChips()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _selectedEntity == 2
                              ? BlocBuilder<FeedBloc, FeedState>(
                                  builder: (context, state) {
                                  if (state is FeedInitialState) {
                                    return buildBlank();
                                  } else if (state is FeedLoadingState) {
                                    return buildLoading();
                                  } else if (state is FeedLoadedState) {
                                    hashtagResults = state.feed;
                                    BlocProvider.of<FeedBloc>(context)
                                        .isFetching = false;
                                    return buildResultsListForTagResults(
                                        hashtagResults);
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
                ),
              );
          }
        });
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
      height: 90.h,
      alignment: Alignment.topLeft,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: searchResults.hits!.hits!.length,
        itemBuilder: (ctx, pos) {
          switch (_searchEntity) {
            case "Users":
              if (!blockedUsers
                  .contains(searchResults.hits!.hits![pos].sSource!.name!)) {
                return UserResultCard(
                  id: searchResults.hits!.hits![pos].sId,
                  name: searchResults.hits!.hits![pos].sSource!.name!,
                  dtcValue:
                      searchResults.hits!.hits![pos].sSource!.balance! + 0.0,
                  vpBalance: searchResults.hits!.hits![pos].sSource!.vt! + 0.0,
                );
              } else {
                return SizedBox(
                  height: 0,
                  width: 0,
                );
              }

            case "Posts":
              if (searchResults.hits!.hits![pos].sSource!.alreadyVoted! &&
                  searchResults
                          .hits!.hits![pos].sSource!.alreadyVotedDirection! ==
                      false) {
                return SizedBox(
                  height: 0,
                  width: 0,
                );
              } else {
                return BlocProvider<UserBloc>(
                  create: (context) =>
                      UserBloc(repository: UserRepositoryImpl()),
                  child: PostListCardLarge(
                    width: 90.w,
                    alreadyVoted:
                        searchResults.hits!.hits![pos].sSource!.alreadyVoted!,
                    alreadyVotedDirection: searchResults
                        .hits!.hits![pos].sSource!.alreadyVotedDirection!,
                    author: searchResults.hits!.hits![pos].sSource!.author!,
                    blur: (_nsfwMode == 'Blur' &&
                                searchResults.hits!.hits![pos].sSource!
                                        .jsonstring?.nsfw ==
                                    1) ||
                            (_hiddenMode == 'Blur' &&
                                searchResults.hits!.hits![pos].sSource!
                                        .summaryOfVotes <
                                    0)
                        ? true
                        : false,
                    defaultCommentVotingWeight: _defaultCommentVotingWeight!,
                    defaultPostVotingTip: _defaultPostVotingTip!,
                    defaultPostVotingWeight: _defaultPostVotingWeight!,
                    fixedDownvoteActivated: _fixedDownvoteActivated!,
                    fixedDownvoteWeight: _fixedDownvoteWeight!,
                    description: searchResults
                        .hits!.hits![pos].sSource!.jsonstring!.desc!,
                    downvotesCount: searchResults
                        .hits!.hits![pos].sSource!.downvotes!.length,
                    dtcValue:
                        (searchResults.hits!.hits![pos].sSource!.dist! / 100)
                                .round()
                                .toString() +
                            " DTC",
                    duration: new Duration(
                        seconds: int.tryParse(searchResults.hits!.hits![pos]
                                    .sSource!.jsonstring!.dur!) !=
                                null
                            ? int.parse(searchResults
                                .hits!.hits![pos].sSource!.jsonstring!.dur!)
                            : 0),
                    indexOfList: pos,
                    link: searchResults.hits!.hits![pos].sSource!.link!,
                    mainTag: searchResults
                        .hits!.hits![pos].sSource!.jsonstring!.tag!,
                    oc: searchResults
                                .hits!.hits![pos].sSource!.jsonstring!.oc ==
                            1
                        ? true
                        : false,
                    publishDate: TimeAgo.timeInAgoTSShort(
                        searchResults.hits!.hits![pos].sSource!.ts!),
                    thumbnailUrl:
                        searchResults.hits!.hits![pos].sSource!.thumbUrl,
                    title: searchResults
                        .hits!.hits![pos].sSource!.jsonstring!.title!,
                    upvotesCount:
                        searchResults.hits!.hits![pos].sSource!.upvotes!.length,
                    videoSource:
                        searchResults.hits!.hits![pos].sSource!.videoSource,
                    videoUrl: searchResults.hits!.hits![pos].sSource!.videoUrl,
                    autoPauseVideoOnPopup: _autoPauseVideoOnPopup!,
                  ),
                );
              }
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
            if (searchResults[pos].alreadyVoted! &&
                searchResults[pos].alreadyVotedDirection! == false) {
              return SizedBox(
                height: 0,
                width: 0,
              );
            } else {
              return BlocProvider<UserBloc>(
                create: (context) => UserBloc(repository: UserRepositoryImpl()),
                child: PostListCardLarge(
                  width: 90.w,
                  alreadyVoted: searchResults[pos].alreadyVoted!,
                  alreadyVotedDirection:
                      searchResults[pos].alreadyVotedDirection!,
                  author: searchResults[pos].author,
                  blur: (_nsfwMode == 'Blur' &&
                              searchResults[pos].jsonString?.nsfw == 1) ||
                          (_hiddenMode == 'Blur' &&
                              searchResults[pos].summaryOfVotes < 0)
                      ? true
                      : false,
                  defaultCommentVotingWeight: _defaultCommentVotingWeight!,
                  defaultPostVotingTip: _defaultPostVotingTip!,
                  defaultPostVotingWeight: _defaultPostVotingWeight!,
                  fixedDownvoteActivated: _fixedDownvoteActivated!,
                  fixedDownvoteWeight: _fixedDownvoteWeight!,
                  description: searchResults[pos].jsonString!.desc!,
                  downvotesCount: searchResults[pos].downvotes != null
                      ? searchResults[pos].downvotes!.length
                      : 0,
                  dtcValue: (searchResults[pos].dist / 100).round().toString() +
                      " DTC",
                  duration: new Duration(
                      seconds:
                          int.tryParse(searchResults[pos].jsonString!.dur) !=
                                  null
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
                  autoPauseVideoOnPopup: _autoPauseVideoOnPopup!,
                ),
              );
            }
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
