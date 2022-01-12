import 'package:gallery_saver/gallery_saver.dart';

import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/pages/upload/widgets/PresetCards.dart';
import 'package:dtube_go/ui/pages/upload/widgets/uploadForm.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WizardIPFS extends StatefulWidget {
  WizardIPFS({Key? key, required this.uploaderCallback, required this.preset})
      : super(key: key);
  VoidCallback uploaderCallback;
  Preset preset;

  @override
  _WizardIPFSState createState() => _WizardIPFSState();
}

class _WizardIPFSState extends State<WizardIPFS> {
  bool _uploadPressed = false;
  late IPFSUploadBloc _uploadBloc;

  late TransactionBloc _txBloc;
  late HivesignerBloc _hivesignerBloc;

  UploadData _uploadData = UploadData(
      link: "",
      title: "",
      description: "",
      tag: "",
      vpPercent: 0.0,
      vpBalance: 0,
      burnDtc: 0,
      dtcBalance: 0,
      duration: "",
      thumbnailLocation: "",
      localThumbnail: true,
      videoLocation: "",
      localVideoFile: true,
      originalContent: false,
      nSFWContent: false,
      unlistVideo: false,
      videoSourceHash: "",
      video240pHash: "",
      video480pHash: "",
      videoSpriteHash: "",
      thumbnail640Hash: "",
      thumbnail210Hash: "",
      isEditing: false,
      isPromoted: false,
      parentAuthor: "",
      parentPermlink: "",
      uploaded: false,
      crossPostToHive: false);

  void childCallback(UploadData ud) {
    setState(() {
      widget.uploaderCallback();

// save to gallery

      GallerySaver.saveVideo(_uploadData.videoLocation, albumName: "DTube");

// upload video to ipfs

      _uploadData = ud;
      _uploadPressed = true;
      _uploadBloc.add(UploadVideo(
          videoPath: _uploadData.videoLocation,
          thumbnailPath: _uploadData.thumbnailLocation,
          uploadData: _uploadData,
          context: context));
    });
  }

  @override
  void initState() {
    super.initState();
    _uploadBloc = BlocProvider.of<IPFSUploadBloc>(context);

    loadHiveSignerAccessToken();
  }

  void loadHiveSignerAccessToken() async {
    String _accessToken = await sec.getHiveSignerAccessToken();
    _uploadData.crossPostToHive = _accessToken != '';
  }

  @override
  Widget build(BuildContext context) {
    return UploadForm(
      uploadData: _uploadData,
      callback: childCallback,
      preset: widget.preset,
    );
  }
}
