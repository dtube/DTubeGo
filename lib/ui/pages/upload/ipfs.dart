// JUST IN CASE WE NEED THIS OLD CODE WITH IPFS UPLOAD PROGRESS WE KEEP IT FOR SOME TIME IN THE REPO

import 'package:dtube_go/bloc/appstate/appstate_bloc.dart';
import 'package:dtube_go/bloc/appstate/appstate_event.dart';
import 'package:dtube_go/bloc/appstate/appstate_state.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';

import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/ui/pages/upload/uploadForm.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WizardIPFS extends StatefulWidget {
  WizardIPFS({Key? key, required this.uploaderCallback}) : super(key: key);
  VoidCallback uploaderCallback;

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
      // // this will turn the global "+" icon to a rotating DTube Logo and deactivate further uploas until current is finished
      // BlocProvider.of<AppStateBloc>(context)
      //     .add(UploadStateChangedEvent(uploadState: UploadStartedState()));

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
    );
  }
}
