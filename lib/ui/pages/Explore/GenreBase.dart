import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/Explore/GenreFeed.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/utils/navigationShortcuts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Bool2VoidFunc = void Function(bool);

class GenreBase extends StatefulWidget {
  GenreBase({Key? key}) : super(key: key);

  @override
  State<GenreBase> createState() => _GenreBaseState();
}

class _GenreBaseState extends State<GenreBase> {
  late FeedBloc postBloc;
  bool _showResults = false;
  late Future<bool> _genresLoaded;

  final ScrollController _scrollController = ScrollController();

  late Future<String> _mainTagsFuture;
  List<FontAwesomeIcons> genreIcons = [];
  List<String> genreSubTagStrings = [];
  List<FeedItem> _feedItems = [];
  List<GenreTag> genreList = [];
  List<int> _activatedGenres = [];

  @override
  void initState() {
    AppConfig.genreTags.forEach((g) {
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
                child: Stack(
                  children: [
                    Container(
                        height: 100.h,
                        child: !_showResults
                            ? StaggeredGridView.countBuilder(
                                padding: EdgeInsets.only(
                                  bottom: 16.h,
                                  top: 18.h,
                                ),
                                itemCount: genreList.length,
                                crossAxisCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return GenreCard(
                                      currentIndex: index,
                                      currentName: genreList[index].mainTag,
                                      currentIcon: genreList[index].icon,
                                      activated:
                                          _activatedGenres.contains(index),
                                      onTapCallback: () {
                                        setState(() {
                                          if (_activatedGenres
                                              .contains(index)) {
                                            _activatedGenres.remove(index);
                                          } else {
                                            _activatedGenres.add(index);
                                          }
                                        });
                                      });
                                },
                                staggeredTileBuilder: (int index) =>
                                    new StaggeredTile.fit(1),
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 2.w, right: 2.w),
                                child: GenreFeed(),
                              )),
                    //       // Show GenreFeed

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 18.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(0.0),
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ])),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.h, left: 2.w, right: 2.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: OverlayText(
                              text: "Genre Explorer",
                              sizeMultiply: 1.4,
                              bold: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InputChip(
                                    backgroundColor: globalRed,
                                    onPressed: () {
                                      if (_activatedGenres.length > 0) {
                                        setState(() {
                                          _showResults = !_showResults;
                                        });
                                        if (_showResults) {
                                          persistSelection();
                                          fetchResults();
                                        }
                                      }
                                    },
                                    label: Text(
                                      _showResults
                                          ? "show filter"
                                          : "show results",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: globalBlue),
                                    )),
                                Text(
                                    _activatedGenres.length == 0
                                        ? "pick at least one genre"
                                        : "",
                                    style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class GenreCard extends StatelessWidget {
  const GenreCard({
    Key? key,
    required this.currentIndex,
    required this.currentName,
    required this.currentIcon,
    required this.onTapCallback,
    required this.activated,
  });

  final int currentIndex;
  final String currentName;
  final IconData currentIcon;
  final VoidCallback onTapCallback;

  final bool activated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: 30.w,
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
                              size: 10.w,
                              color: activated ? globalRed : Colors.white)),
                      Text(currentName,
                          style: Theme.of(context).textTheme.caption)
                    ],
                  ),
                ],
              ),
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
