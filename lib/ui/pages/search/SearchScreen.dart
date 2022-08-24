import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/pages/search/Layouts/SearchScreenDesktop.dart';
import 'package:dtube_go/ui/pages/search/Layouts/SearchScreenMobile.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/ui/pages/feeds/cards/PostListCardLarge.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/utils/Strings/friendlyTimestamp.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:async';
import 'package:dtube_go/bloc/search/search_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/pages/search/ResultCards/UserResultCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: SearchScreenDesktop(),
      tabletBody: SearchScreenDesktop(),
      mobileBody: SearchScreenMobile(),
    );
  }
}
