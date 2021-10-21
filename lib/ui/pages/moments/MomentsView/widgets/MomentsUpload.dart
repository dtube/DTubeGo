import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:video_compress/video_compress.dart';

class MomentsUploadButton extends StatefulWidget {
  double defaultVotingWeight;
  double currentVT;
  VoidCallback clickedCallback;
  VoidCallback leaveDialogWithUploadCallback;
  VoidCallback leaveDialogWithoutUploadCallback;
  String momentsVotingWeight;
  String momentsUploadNSFW;
  String momentsUploadOC;
  String momentsUploadUnlist;
  String momentsUploadCrosspost;

  MomentsUploadButton(
      {Key? key,
      required this.defaultVotingWeight,
      required this.clickedCallback,
      required this.leaveDialogWithUploadCallback,
      required this.leaveDialogWithoutUploadCallback,
      required this.currentVT,
      required this.momentsVotingWeight,
      required this.momentsUploadNSFW,
      required this.momentsUploadOC,
      required this.momentsUploadUnlist,
      required this.momentsUploadCrosspost})
      : super(key: key);

  @override
  _MomentsUploadButtontate createState() => _MomentsUploadButtontate();
}

class _MomentsUploadButtontate extends State<MomentsUploadButton> {
  late IPFSUploadBloc _uploadBloc;

  File? _image;
  File? _video;
  final _picker = ImagePicker();

  UploadData _uploadData = UploadData(
      link: "",
      title: "DTubeGo Moment from " +
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      description: "DTubeGo Moment from " +
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      tag: "DTubeGo-Moments",
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
      unlistVideo: true,
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

  void uploadMoment(
      String videoPath,
      int vpBalance,
      double vpPercent,
      String momentsUploadNSFW,
      String momentsUploadOC,
      String momentsUploadUnlist,
      String momentsUploadCrosspost) async {
    _uploadData.videoLocation = videoPath;
    _uploadData.vpBalance = vpBalance;
    _uploadData.vpPercent = vpPercent;
    _uploadData.nSFWContent = momentsUploadNSFW == "true";
    _uploadData.originalContent = momentsUploadOC == "true";
    _uploadData.unlistVideo = momentsUploadUnlist == "true";
    _uploadData.crossPostToHive = momentsUploadCrosspost == "true";

    final info = await VideoCompress.getMediaInfo(videoPath);

    _uploadData.duration = (info.duration! / 1000).floor().toString();
    // // this will turn the global "+" icon to a rotating DTube Logo and deactivate further uploas until current is finished
    // BlocProvider.of<AppStateBloc>(context)
    //     .add(UploadStateChangedEvent(uploadState: UploadStartedState()));
    _uploadBloc.add(UploadVideo(
        videoPath: _uploadData.videoLocation,
        thumbnailPath: "",
        uploadData: _uploadData,
        context: context));

    // widget.leaveDialogWithUploadCallback();
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

  Future getFile(
      bool video, bool camera, int vpBalance, double vpPercent) async {
    XFile? _pickedFile;

    if (video) {
      if (camera) {
        double? _freeSpace = await DiskSpace.getFreeDiskSpace;
        if (_freeSpace! > AppConfig.minFreeSpaceRecordVideoInMB) {
          String _stillInHiveCooldown =
              await sec.getLastHivePostWithin5MinCooldown();
          if (_uploadData.crossPostToHive && _stillInHiveCooldown == "true") {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => PopUpDialogWithTitleLogo(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Please wait a bit!",
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center),
                        SizedBox(height: 2.h),
                        Text(
                            "You want to cross post to hive but you already have posted something within the last 5 minutes.",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center),
                        Text(
                            "Please wait for the 5 min hive cooldown to expire and try it again.",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center),
                        SizedBox(height: 3.h),
                        Text(
                            "This cooldown is a property coming from the hive blockchain. We just want to avoid upload errors when you crosspost.",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: globalRed),
                            textAlign: TextAlign.center),
                        SizedBox(height: 2.h),
                        InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: globalRed,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: Text(
                                "Okay thanks!",
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              FocusScope.of(context).unfocus();
                            }),
                      ],
                    ),
                  ),
                  titleWidget: Center(
                    child: FaIcon(
                      FontAwesomeIcons.cloudUploadAlt,
                      size: 8.h,
                    ),
                  ),
                  callbackOK: () {},
                  titleWidgetPadding: 10.w,
                  titleWidgetSize: 10.w),
            );
          } else {
            _pickedFile = await _picker.pickVideo(
                source: ImageSource.camera, maxDuration: Duration(seconds: 60));
          }
          if (_pickedFile != null) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => PopUpDialogWithTitleLogo(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Amazing!",
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center),
                        SizedBox(height: 2.h),
                        Text(
                            "Your moment is uploading right now and this could take some time...",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center),
                        Text(
                            "It is safe to browse DTube Go in the meantime. Go share some feedback and votes on other videos of the community.",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center),
                        SizedBox(height: 3.h),
                        Text(
                            "Make sure to not close the app or lock your screen until the upload is finished!",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: globalRed),
                            textAlign: TextAlign.center),
                        SizedBox(height: 2.h),
                        InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: globalRed,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: Text(
                                "Allright!",
                                style: Theme.of(context).textTheme.headline4,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                  titleWidget: Center(
                    child: FaIcon(
                      FontAwesomeIcons.cloudUploadAlt,
                      size: 8.h,
                    ),
                  ),
                  callbackOK: () {},
                  titleWidgetPadding: 10.w,
                  titleWidgetSize: 10.w),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('not enough free storage',
                  style: Theme.of(context).textTheme.headline1),
              content: Container(
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    Text(
                        "In order to record a video with the app please make sure to have enough free internal storage on your device.",
                        style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                        "We have set the minimum required free space to ${AppConfig.minFreeSpaceRecordVideoInMB / 1000} GB internal storage.",
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                ),
              ),
              actions: [
                new ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      }
    }

    if (_pickedFile != null) {
      uploadMoment(
          _pickedFile.path,
          widget.currentVT.floor(),
          double.parse(widget.momentsVotingWeight),
          widget.momentsUploadNSFW,
          widget.momentsUploadOC,
          widget.momentsUploadUnlist,
          widget.momentsUploadCrosspost);
    } else {
      widget.leaveDialogWithoutUploadCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateBloc, AppState>(
      builder: (context, state) {
        if (state is UploadStartedState) {
          return DTubeLogoPulseWave(
            size: 15.w,
            progressPercent: 10,
          );
        }
        if (state is UploadProcessingState) {
          return DTubeLogoPulseWave(
            size: 15.w,
            progressPercent: state.progressPercent,
          );
        }

        return GestureDetector(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShadowedIcon(
                  size: 10.w,
                  icon: FontAwesomeIcons.eye,
                  color: Colors.white,
                  shadowColor: Colors.black),
              ShadowedIcon(
                  size: 5.w,
                  icon: FontAwesomeIcons.plus,
                  color: Colors.white,
                  shadowColor: Colors.black)
            ],
          ),
          onTap: () async {
            widget.clickedCallback();
            getFile(true, true, widget.currentVT.floor(),
                widget.defaultVotingWeight);
          },
        );
      },
    );
  }
}
