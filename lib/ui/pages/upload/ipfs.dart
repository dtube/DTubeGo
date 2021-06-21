import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/pages/upload/uploadForm.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  UploadData _uploadData = UploadData(
      title: "",
      description: "",
      tag: "",
      vpPercent: 0.0,
      vpBalance: 0,
      burnDtc: 0,
      dtcBalance: 0,
      duration: new Duration(seconds: 0),
      thumbnailLocation: "",
      localThumbnail: true,
      videoLocation: "",
      localVideoFile: true,
      originalContent: false,
      nSFWContent: false,
      unlistVideo: false);

  void childCallback(UploadData ud) {
    setState(() {
      _uploadData = ud;
      _uploadPressed = true;
      _uploadBloc.add(UploadFile(_uploadData.videoLocation));
    });
  }

  @override
  void initState() {
    super.initState();
    _uploadBloc = BlocProvider.of<IPFSUploadBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_uploadPressed) {
      return UploadForm(
        uploadData: _uploadData,
        callback: childCallback,
      );
    } else {
      return BlocBuilder<IPFSUploadBloc, IPFSUploadState>(
        builder: (context, state) {
          if (state is IPFSUploadFileProcessingState) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: DTubeLogoPulse(),
                  ),
                  Text("compressing video.. please wait.."),
                ],
              ),
            );
          } else if (state is IPFSUploadFileProcessedState) {
            return Center(child: Column(
              children: [
                
                Text("finished compressing"),
              ],
            ));
          } else {
            return Text("test");
          }
        },
      );
    }
  }
}
