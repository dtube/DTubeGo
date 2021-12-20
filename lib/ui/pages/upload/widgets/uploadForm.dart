import 'package:flutter/services.dart';

import 'package:dtube_go/ui/pages/upload/widgets/PresetCards.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';

import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';

import 'dart:io';
import 'package:disk_space/disk_space.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/players/BetterPlayer.dart';
import 'package:dtube_go/ui/widgets/players/YTplayerIframe.dart';

import 'package:dtube_go/utils/secureStorage.dart';
import 'package:dtube_go/utils/imageCropper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class UploadForm extends StatefulWidget {
  UploadForm(
      {Key? key,
      required this.uploadData,
      required this.callback,
      required this.preset})
      : super(key: key);

  late UploadData uploadData;
  final Function(UploadData) callback;
  Preset preset;

  @override
  _UploadFormState createState() => _UploadFormState(uploadData);
}

class _UploadFormState extends State<UploadForm> {
  _UploadFormState(this.stateUploadData);
  late UploadData stateUploadData;

  late TransactionBloc _txBloc;
  late UserBloc _userBloc;
  late SettingsBloc _settingsBloc;

  // hivesigner variables
  late HivesignerBloc _hivesignerBloc;
  bool hiveSignerValid = false;
  String hiveSignerUsername = "";
  late ThirdPartyUploaderBloc _thirdPartyUploaderBloc;
  bool lastPostWithinCooldown = false;

  // form variables
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();
  bool _formIsFilled = false;
  FocusNode _titleFocus = new FocusNode();
  FocusNode _tagFocus = new FocusNode();
  bool uploadEnabled = true;
  late VideoPlayerController _videocontroller;
  late YoutubePlayerController _ytController;

// video and thumbnail variables
  File? _image;
  String _imageHints = "";
  File? _video;
  final _picker = ImagePicker();
  bool showVideoPreview = false;

  void childCallback(String videoPath) {
    setState(() {
      _video = File(videoPath);
      stateUploadData.localVideoFile = true;
      stateUploadData.videoLocation = videoPath;
    });
  }

