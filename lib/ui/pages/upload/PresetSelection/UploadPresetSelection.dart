import 'package:dtube_go/res/Config/InitiativePresets.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Layouts/UploadPresetSelectionDesktop.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Layouts/UploadPresetSelectionMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class UploadPresetSelection extends StatelessWidget {
  UploadPresetSelection({Key? key, required this.uploaderCallback})
      : super(key: key);
  final VoidCallback uploaderCallback;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody:
          UploadPresetSelectionDesktop(uploaderCallback: uploaderCallback),
      tabletBody:
          UploadPresetSelectionDesktop(uploaderCallback: uploaderCallback),
      mobileBody:
          UploadPresetSelectionMobile(uploaderCallback: uploaderCallback),
    );
  }
}
