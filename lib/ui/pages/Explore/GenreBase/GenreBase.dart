import 'package:dtube_go/ui/pages/Explore/GenreBase/Layouts/GenreBaseDesktop.dart';
import 'package:dtube_go/ui/pages/Explore/GenreBase/Layouts/GenreBaseMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

typedef Bool2VoidFunc = void Function(bool);

class GenreBase extends StatelessWidget {
  const GenreBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: GenreBaseDesktop(),
      tabletBody: GenreBaseDesktop(),
      mobileBody: GenreBaseMobile(),
    );
  }
}
