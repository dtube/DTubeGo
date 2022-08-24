import 'package:dtube_go/res/Config/UploadConfigValues.dart';
import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:dtube_go/ui/pages/upload/dialogs/HivePostCooldownDialog.dart';
import 'package:dtube_go/ui/pages/upload/dialogs/UploadTermsDialog.dart';
import 'package:dtube_go/ui/pages/upload/widgets/uploadFormDesktop.dart';
import 'package:dtube_go/ui/pages/upload/widgets/uploadFormMobile.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/UploadStartedDialog.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/services.dart';
import 'package:dtube_go/ui/pages/upload/PresetSelection/Widgets/PresetCards.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'dart:io';
import 'package:disk_space/disk_space.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/players/P2PSourcePlayer.dart';
import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';
import 'package:dtube_go/utils/System/imageCropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class UploadForm extends StatelessWidget {
  UploadForm(
      {Key? key,
      required this.uploadData,
      required this.callback,
      required this.preset})
      : super(key: key);

  final UploadData uploadData;
  final Function(UploadData) callback;
  final Preset preset;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopBody: UploadFormDesktop(
          uploadData: uploadData, callback: callback, preset: preset),
      tabletBody: UploadFormDesktop(
          uploadData: uploadData, callback: callback, preset: preset),
      mobileBody: UploadFormMobile(
          uploadData: uploadData, callback: callback, preset: preset),
    );
  }
}
