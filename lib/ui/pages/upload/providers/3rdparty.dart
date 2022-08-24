import 'package:dtube_go/ui/pages/upload/providers/Layouts/Desktop/3rdpartyDesktop.dart';
import 'package:dtube_go/ui/pages/upload/providers/Layouts/Mobile/3rdpartyMobile.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Widgets/PresetCards.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class Wizard3rdParty extends StatelessWidget {
  Wizard3rdParty(
      {Key? key, required this.uploaderCallback, required this.preset})
      : super(key: key);

  final VoidCallback uploaderCallback;
  final Preset preset;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: Wizard3rdPartyDesktop(
          uploaderCallback: uploaderCallback, preset: preset),
      tabletBody: Wizard3rdPartyDesktop(
          uploaderCallback: uploaderCallback, preset: preset),
      mobileBody: Wizard3rdPartyMobile(
          uploaderCallback: uploaderCallback, preset: preset),
    );
  }
}
