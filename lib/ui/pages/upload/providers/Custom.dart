import 'package:dtube_go/ui/pages/upload/providers/Layouts/Desktop/CustomDesktop.dart';
import 'package:dtube_go/ui/pages/upload/providers/Layouts/Mobile/CustomMobile.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Widgets/PresetCards.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class CustomWizard extends StatelessWidget {
  CustomWizard({Key? key, required this.uploaderCallback, required this.preset})
      : super(key: key);

  final VoidCallback uploaderCallback;
  final Preset preset;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: CustomWizardDesktop(
          uploaderCallback: uploaderCallback, preset: preset),
      mobileBody: CustomWizardMobile(
          uploaderCallback: uploaderCallback, preset: preset),
      tabletBody: CustomWizardDesktop(
          uploaderCallback: uploaderCallback, preset: preset),
    );
  }
}
