import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/feeds/lists/FeedList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/utils/Navigation/navigationShortcuts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Bool2VoidFunc = void Function(bool);

class GenreFeedDesktop extends StatefulWidget {
  GenreFeedDesktop({Key? key}) : super(key: key);

  @override
  State<GenreFeedDesktop> createState() => _GenreFeedDesktopState();
}

class _GenreFeedDesktopState extends State<GenreFeedDesktop> {
  late FeedBloc postBloc;

  //final ScrollController _scrollController = ScrollController();

  List<FontAwesomeIcons> genreIcons = [];
  List<String> genreSubTagStrings = [];
  List<FeedItem> _feedItems = [];

  String? _nsfwMode;
  String? _hiddenMode;

  Future<bool> getDisplayModes() async {
    _hiddenMode = await sec.getShowHidden();
    _nsfwMode = await sec.getNSFW();
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
    return FutureBuilder<bool>(
        future: getDisplayModes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return buildLoading(context);
          } else {
            return buildPostList(context);
          }
        });
  }

  Widget buildLoading(BuildContext context) {
    return DtubeLogoPulseWithSubtitle(
      subtitle: "loading posts..",
      size: 10.w,
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

  Widget buildPostList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        height: 70.h,
        child: FeedList(
            feedType: "tagSearch",
            largeFormat: true,
            showAuthor: true,
            scrollCallback: (value) {},
            enableNavigation: true,
            tabletCrossAxisCount: 2,
            desktopCrossAxisCount: 5),
      ),
    );
  }
}
