import 'package:dtube_go/res/Config/ExploreConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/Explore/GenreFeed.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Bool2VoidFunc = void Function(bool);

class GenreBaseDesktop extends StatefulWidget {
  GenreBaseDesktop({Key? key}) : super(key: key);

  @override
  State<GenreBaseDesktop> createState() => _GenreBaseDesktopState();
}

class _GenreBaseDesktopState extends State<GenreBaseDesktop> {
  late FeedBloc postBloc;
  bool _showResults = false;

  late Future<String> _mainTagsFuture;
  List<FontAwesomeIcons> genreIcons = [];
  List<String> genreSubTagStrings = [];
  List<GenreTag> genreList = [];
  List<int> _activatedGenres = [];

  @override
  void initState() {
    ExploreConfig.genreTags.forEach((g) {
      genreList.add(new GenreTag.fromJson(g));
    });
    _mainTagsFuture = getSelectedMainTags();
    super.initState();
  }

  void fetchResults() async {
    List<String> _exploreTags = [];
    for (var genre in _activatedGenres) {
      for (var subTag in genreList[genre].subtags) {
        _exploreTags.add(subTag);
      }
    }
    BlocProvider.of<FeedBloc>(context)
        .add(FetchTagSearchResults(tags: _exploreTags.join(",")));
  }

  void persistSelection() async {
    List<String> _selectedMainTags = [];
    for (var genre in _activatedGenres) {
      _selectedMainTags.add(genreList[genre].mainTag);
    }
    sec.persistExploreTags(_selectedMainTags.join(","));
  }

  Future<String> getSelectedMainTags() async {
    String _exploreTagsString = await sec.getExploreTags();
    List<String> _exploreTagsList = _exploreTagsString.split(",");

    for (var i = 0; i < genreList.length; i++) {
      if (_exploreTagsList.contains(genreList[i].mainTag)) {
        _activatedGenres.add(i);
      }
    }
    if (_activatedGenres.length > 0) {
      _showResults = true;
      fetchResults();
    }
    return _exploreTagsString;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _mainTagsFuture,
        builder: (context, exploreTagsSnapshot) {
          if (exploreTagsSnapshot.connectionState == ConnectionState.none ||
              exploreTagsSnapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                height: 100.h,
                width: 100.w,
                child: Column(
                  children: [
                    Center(
                      child: OverlayText(
                        text: "Genre Explorer",
                        sizeMultiply: 1.4,
                        bold: true,
                      ),
                    ),
                    GenreSelection(
                      activatedGenres: _activatedGenres,
                      fetchResults: fetchResults,
                      genreList: genreList,
                      persistSelection: persistSelection,
                    ),
                    GenreFeed(),

                    //       // Show GenreFeed
                  ],
                ),
              ));
        });
  }
}

class GenreSelection extends StatefulWidget {
  GenreSelection(
      {Key? key,
      required this.fetchResults,
      required this.persistSelection,
      required this.activatedGenres,
      required this.genreList})
      : super(key: key);
  final VoidCallback persistSelection;
  final VoidCallback fetchResults;
  final List<GenreTag> genreList;
  final List<int> activatedGenres;
  @override
  State<GenreSelection> createState() => _GenreSelectionState();
}

class _GenreSelectionState extends State<GenreSelection> {
  ScrollController _scrollController = new ScrollController();

  bool _showSelection = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputChip(
            backgroundColor: globalRed,
            onPressed: () {
              if (widget.activatedGenres.length > 0) {
                setState(() {
                  _showSelection = !_showSelection;
                });
              }
            },
            label: Text(
              _showSelection ? "show genres" : "hide genres",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: globalBlue),
            )),
        widget.activatedGenres.length == 0
            ? Text("pick at least one genre",
                style: Theme.of(context).textTheme.caption)
            : Container(
                height: 0,
              ),
        !_showSelection
            ? Container(
                height: 100,
                width: 100.w,
                child: Center(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.genreList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GenreCard(
                            iconSize: 50,
                            currentIndex: index,
                            currentName: widget.genreList[index].mainTag,
                            currentIcon: widget.genreList[index].icon,
                            activated: widget.activatedGenres.contains(index),
                            onTapCallback: () {
                              setState(() {
                                if (widget.activatedGenres.contains(index)) {
                                  widget.activatedGenres.remove(index);
                                  widget.persistSelection();
                                  widget.fetchResults();
                                } else {
                                  widget.activatedGenres.add(index);
                                  widget.persistSelection();
                                  widget.fetchResults();
                                }
                              });
                            });
                      },
                      // staggeredTileBuilder: (int index) =>
                      //     new StaggeredTile.fit(1),
                    ),
                  ),
                ),
              )
            : Container(
                height: 100,
              ),
      ],
    );
  }
}

class GenreCard extends StatelessWidget {
  const GenreCard(
      {Key? key,
      required this.currentIndex,
      required this.currentName,
      required this.currentIcon,
      required this.onTapCallback,
      required this.activated,
      required this.iconSize});

  final int currentIndex;
  final String currentName;
  final IconData currentIcon;
  final VoidCallback onTapCallback;
  final double iconSize;

  final bool activated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          color: globalBlue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Center(
                        child: FaIcon(currentIcon,
                            size: iconSize,
                            color: activated ? globalRed : globalAlmostWhite)),
                    Text(currentName,
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          onTapCallback();
        });
  }
}

class GenreTag {
  late String mainTag;
  late List<String> subtags;
  late IconData icon;

  GenreTag({required this.mainTag, required this.subtags, required this.icon});

  GenreTag.fromJson(Map<String, dynamic> json) {
    mainTag = json['mainTag'];
    subtags = json['subtags'].cast<String>();
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainTag'] = this.mainTag;
    data['subtags'] = this.subtags;
    data['icon'] = this.icon;
    return data;
  }
}
