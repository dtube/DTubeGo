import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/Explore/GenreFeed/GenreFeed.dart';
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
  bool _genreSelected = false;

  final ScrollController _scrollController = ScrollController();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      child: Stack(
        children: [
          // Show All Genres sorted by last usage(?)
          !_genreSelected
              ? Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 15.h),
                  child: StaggeredGridView.countBuilder(
                    itemCount: genreList.length,
                    padding: EdgeInsets.only(top: 19.h),
                    crossAxisCount: 3,
                    itemBuilder: (BuildContext context, int index) {
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
                                            child: FaIcon(genreList[index].icon,
                                                size: 10.w,
                                                color: _activatedGenres
                                                        .contains(index)
                                                    ? globalRed
                                                    : Colors.white)),
                                        Text(genreList[index].mainTag,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (_activatedGenres.contains(index)) {
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
                  ),
                )
              : GenreFeed(searchTags: "test,test")

          // Show GenreFeed
        ],
      ),
    );
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
