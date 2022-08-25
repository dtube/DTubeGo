import 'package:dtube_go/ui/pages/search/Layouts/SearchScreenDesktop.dart';
import 'package:dtube_go/ui/pages/search/Layouts/SearchScreenMobile.dart';
import 'package:dtube_go/ui/pages/search/Layouts/SearchScreenTablet.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: SearchScreenDesktop(),
      tabletBody: SearchScreenTablet(),
      mobileBody: SearchScreenMobile(),
    );
  }
}
