import 'dart:convert';

import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_togo/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
import 'package:dtube_togo/style/ThemeData.dart';
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
    unlistVideo: false,
    videoSourceHash: "",
    video240pHash: "",
    video480pHash: "",
    videoSpriteHash: "",
    thumbnail640Hash: "",
    thumbnail210Hash: "",
  );

  void childCallback(UploadData ud) {
    setState(() {
      _uploadData = ud;
      _uploadPressed = true;
      _uploadBloc.add(UploadVideo(
          _uploadData.videoLocation, _uploadData.thumbnailLocation));
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
        if (state is IPFSUploadVideoPreProcessingState) {
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
        } else if (state is IPFSUploadVideoPreProcessedState) {
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
        } else if (state is IPFSUploadVideoPostProcessingState) {
          return Center(
            child:
                PostProcessingStatusBars(statusInfo: state.processingResponse),
          );
        } else if (state is IPFSUploadVideoPostProcessedState) {
          var statusInfo = state.processingResponse;

          _uploadData.videoSourceHash =
              statusInfo["ipfsAddSourceVideo"]["hash"];
          _uploadData.video240pHash =
              statusInfo["encodedVideos"][0]["ipfsAddEncodeVideo"]["hash"];
          _uploadData.video480pHash =
              statusInfo["encodedVideos"][1]["ipfsAddEncodeVideo"]["hash"];
          _uploadData.videoSpriteHash =
              statusInfo["ipfsAddSourceVideo"]["hash"];
        } else if (state is IPFSUploadThumbnailUploadingState) {
          return Center(
            child: ThumbnailStatusCircle(),
          );
        } else if (state is IPFSUploadThumbnailUploadedState) {
          var statusInfo = state.uploadResponse;

          _uploadData.thumbnail210Hash = statusInfo["ipfsAddSource"]["hash"];
          _uploadData.thumbnail640Hash = statusInfo["ipfsAddOverlay"]["hash"];

          var voteValue =
              (_uploadData.vpBalance * (_uploadData.vpPercent / 100)).floor();

          //TODO: build TxData and send transaction to avalon

          // TxData txdata = TxData(
          //
          //   link: _uploadData.link,
          //   author: _uploadData.author,
          //   tag: _uploadData.tag,
          //   vt: voteValue,
          // );
          // Transaction newTx = Transaction(type: 5, data: txdata);
          // _txBloc.add(SignAndSendTransactionEvent(newTx));
          return Center(
              child: HashOverview(
            videoSourceHash: _uploadData.videoSourceHash,
            video240pHash: _uploadData.video240pHash,
            video480pHash: _uploadData.video480pHash,
            videoSpriteHash: _uploadData.videoSpriteHash,
            thumbnail640Hash: _uploadData.thumbnail640Hash,
            thumbnail210Hash: _uploadData.thumbnail210Hash,
          ));
        }

        return Center(
          child: Column(
            children: [
              Text(""),
            ],
          ),
        );
      });
    }
  }
}

// just for debugging
class HashOverview extends StatelessWidget {
  String videoSourceHash;
  String video240pHash;
  String video480pHash;
  String videoSpriteHash;

  String thumbnail640Hash;
  String thumbnail210Hash;

  HashOverview({
    Key? key,
    required this.videoSourceHash,
    required this.video240pHash,
    required this.video480pHash,
    required this.videoSpriteHash,
    required this.thumbnail640Hash,
    required this.thumbnail210Hash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("source hash"),
        Text(videoSourceHash),
        Text("240p hash"),
        Text(video240pHash),
        Text("480p hash"),
        Text(video480pHash),
        Text("sprites hash"),
        Text(videoSpriteHash),
        Text("thumbnail 640 hash"),
        Text(thumbnail640Hash),
        Text("thumbnail 210 hash"),
        Text(thumbnail210Hash),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: DTubeLogoPulse(),
        ),
        UploaderProgressBar(
          title: 'uploading source to ipfs',
          value: ipfsSourceUpload,
        ),
        UploaderProgressBar(
          title: 'encoding to 240p',
          value: encoding240p,
        ),
        UploaderProgressBar(
          title: 'uploading 240p to ipfs',
          value: ipfs240pUpload,
        ),
        UploaderProgressBar(
          title: 'encoding to 480p',
          value: encoding480p,
        ),

        UploaderProgressBar(
          title: 'uploading 480p to ipfs',
          value: ipfs480pUpload,
        ),
        SizedBox(height: 50)
        // UploaderProgressBar(title: 'encoding to 480p',value: encoding480p,),
        // UploaderProgressBar(title: 'encoding to 480p',value: encoding480p,),
      ],
    );
  }
}

class ThumbnailStatusCircle extends StatelessWidget {
  ThumbnailStatusCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // // TODO: extract business logic to bloc...
    // double ipfsAddSource = statusInfo["ipfsAddSource"]["step"] != "Waiting" &&
    //         statusInfo["ipfsAddSource"]["progress"] != null
    //     ? double.parse(statusInfo["ipfsAddSource"]["progress"]
    //         .toString()
    //         .replaceAll("%", ""))
    //     : 0.0;
    // double ipfsAddOverlay = statusInfo["ipfsAddOverlay"]["step"] != "Waiting" &&
    //         statusInfo["ipfsAddSource"]["progress"] != null
    //     ? double.parse(statusInfo["ipfsAddSource"]["progress"]
    //         .toString()
    //         .replaceAll("%", ""))
    //     : 0.0;

    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: DTubeLogoPulse(),
        ),
        Text("processing thumbnail..."),
        SizedBox(height: 50)
      ],
    );
  }
}

class UploaderProgressBar extends StatelessWidget {
  const UploaderProgressBar({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        LinearProgressIndicator(
          minHeight: 15,
          value: (value + 0.0) / 100,
          semanticsLabel: title,
        ),
      ],
    );
  }
}