  @override
  void initState() {
    super.initState();
    // _titleController.text = stateUploadData.title;
    // _descController.text = stateUploadData.description;
    // _tagController.text = stateUploadData.tag;
    _titleController.text = widget.preset.subject;
    _descController.text = widget.preset.description;
    _tagController.text = widget.preset.tag;

    _userBloc = BlocProvider.of<UserBloc>(context);
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _hivesignerBloc = BlocProvider.of<HivesignerBloc>(context);
    _thirdPartyUploaderBloc = BlocProvider.of<ThirdPartyUploaderBloc>(context);

    _userBloc.add(FetchDTCVPEvent());
    _settingsBloc.add(FetchSettingsEvent());
    _videocontroller =
        VideoPlayerController.asset('assets/videos/firstpage.mp4');

    _ytController =
        YoutubePlayerController(initialVideoId: stateUploadData.videoLocation);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future getFile(bool video, bool camera) async {
    String imageUploadProvider = await sec.getImageUploadService();

    XFile? _pickedFile;

    if (video) {
      if (camera) {
        double? _freeSpace = await DiskSpace.getFreeDiskSpace;
        if (_freeSpace! > AppConfig.minFreeSpaceRecordVideoInMB) {
          print(await DiskSpace.getFreeDiskSpace);
          _pickedFile = await _picker.pickVideo(
            source: ImageSource.camera,
          );
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
      } else {
        _pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      }
      _titleFocus.requestFocus();
    } else {
      _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (_pickedFile != null) {
        var _tempImage = File(_pickedFile.path);
        var decodedImage =
            await decodeImageFromList(_tempImage.readAsBytesSync());
        print(decodedImage.width);
        print(decodedImage.height);
        if (decodedImage.height != decodedImage.width / 16 * 9) {
          _imageHints =
              "We recommend to use a thumbnail with an aspect ratio of 16:9. Yours is different but you can crop it now:";
        }
      }
    }
    setState(() {
      if (_pickedFile != null) {
        if (!video) {
          _image = File(_pickedFile.path);
          stateUploadData.localThumbnail = true;
          stateUploadData.thumbnailLocation = _pickedFile.path;
        } else {
          _video = File(_pickedFile.path);
          stateUploadData.localVideoFile = true;
          stateUploadData.videoLocation = _pickedFile.path;
        }
      } else {
        print('No file selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, stateDTCVP) {
        if (stateDTCVP is UserDTCVPLoadedState) {
          setState(() {
            stateUploadData.dtcBalance = stateDTCVP.dtcBalance;
            stateUploadData.vpBalance = stateDTCVP.vtBalance["v"]!;
          });
        }
      },
      // bloc listener for reacting when settings got loaded
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, stateSettings) {
          if (stateSettings is SettingsLoadedState) {
            setState(() {
              stateUploadData.vpPercent = double.parse(stateSettings
                  .settings[settingKey_DefaultUploadVotingWeigth]!);
              // if (_titleController.text.isEmpty) {
              //   _titleController.text =
              //       stateSettings.settings[settingKey_templateTitle]!;
              // }
              // if (_descController.text.isEmpty) {
              //   _descController.text =
              //       stateSettings.settings[settingKey_templateBody]!;
              // }
              // if (_tagController.text.isEmpty) {
              //   _tagController.text =
              //       stateSettings.settings[settingKey_templateTag]!;
              // }
              stateUploadData.nSFWContent =
                  stateSettings.settings[settingKey_DefaultUploadNSFW]! ==
                      "true";

              stateUploadData.originalContent =
                  stateSettings.settings[settingKey_DefaultUploadOC]! == "true";

              stateUploadData.unlistVideo =
                  stateSettings.settings[settingKey_DefaultUploadUnlist]! ==
                      "true";

              stateUploadData.crossPostToHive =
                  stateSettings.settings[settingKey_DefaultUploadCrosspost]! ==
                      "true";

              if (stateSettings.settings[settingKey_hiveSignerUsername] !=
                      null &&
                  stateSettings.settings[settingKey_hiveSignerUsername] != "") {
                DateTime requestedOn = DateTime.parse(stateSettings
                    .settings[settingKey_hiveSignerAccessTokenRequestedOn]!);
                DateTime invalidOn = requestedOn.add(Duration(
                    seconds: int.parse(stateSettings.settings[
                        settingKey_hiveSignerAccessTokenExpiresIn]!)));
                if (invalidOn.isAfter(DateTime.now())) {
                  stateUploadData.crossPostToHive = true;
                  hiveSignerValid = true;
                  hiveSignerUsername =
                      stateSettings.settings[settingKey_hiveSignerUsername]!;
                }
              }
              lastPostWithinCooldown =
                  stateSettings.settings[settingKey_HiveStillInCooldown] ==
                      "true";
            });
          }
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                videoPreview(),
                Container(
                  width: 95.w,
                  child: stateUploadData.videoLocation != ""
                      ? DTubeFormCard(
                          avoidAnimation: true,
                          waitBeforeFadeIn: Duration(seconds: 0),
                          childs: [
                            SizedBox(height: 8),
                            stateUploadData.videoLocation != ""
                                ? basicData()
                                : SizedBox(height: 50),
                            SizedBox(height: 8),
                            _formIsFilled
                                ? imagePreview()
                                : SizedBox(height: 50),
                            _formIsFilled
                                ? Column(
                                    children: [
                                      moreSettings(),
                                      SizedBox(height: 8),
                                      InputChip(
                                        backgroundColor: globalRed,
                                        label: Text("upload",
                                            style: TextStyle(fontSize: 24)),
                                        onPressed: _formIsFilled
                                            ? () async {
                                                String _stillInHiveCooldown =
                                                    await sec
                                                        .getLastHivePostWithin5MinCooldown();
                                                if (stateUploadData
                                                        .crossPostToHive &&
                                                    _stillInHiveCooldown ==
                                                        "true") {
                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        PopUpDialogWithTitleLogo(
                                                            showTitleWidget:
                                                                true,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      "Please wait a bit!",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline4,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  SizedBox(
                                                                      height:
                                                                          2.h),
                                                                  Text(
                                                                      "You want to cross post to hive but you already have posted something within the last 5 minutes.",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  Text(
                                                                      "Please wait for the 5 min hive cooldown to expire and try it again.",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  SizedBox(
                                                                      height:
                                                                          3.h),
                                                                  Text(
                                                                      "This cooldown is a property coming from the hive blockchain. We just want to avoid upload errors when you crosspost.",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6!
                                                                          .copyWith(
                                                                              color:
                                                                                  globalRed),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  SizedBox(
                                                                      height:
                                                                          2.h),
                                                                  InkWell(
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                20.0,
                                                                            bottom:
                                                                                20.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              globalRed,
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(20.0),
                                                                              bottomRight: Radius.circular(20.0)),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Okay thanks!",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline4,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                            titleWidget: Center(
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .cloudUploadAlt,
                                                                size: 8.h,
                                                              ),
                                                            ),
                                                            callbackOK: () {},
                                                            titleWidgetPadding:
                                                                10.w,
                                                            titleWidgetSize:
                                                                10.w),
                                                  );
                                                } else {
                                                  widget.callback(
                                                      stateUploadData);

                                                  showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) =>
                                                        PopUpDialogWithTitleLogo(
                                                            showTitleWidget:
                                                                true,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                7.h),
                                                                    child: Text(
                                                                        "Amazing!",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline4,
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          2.h),
                                                                  Text(
                                                                      "Your new video is uploading right now and this could take some time...",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  Text(
                                                                      "It is safe to browse DTube Go in the meantime. Go share some feedback and votes on other videos of the community.",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyText1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  SizedBox(
                                                                      height:
                                                                          3.h),
                                                                  Text(
                                                                      "Make sure to not close the app or lock your screen until the upload is finished!",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6!
                                                                          .copyWith(
                                                                              color:
                                                                                  globalRed),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  SizedBox(
                                                                      height:
                                                                          2.h),
                                                                  InkWell(
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                20.0,
                                                                            bottom:
                                                                                20.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              globalRed,
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(20.0),
                                                                              bottomRight: Radius.circular(20.0)),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Allright!",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline4,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                            titleWidget: Center(
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .cloudUploadAlt,
                                                                size: 8.h,
                                                              ),
                                                            ),
                                                            callbackOK: () {},
                                                            titleWidgetPadding:
                                                                20.w,
                                                            titleWidgetSize:
                                                                10.w),
                                                  );
                                                }
                                              }
                                            : null,
                                      ),
                                      SizedBox(
                                        height: 100,
                                      )
                                    ],
                                  )
                                : SizedBox(height: 50),
                            SizedBox(height: 50)
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget videoPreview() {
    if (!stateUploadData.localVideoFile) {
      // _tagFocus.requestFocus();
      checkIfFormIsFilled();
      return Container(
        width: 95.w,
        child: DTubeFormCard(
          avoidAnimation: true,
          waitBeforeFadeIn: Duration(seconds: 0),
          childs: [
            YTPlayerIFrame(
                videoUrl: stateUploadData.videoLocation,
                autoplay: false,
                allowFullscreen: false,
                controller: _ytController),
          ],
        ),
      );
    } else {
      return Container(
        width: 95.w,
        child: DTubeFormCard(
          avoidAnimation: true,
          waitBeforeFadeIn: Duration(seconds: 0),
          childs: [
            Column(
              children: [
                Text("1. Video file",
                    style: Theme.of(context).textTheme.headline5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InputChip(
                      backgroundColor: globalRed,
                      label: Row(
                        children: [
                          Icon(FontAwesomeIcons.solidFolderOpen),
                          SizedBox(width: 8),
                          Text(_video == null ? "pick file" : "change file",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      onPressed: () {
                        getFile(true, false);
                      },
                    ),
                    InputChip(
                      backgroundColor: globalRed,
                      label: Row(
                        children: [
                          Icon(_video == null
                              ? FontAwesomeIcons.video
                              : FontAwesomeIcons.undo),
                          SizedBox(width: 8),
                          Text(
                            _video == null ? "record" : "re-record",
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      onPressed: () {
                        getFile(true, true);
                      },
                    ),
                  ],
                ),
                stateUploadData.videoLocation != ""

                    // e.g. open issue on https://github.com/jhomlala/betterplayer/issues
                    ? Column(children: [
                        showVideoPreview
                            ? BP(
                                videoUrl: _video!.path,
                                looping: false,
                                autoplay: false,
                                localFile: true,
                                controls: true,
                                //key: UniqueKey(),
                                usedAsPreview: true,
                                allowFullscreen: false,
                                portraitVideoPadding: 50.0,
                                videocontroller: _videocontroller)
                            : SizedBox(height: 0),
                        InputChip(
                            selectedColor: globalRed,
                            label: Text(
                              (showVideoPreview ? 'hide' : 'show') + " preview",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            avatar: FaIcon(showVideoPreview
                                ? FontAwesomeIcons.checkSquare
                                : FontAwesomeIcons.square),
                            onSelected: (bool) {
                              setState(() {
                                showVideoPreview = !showVideoPreview;
                              });
                            }),
                      ])
                    : SizedBox(
                        height: 0,
                      ),
              ],
            )
          ],
        ),
      );
    }
  }

  Widget basicData() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text("2. Basic information",
              style: Theme.of(context).textTheme.headline5),
          TextFormField(
            cursorColor: globalRed,
            decoration: new InputDecoration(
              labelText: "Title",
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
            style: Theme.of(context).textTheme.bodyText1,
            controller: _titleController,
            onChanged: (val) {
              checkIfFormIsFilled();
            },
            focusNode: _titleFocus,
            validator: (value) {
              if (value!.isNotEmpty && value.length > 0) {
                return null;
              } else {
                return 'please fill in a title';
              }
            },
          ),
          TextFormField(
            cursorColor: globalRed,
            maxLines: 5,
            decoration: new InputDecoration(
              labelText: "Description",
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
            style: Theme.of(context).textTheme.bodyText1,
            controller: _descController,
            onChanged: (val) {
              checkIfFormIsFilled();
            },
            validator: (value) {
              if (value!.isNotEmpty && value.length > 0) {
                return null;
              } else {
                return 'please fill in a description';
              }
            },
          ),
          TextFormField(
            cursorColor: globalRed,
            decoration: new InputDecoration(
              labelText: "Tag",
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
            style: Theme.of(context).textTheme.bodyText1,
            controller: _tagController,
            focusNode: _tagFocus,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow((RegExp("[a-zA-Z0-9]")))
            ],
            onChanged: (val) {
              checkIfFormIsFilled();
            },
            validator: (value) {
              if (value!.isNotEmpty && value.length > 0) {
                return null;
              } else {
                return 'please fill in a tag';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget imagePreview() {
    return Center(
      child: Column(
        children: [
          Column(
            children: [
              Text("3. Additional information",
                  style: Theme.of(context).textTheme.headline5),
              InputChip(
                backgroundColor: globalRed,
                label: Text(
                    stateUploadData.thumbnailLocation == ""
                        ? "pick a custom thumbnail"
                        : "change thumbnail",
                    style: Theme.of(context).textTheme.bodyText1),
                onPressed: () {
                  getFile(false, false);
                },
              ),

              stateUploadData.thumbnailLocation != ""
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: 80.w,
                            child: stateUploadData.localThumbnail
                                ? Image.file(
                                    File(stateUploadData.thumbnailLocation))
                                : CachedNetworkImage(
                                    imageUrl:
                                        stateUploadData.thumbnailLocation)),
                        _imageHints != ""
                            ? Column(
                                children: [
                                  Container(
                                      width: 80.w,
                                      child: Text(_imageHints,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)),
                                  InputChip(
                                    backgroundColor: globalRed,
                                    label: Text("crop thumbnail",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    onPressed: () async {
                                      File croppedFile = await cropImage(File(
                                          stateUploadData.thumbnailLocation));
                                      setState(() {
                                        stateUploadData.thumbnailLocation =
                                            croppedFile.path;
                                      });
                                    },
                                  )
                                ],
                              )
                            : SizedBox(height: 0)
                      ],
                    )
                  : SizedBox(height: 0)
              //       ;
              // }),
            ],
          ),
        ],
      ),
    );
  }

  Widget moreSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Wrap(
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.spaceEvenly,
          children: [
            ChoiceChip(
                selected: stateUploadData.originalContent,
                label: Text('original content',
                    style: Theme.of(context).textTheme.bodyText1),
                labelStyle: TextStyle(color: globalAlmostWhite),
                avatar: stateUploadData.originalContent
                    ? FaIcon(
                        FontAwesomeIcons.check,
                        size: 15,
                      )
                    : FaIcon(FontAwesomeIcons.award),
                backgroundColor: Colors.grey.withAlpha(30),
                selectedColor: Colors.green[700],
                onSelected: (bool selected) {
                  setState(() {
                    stateUploadData.originalContent =
                        !stateUploadData.originalContent;
                  });
                }),
            ChoiceChip(
                selected: stateUploadData.nSFWContent,
                label: Text('nsfw content',
                    style: Theme.of(context).textTheme.bodyText1),
                labelStyle: TextStyle(color: globalAlmostWhite),
                avatar: stateUploadData.nSFWContent
                    ? FaIcon(
                        FontAwesomeIcons.check,
                        size: 15,
                      )
                    : null,
                backgroundColor: Colors.grey.withAlpha(30),
                selectedColor: Colors.green[700],
                onSelected: (bool selected) {
                  setState(() {
                    stateUploadData.nSFWContent = !stateUploadData.nSFWContent;
                  });
                }),
            ChoiceChip(
                selected: stateUploadData.unlistVideo,
                label: Text('unlist video',
                    style: Theme.of(context).textTheme.bodyText1),
                labelStyle: TextStyle(color: globalAlmostWhite),
                avatar: stateUploadData.unlistVideo
                    ? FaIcon(
                        FontAwesomeIcons.check,
                        size: 15,
                      )
                    : null,
                backgroundColor: Colors.grey.withAlpha(30),
                selectedColor: Colors.green[700],
                onSelected: (bool selected) {
                  setState(() {
                    stateUploadData.unlistVideo = !stateUploadData.unlistVideo;
                  });
                }),
            hiveSignerUsername != ""
                ? ChoiceChip(
                    selected: stateUploadData.crossPostToHive,
                    label: Text('cross-post to hive',
                        style: Theme.of(context).textTheme.bodyText1),
                    labelStyle: TextStyle(color: globalAlmostWhite),
                    avatar: stateUploadData.crossPostToHive
                        ? FaIcon(
                            FontAwesomeIcons.check,
                            size: 15,
                          )
                        : null,
                    backgroundColor: Colors.grey.withAlpha(30),
                    selectedColor: Colors.green[700],
                    onSelected: (bool selected) {
                      if (!stateUploadData.crossPostToHive) {
                        if (!hiveSignerValid) {
                          BlocProvider.of<HivesignerBloc>(context).add(
                              CheckAccessToken(
                                  hiveSignerUsername: hiveSignerUsername));
                        }
                      }
                      setState(() {
                        stateUploadData.crossPostToHive =
                            !stateUploadData.crossPostToHive;
                      });
                    })
                : SizedBox(
                    width: 0,
                  ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "bet in VP (initial selfvote):",
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              width: 95.w,
              child: Slider(
                min: 0.1,
                max: 100.0,
                value: stateUploadData.vpPercent,

                label: stateUploadData.vpPercent.floor().toString(),
                //divisions: 40,
                inactiveColor: globalBlue,
                activeColor: globalRed,
                onChanged: (dynamic value) {
                  setState(() {
                    stateUploadData.vpPercent = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ((stateUploadData.vpBalance /
                                  100 *
                                  stateUploadData.vpPercent) /
                              1000)
                          .toStringAsFixed(2) +
                      'K VP',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Text(
                    stateUploadData.vpPercent.toStringAsFixed(2) + '%',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Promote:",
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              width: 95.w,
              child: Slider(
                min: 0.0,
                max: (stateUploadData.dtcBalance + 0.0) / 100 < 100.0
                    ? (stateUploadData.dtcBalance + 0.0) / 100
                    : 100.0,
                value: stateUploadData.burnDtc,

                label: stateUploadData.burnDtc.floor().toString(),
                //divisions: 40,
                inactiveColor: globalBlue,
                activeColor: globalRed,
                onChanged: (dynamic value) {
                  setState(() {
                    stateUploadData.burnDtc = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stateUploadData.burnDtc.roundToDouble().toString() + ' DTC',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // TODO: calculate approx. VP of burn
              ],
            )
          ],
        ),
      ],
    );
  }

  void checkIfFormIsFilled() {
    if (_titleController.text.length > 0 &&
        _descController.text.length > 0 &&
        _tagController.text.length > 0) {
      setState(() {
        _formIsFilled = true;
        stateUploadData.title = _titleController.text;
        stateUploadData.description = _descController.text;
        stateUploadData.tag = _tagController.text;
      });
    } else {
      setState(() {
        _formIsFilled = false;
      });
    }
  }
}
