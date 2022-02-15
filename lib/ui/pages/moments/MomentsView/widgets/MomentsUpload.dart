import 'package:dtube_go/ui/pages/upload/dialogs/HivePostCooldownDialog.dart';
import 'package:dtube_go/utils/CountDownTimer.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'package:disk_space/disk_space.dart';
import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/UploadStartedDialog.dart';
import 'package:dtube_go/ui/widgets/OverlayWidgets/OverlayIcon.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_event.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
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
  String customMomentTitle;
  String customMomentBody;
  double size;

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
      required this.momentsUploadCrosspost,
      required this.customMomentTitle,
      required this.customMomentBody,
      required this.size})
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

  void saveAndUploadMoment(
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

// copy file to gallery

    GallerySaver.saveVideo(videoPath, albumName: "DTube");
    // upload moment
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

    widget.leaveDialogWithUploadCallback();
  }

  @override
  void initState() {
    super.initState();
    _uploadBloc = BlocProvider.of<IPFSUploadBloc>(context);
    if (widget.customMomentTitle != "") {
      _uploadData.title = widget.customMomentTitle;
    }
    if (widget.customMomentBody != "") {
      _uploadData.description = widget.customMomentBody;
    }

    loadHiveSignerAccessToken();
  }

  void loadHiveSignerAccessToken() async {
    String _accessToken = await sec.getHiveSignerAccessToken();
    _uploadData.crossPostToHive = _accessToken != '';
  }

  Future getFile(int vpBalance, double vpPercent) async {
    XFile? _pickedFile;

    double? _freeSpace = await DiskSpace.getFreeDiskSpace;
    if (_freeSpace! > AppConfig.minFreeSpaceRecordVideoInMB) {
      int _hiveCooldown = await sec.getSecondsUntilHiveCooldownEnds();
      if (_uploadData.crossPostToHive && _hiveCooldown > 0) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => HivePostCooldownDetectedDialog(
            cooldown: _hiveCooldown,
          ),
        );
      } else {
        _pickedFile = await _picker.pickVideo(
            source: ImageSource.camera, maxDuration: Duration(seconds: 60));
      }
      if (_pickedFile != null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => UploadStartedDialog(),
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

    if (_pickedFile != null) {
      saveAndUploadMoment(
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

        return Visibility(
          visible: globals.keyPermissions.contains(4),
          child: GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadowedIcon(
                    size: widget.size,
                    icon: FontAwesomeIcons.eye,
                    color: globalAlmostWhite,
                    shadowColor: Colors.black),
                ShadowedIcon(
                    size: widget.size / 2,
                    icon: FontAwesomeIcons.plus,
                    color: globalAlmostWhite,
                    shadowColor: Colors.black)
              ],
            ),
            onTap: () async {
              widget.clickedCallback();
              getFile(widget.currentVT.floor(), widget.defaultVotingWeight);
            },
          ),
        );
      },
    );
  }
}
