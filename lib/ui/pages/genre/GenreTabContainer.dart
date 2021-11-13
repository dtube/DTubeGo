// Currently not needed since the navigation bar does not support more than 5 items
// but let's keep it in the code for now

import 'package:dtube_go/ui/pages/genre/GenreViewBase.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/res/appConfigValues.dart';
import 'package:chips_input/chips_input.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/FeedViewBase.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayText.dart';
import 'package:dtube_go/utils/ResponsiveLayout.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';

import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class GenreMainPage extends StatefulWidget {
  GenreMainPage({Key? key}) : super(key: key);

  @override
  _GenreMainPageState createState() => _GenreMainPageState();
}

class _GenreMainPageState extends State<GenreMainPage>
    with SingleTickerProviderStateMixin {
  List<String> _tabNames = ["Genre Feed"];
  List<IconData> _tabIcons = [FontAwesomeIcons.hashtag];
  late TabController _tabController;
  int _selectedIndex = 0;
  List<FilterTag> mockResults = [];
  String selectedTagsString = "";
  List<FilterTag> selectedMainTags = [];
  bool showTagFilter = false;
  FocusNode tagSearch = new FocusNode();
  @override
  void initState() {
    _tabController = new TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _selectedIndex) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        print("Selected Index: " + _tabController.index.toString());
        switch (_selectedIndex) {
          case 0:
            BlocProvider.of<FeedBloc>(context)
              ..isFetching = true
              ..add(FetchTagSearchResults(
                  tags: selectedTagsString.replaceAll(' ', ',')));
            break;

          default:
        }
      }
    });
    BlocProvider.of<FeedBloc>(context)
      ..isFetching = true
      ..add(FetchFeedEvent(feedType: "NewFeed"));

    for (var maintag in AppConfig.genreTags.keys) {
      mockResults
          .add(FilterTag(maintag, AppConfig.genreTags[maintag]!.join(' ')));
    }
    getMainTagsFromStorage();
    super.initState();
  }

  void getMainTagsFromStorage() async {
    String _selectedSubTags = "";
    String _mainTagsString = await sec.getGenreTags();
    List<String> _mainTags = _mainTagsString.split(',');
    selectedMainTags = [];
    setState(() {
      for (var t in _mainTags) {
        selectedMainTags.add(findTag(t));
        _selectedSubTags = _selectedSubTags + findTag(t).subtags + ',';
      }
      selectedTagsString =
          _selectedSubTags.substring(0, _selectedSubTags.length - 1);
    });
  }

  void pushMainTagsToStorage(String tags) async {
    await sec.persistGenreTags(tags);
  }

  FilterTag findTag(String name) =>
      mockResults.firstWhere((tag) => tag.name == name);

  @override
  Widget build(BuildContext context) {
    EdgeInsets _paddingTabBarView =
        EdgeInsets.zero; // only used in landscape for now

    return Scaffold(
      //appBar: dtubeSubAppBar(true, "", context, null),
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          Padding(
            padding: _paddingTabBarView,
            child: TabBarView(
              children: [
                Stack(
                  fit: StackFit.expand,
                  children: [
                    GenreViewBase(
                        feedType: 'tagSearch',
                        largeFormat: true,
                        showAuthor: false,
                        topPadding: 7.h,
                        scrollCallback: (bool) {}),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10.h,
                        ),
                        child: Container(
                          width: 85.w,
                          // height: 10.h,
                          child: Stack(
                            children: [
                              Visibility(
                                visible: !showTagFilter,
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() async {
                                                getMainTagsFromStorage();
                                                showTagFilter = true;
                                              });
                                            },
                                            icon: ShadowedIcon(
                                                size: 5.w,
                                                icon: FontAwesomeIcons.filter,
                                                color: Colors.white,
                                                shadowColor: Colors.black)),
                                        Text("show genre filter",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)
                                      ],
                                    )),
                              ),
                              Visibility(
                                visible: showTagFilter,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Container(
                                    width: 75.w,
                                    child: ChipsInput(
                                      initialValue: selectedMainTags,
                                      cursorColor: Colors.white,
                                      focusNode: tagSearch,
                                      decoration: InputDecoration(
                                        //   labelText: "Select Tags",
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, 0),
                                            blurRadius: 2),
                                        //Shadow(color: Colors.white, offset: Offset(0, 0), blurRadius: 10),
                                        Shadow(
                                          offset: Offset(4.0, 3.0),
                                          blurRadius: 10,
                                          color: Colors.black,
                                        ),
                                      ]),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      findSuggestions: (String query) {
                                        if (query.isNotEmpty) {
                                          print(query);
                                          var lowercaseQuery =
                                              query.toLowerCase();
                                          final results = mockResults
                                              .where((tag) {
                                            return tag.name
                                                    .toLowerCase()
                                                    .contains(
                                                        query.toLowerCase()) ||
                                                tag.subtags
                                                    .toLowerCase()
                                                    .contains(
                                                        query.toLowerCase());
                                          }).toList(growable: false)
                                            ..sort((a, b) => a.name
                                                .toLowerCase()
                                                .indexOf(lowercaseQuery)
                                                .compareTo(b.name
                                                    .toLowerCase()
                                                    .indexOf(lowercaseQuery)));
                                          return results;
                                        }
                                        return mockResults;
                                      },
                                      onChanged: (data) {
                                        String selectedMainTagsString = "";
                                        setState(() {
                                          selectedTagsString = "";
                                          for (var d in data) {
                                            selectedTagsString =
                                                selectedTagsString +
                                                    findTag(d.toString())
                                                        .subtags +
                                                    ',';
                                            selectedMainTagsString =
                                                selectedMainTagsString +
                                                    d.toString() +
                                                    ',';
                                          }
                                          selectedTagsString =
                                              selectedTagsString.replaceAll(
                                                  ' ', ',');
                                          BlocProvider.of<FeedBloc>(context)
                                            ..isFetching = true
                                            ..add(FetchTagSearchResults(
                                                tags: selectedTagsString
                                                    .substring(
                                                        0,
                                                        selectedTagsString
                                                                .length -
                                                            1)));
                                          String _saveMainTags =
                                              selectedMainTagsString.substring(
                                                  0,
                                                  selectedMainTagsString
                                                          .length -
                                                      1);
                                          pushMainTagsToStorage(_saveMainTags);
                                          tagSearch.unfocus();
                                        });
                                      },
                                      chipBuilder:
                                          (context, state, FilterTag tag) {
                                        return Theme(
                                          data: ThemeData(
                                              canvasColor: Colors.transparent),
                                          child: InputChip(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            selectedColor: Colors.transparent,
                                            elevation: 0,
                                            key: ObjectKey(tag),
                                            // label: Text(tag.name),
                                            label: OverlayText(
                                              text: tag.toString(),
                                              bold: true,
                                              color: Colors.white,
                                              sizeMultiply: 1.2,
                                            ),
                                            // deleteIconColor: Colors.white,
                                            deleteIcon: ShadowedIcon(
                                              icon: FontAwesomeIcons.times,
                                              size: 4.w,
                                              color: Colors.white,
                                              shadowColor: Colors.black,
                                            ),
                                            onDeleted: () =>
                                                state.deleteChip(tag),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        );
                                      },
                                      suggestionBuilder:
                                          (context, FilterTag tag) {
                                        return ListTile(
                                          key: ObjectKey(tag),
                                          title: Text(tag.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          subtitle: Text(tag.subtags,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showTagFilter,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showTagFilter = false;
                                        });
                                      },
                                      icon: ShadowedIcon(
                                          size: 5.w,
                                          icon: FontAwesomeIcons.chevronLeft,
                                          color: Colors.white,
                                          shadowColor: Colors.black)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              controller: _tabController,
            ),
          ),
          ResponsiveLayout(
            portrait: TabBarWithPosition(
              tabIcons: _tabIcons,
              iconSize: globalIconSizeMedium,
              tabController: _tabController,
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 11.h, right: 4.w),
              rotation: 0,
              menuSize: globalIconSizeMedium * 6,
            ),
            landscape: TabBarWithPosition(
              tabIcons: _tabIcons,
              iconSize: globalIconSizeMedium,
              tabController: _tabController,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              rotation: 3,
              menuSize: 80.h,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              //padding: EdgeInsets.only(top: 5.h),
              child: OverlayText(
                text: _tabNames[_selectedIndex],
                sizeMultiply: 1.4,
                bold: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabBarWithPosition extends StatelessWidget {
  const TabBarWithPosition(
      {Key? key,
      required this.tabIcons,
      required this.iconSize,
      required this.tabController,
      required this.alignment,
      required this.padding,
      required this.rotation,
      required this.menuSize})
      : super(key: key);

  final List<IconData> tabIcons;
  final double iconSize;
  final TabController tabController;
  final Alignment alignment;
  final EdgeInsets padding;
  final int rotation;
  final double menuSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: RotatedBox(
          quarterTurns: rotation,
          child: Container(
            width: menuSize,
            child: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: RotatedBox(
                    quarterTurns: rotation == 3 ? 1 : 0,
                    child: ShadowedIcon(
                        icon: tabIcons[4],
                        color: Colors.white,
                        shadowColor: Colors.black,
                        size: iconSize),
                  ),
                ),
              ],
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}

class FilterTag {
  final String name;
  final String subtags;

  const FilterTag(this.name, this.subtags);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterTag &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
