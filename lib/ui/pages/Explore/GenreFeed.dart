import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/pages/Explore/GenreFeed/Layouts/GenreFeedDesktop.dart';
import 'package:dtube_go/ui/pages/Explore/GenreFeed/Layouts/GenreFeedMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
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

class GenreFeed extends StatelessWidget {
  const GenreFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: GenreFeedDesktop(),
      tabletBody: GenreFeedDesktop(),
      mobileBody: GenreFeedMobile(),
    );
  }
}
