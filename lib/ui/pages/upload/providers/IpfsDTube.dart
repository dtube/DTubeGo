import 'package:dtube_go/bloc/web3storage/web3storage_bloc_full.dart';
import 'package:dtube_go/ui/pages/upload/providers/Layouts/Desktop/IpfsDTubeDesktop.dart';
import 'package:dtube_go/ui/pages/upload/providers/Layouts/Mobile/IpfsDTubeMobile.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Widgets/PresetCards.dart';
import 'package:flutter/material.dart';

class WizardIPFS extends StatelessWidget {
  WizardIPFS({Key? key, required this.uploaderCallback, required this.preset})
      : super(key: key);
  final VoidCallback uploaderCallback;
  final Preset preset;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody:
          WizardIPFSDesktop(uploaderCallback: uploaderCallback, preset: preset),
      mobileBody:
          WizardIPFSMobile(uploaderCallback: uploaderCallback, preset: preset),
      tabletBody:
          WizardIPFSDesktop(uploaderCallback: uploaderCallback, preset: preset),
    );
  }
}
