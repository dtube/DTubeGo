import 'dart:convert';

import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
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

  late TransactionBloc _txBloc;

  UploadData _uploadData = UploadData(
      link: "",
      author: "",
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
    _txBloc = BlocProvider.of<TransactionBloc>(context);
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
          if (state is IPFSUploadFilePreProcessingState) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: DTubeLogoPulse(),
                  ),
                  Text("compressing video..."),
                ],
              ),
            );
          } else if (state is IPFSUploadFilePreProcessedState) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: DTubeLogoPulse(),
                  ),
                  Text("uploading video..."),
                ],
              ),
            );
          } else if (state is IPFSUploadFilePostProcessingState) {
            return Center(
              child: PostProcessingStatusBars(
                  statusInfo: state.processingResponse),
            );
          } else if (state is IPFSUploadFilePostProcessedState) {
            var statusInfo = state.processingResponse;
            String _sourceHash = statusInfo["ipfsAddSourceVideo"]["hash"];
            String _240pHash =
                statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]["hash"];
            String _480pHash =
                statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]["hash"];
            String _spriteHash = statusInfo["sprite"]["ipfsAddSprite"]["hash"];

            var voteValue =
                (_uploadData.vpBalance * (_uploadData.vpPercent / 100)).floor();
            TxData txdata = TxData(
              // TODO: continue here -> posting ipfs video!
              link: _uploadData.link,
              author: _uploadData.author,
              tag: _uploadData.tag,
              vt: voteValue,
            );
            Transaction newTx = Transaction(type: 5, data: txdata);
            _txBloc.add(SignAndSendTransactionEvent(newTx));
            return Center(
                child: HashOverview(
              statusInfo: state.processingResponse,
            ));
          } else {
            return Center(
              child: Column(
                children: [
                  Text(""),
                ],
              ),
            );
          }
        },
      );
    }
  }
}

// just for debugging
class HashOverview extends StatelessWidget {
  Map statusInfo;
  HashOverview({Key? key, required this.statusInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("source hash"),
        Text(statusInfo["ipfsAddSourceVideo"]["hash"]),
        Text("240p hash"),
        Text(statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]["hash"]),
        Text("480p hash"),
        Text(statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]["hash"]),
        Text("sprites hash"),
        Text(statusInfo["sprite"]["ipfsAddSprite"]["hash"]),
      ],
    );
  }
}

class PostProcessingStatusBars extends StatelessWidget {
  Map statusInfo;
  PostProcessingStatusBars({Key? key, required this.statusInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: extract business logic to bloc...
    double ipfsSourceUpload =
        statusInfo["ipfsAddSourceVideo"]["step"] != "Waiting" &&
                statusInfo["ipfsAddSourceVideo"]["progress"] != null
            ? double.parse(statusInfo["ipfsAddSourceVideo"]["progress"]
                .toString()
                .replaceAll("%", ""))
            : 0.0;
    double encoding240p =
        statusInfo["encodedVideos"][0]["encode"]["step"] != "Waiting" &&
                statusInfo["encodedVideos"][0]["encode"]["progress"] != null
            ? double.parse(statusInfo["encodedVideos"][0]["encode"]["progress"]
                .toString()
                .replaceAll("%", ""))
            : 0.0;
    double ipfs240pUpload = statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]
                    ["step"] !=
                "Waiting" &&
            statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]["progress"] !=
                null
        ? double.parse(statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]
                ["progress"]
            .toString()
            .replaceAll("%", ""))
        : 0.0;

    double encoding480p =
        statusInfo["encodedVideos"][1]["encode"]["step"] != "Waiting" &&
                statusInfo["encodedVideos"][1]["encode"]["progress"] != null
            ? double.parse(statusInfo["encodedVideos"][1]["encode"]["progress"]
                .toString()
                .replaceAll("%", ""))
            : 0.0;
    double ipfs480pUpload = statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]
                    ["step"] !=
                "Waiting" &&
            statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]["progress"] !=
                null
        ? double.parse(statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]
                ["progress"]
            .toString()
            .replaceAll("%", ""))
        : 0.0;

    double creatingThumbnail = 50;
    double ipfsThumbnailUpload = 0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: DTubeLogoPulse(),
        ),
        Text('Source upload to ipfs'),
        LinearProgressIndicator(
          value: (ipfsSourceUpload + 0.0) / 100,
          semanticsLabel: 'Source upload to ipfs',
        ),
        Text('encoding to 240p'),
        LinearProgressIndicator(
          value: (encoding240p + 0.0) / 100,
          semanticsLabel: 'encoding to 240p',
        ),
        Text('uploading 240p to ipfs'),
        LinearProgressIndicator(
          value: (ipfs240pUpload + 0.0) / 100,
          semanticsLabel: 'uploading 240p to ipfs',
        ),
        Text('encoding to 480p'),
        LinearProgressIndicator(
          value: (encoding480p + 0.0) / 100,
          semanticsLabel: 'encoding to 480p',
        ),
        Text('uploading 480p to ipfs'),
        LinearProgressIndicator(
          value: (ipfs480pUpload + 0.0) / 100,
          semanticsLabel: 'uploading 480p to ipfs',
        ),
        Text('creating thumbnail'),
        LinearProgressIndicator(
          value: (creatingThumbnail + 0.0) / 100,
          semanticsLabel: 'creating thumbnail',
        ),
        Text('uploading thumbnail to ipfs'),
        LinearProgressIndicator(
          value: (ipfsThumbnailUpload + 0.0) / 100,
          semanticsLabel: 'uploading thumbnail to ipfs',
        ),
      ],
    );
  }
}
