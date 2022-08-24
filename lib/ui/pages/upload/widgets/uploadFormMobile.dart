import 'package:dtube_go/res/Config/UploadConfigValues.dart';
import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:dtube_go/ui/pages/upload/dialogs/HivePostCooldownDialog.dart';
import 'package:dtube_go/ui/pages/upload/dialogs/UploadTermsDialog.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/UploadStartedDialog.dart';
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

class UploadFormMobile extends StatefulWidget {
  UploadFormMobile(
      {Key? key,
      required this.uploadData,
      required this.callback,
      required this.preset})
      : super(key: key);

  final UploadData uploadData;
  final Function(UploadData) callback;
  final Preset preset;

  @override
  _UploadFormMobileState createState() => _UploadFormMobileState(uploadData);
}

class _UploadFormMobileState extends State<UploadFormMobile> {
  _UploadFormMobileState(this.stateUploadData);
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
  bool _termsAccepted = false;
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
                      height: 2.h,
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
                  .settings[sec.settingKey_DefaultUploadVotingWeigth]!);

              stateUploadData.nSFWContent =
                  stateSettings.settings[sec.settingKey_DefaultUploadNSFW]! ==
                      "true";

              stateUploadData.originalContent =
                  stateSettings.settings[sec.settingKey_DefaultUploadOC]! ==
                      "true";

              stateUploadData.unlistVideo =
                  stateSettings.settings[sec.settingKey_DefaultUploadUnlist]! ==
                      "true";

              stateUploadData.crossPostToHive = stateSettings
                      .settings[sec.settingKey_DefaultUploadCrosspost]! ==
                  "true";

              if (stateSettings.settings[sec.settingKey_hiveSignerUsername] !=
                      null &&
                  stateSettings.settings[sec.settingKey_hiveSignerUsername] !=
                      "") {
                DateTime requestedOn = DateTime.parse(stateSettings.settings[
                    sec.settingKey_hiveSignerAccessTokenRequestedOn]!);
                DateTime invalidOn = requestedOn.add(Duration(
                    seconds: int.parse(stateSettings.settings[
                        sec.settingKey_hiveSignerAccessTokenExpiresIn]!)));
                if (invalidOn.isAfter(DateTime.now())) {
                  stateUploadData.crossPostToHive = true;
                  hiveSignerValid = true;
                  hiveSignerUsername = stateSettings
                      .settings[sec.settingKey_hiveSignerUsername]!;
                }
              }
              lastPostWithinCooldown =
                  stateSettings.settings[sec.settingKey_HiveStillInCooldown] ==
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
                              SizedBox(height: 1.h),
                              stateUploadData.videoLocation != ""
                                  ? basicData()
                                  : SizedBox(height: 5.h),
                              SizedBox(height: 1.h),
                            ])
                      : Container(),
                ),
                _formIsFilled
                    ? DTubeFormCard(
                        avoidAnimation: true,
                        waitBeforeFadeIn: Duration(seconds: 0),
                        childs: [
                            imagePreview(),
                            Column(
                              children: [
                                moreSettings(),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          value: _termsAccepted,
                                          onChanged: (value) {
                                            setState(() {
                                              _termsAccepted = !_termsAccepted;
                                            });
                                          }),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("I have read & agree to the "),
                                          GestureDetector(
                                            child: Text(
                                              "Terms for UGC of DTube Go",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(color: globalRed),
                                            ),
                                            onTap: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        UploadTermsDialog(
                                                  agreeToTermsCallback: () {
                                                    setState(() {
                                                      _termsAccepted =
                                                          !_termsAccepted;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                    "Info: direct uploads could take some time to get pinned on the ipfs network. That means they need a few minutes to be playable after the initial upload.",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                InputChip(
                                  backgroundColor: globalRed,
                                  label: Text("upload",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                  onPressed: _formIsFilled && _termsAccepted
                                      ? () async {
                                          int _hiveCooldown = await sec
                                              .getSecondsUntilHiveCooldownEnds();
                                          if (stateUploadData.crossPostToHive &&
                                              _hiveCooldown > 0) {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  HivePostCooldownDetectedDialog(
                                                cooldown: _hiveCooldown,
                                              ),
                                            );
                                          } else {
                                            widget.callback(stateUploadData);

                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  UploadStartedDialog(),
                                            );
                                          }
                                        }
                                      : null,
                                ),
                              ],
                            )
                          ])
                    : Container(),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget videoPreview() {
    // if it is a youtube video
    if (!stateUploadData.localVideoFile &&
        stateUploadData.videoSourceHash == "") {
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
      // if it is a custom self hosted video
    } else if (!stateUploadData.localVideoFile &&
        stateUploadData.videoSourceHash != "") {
      // _tagFocus.requestFocus();
      checkIfFormIsFilled();
      String _videoUrl =
          ["IPFS", "Skynet"].contains(stateUploadData.videoLocation)
              ? (stateUploadData.videoLocation == "IPFS"
                      ? UploadConfig.ipfsVideoUrl
                      : UploadConfig.siaVideoUrl) +
                  (stateUploadData.video240pHash != ""
                      ? stateUploadData.video240pHash
                      : stateUploadData.video480pHash != ""
                          ? stateUploadData.video480pHash
                          : stateUploadData.videoSourceHash)
              : _video!.path;

      return Container(
        width: 95.w,
        child: DTubeFormCard(
            avoidAnimation: true,
            waitBeforeFadeIn: Duration(seconds: 0),
            childs: [
              ChewiePlayer(
                videoUrl: _videoUrl,
                looping: false,
                autoplay: false,
                localFile: false,
                controls: true,
                //key: UniqueKey(),
                usedAsPreview: true,
                allowFullscreen: false,
                portraitVideoPadding: 50.0,
                videocontroller: _videocontroller,
                placeholderWidth: 100.w,
                placeholderSize: 40.w,
              ),
            ]),
      );
    } else {
      // if none of above -> file picker
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
                              : FontAwesomeIcons.arrowRotateLeft),
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
                            ? ChewiePlayer(
                                videoUrl: stateUploadData.videoLocation ==
                                        "IPFS"
                                    ? UploadConfig.ipfsVideoUrl +
                                        stateUploadData.videoSourceHash
                                    : stateUploadData.videoLocation == "Skynet"
                                        ? UploadConfig.siaVideoUrl +
                                            stateUploadData.videoSourceHash
                                        : _video!.path,
                                looping: false,
                                autoplay: false,
                                localFile:
                                    stateUploadData.videoSourceHash == "",
                                controls: true,
                                //key: UniqueKey(),
                                usedAsPreview: true,
                                allowFullscreen: false,
                                portraitVideoPadding: 50.0,
                                videocontroller: _videocontroller,
                                placeholderWidth: 100.w,
                                placeholderSize: 40.w,
                              )
                            : SizedBox(height: 0),
                        InputChip(
                            selectedColor: globalRed,
                            label: Text(
                              (showVideoPreview ? 'hide' : 'show') + " preview",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            avatar: FaIcon(showVideoPreview
                                ? FontAwesomeIcons.squareCheck
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
          Container(
            width: 95.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: _tagController.text != "DTubeGo-Moments",
                  child: Container(
                    width: 40.w,
                    child: TextFormField(
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
                        FilteringTextInputFormatter.allow(
                            (RegExp("[a-zA-Z0-9]")))
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
                  ),
                ),
                ChoiceChip(
                    selected: _tagController.text == "DTubeGo-Moments",
                    label: Text('add to moments',
                        style: Theme.of(context).textTheme.bodyText1),
                    labelStyle: TextStyle(color: globalAlmostWhite),
                    avatar: _tagController.value.text == "DTubeGo-Moments"
                        ? FaIcon(
                            FontAwesomeIcons.check,
                            size: 15,
                          )
                        : null,
                    backgroundColor: Colors.grey.withAlpha(30),
                    selectedColor: Colors.green[700],
                    onSelected: (bool selected) {
                      setState(() {
                        if (_tagController.text != "DTubeGo-Moments") {
                          _tagController.text = "DTubeGo-Moments";
                          stateUploadData.tag = _tagController.text;
                          checkIfFormIsFilled();
                        } else {
                          _tagController.text = "";
                          stateUploadData.tag = _tagController.text;
                          checkIfFormIsFilled();
                        }
                      });
                    }),
              ],
            ),
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
            Visibility(
              visible:
                  false, // to get accepted by google we had to remove this option
              child: ChoiceChip(
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
                      stateUploadData.nSFWContent =
                          !stateUploadData.nSFWContent;
                    });
                  }),
            ),
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
