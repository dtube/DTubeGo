// JUST IN CASE WE NEED THIS OLD CODE WITH IPFS UPLOAD PROGRESS WE KEEP IT FOR SOME TIME IN THE REPO

import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/utils/randomPermlink.dart';

import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/pages/upload/uploadForm.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WizardIPFS extends StatefulWidget {
  const WizardIPFS({
    Key? key,
  }) : super(key: key);

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
      _uploadData = ud;
      _uploadPressed = true;
      _uploadBloc.add(UploadVideo(
          _uploadData.videoLocation,
          _uploadData.thumbnailLocation
          // just for testing: background upload
          ,
          _uploadData));
      Navigator.of(context).pop();
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
    );
  }
}
