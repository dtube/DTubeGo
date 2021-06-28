import 'package:flutter/services.dart';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/post/players/BetterPlayer.dart';
import 'package:dtube_togo/ui/pages/post/players/YTplayerIframe.dart';
import 'package:dtube_togo/utils/randomPermlink.dart';
import 'package:dtube_togo/utils/secureStorage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class UploadData {
  String author;
  String link;
  String title;
  String description;
  String tag;
  double vpPercent;
  int vpBalance;
  double burnDtc;
  int dtcBalance;
  Duration duration;
  String thumbnailLocation;
  bool localThumbnail;
  String videoLocation;
  bool localVideoFile;
  bool originalContent;
  bool nSFWContent;
  bool unlistVideo;

  String videoSourceHash;
  String video240pHash;
  String video480pHash;
  String videoSpriteHash;
  String thumbnail640Hash;
  String thumbnail210Hash;

  UploadData({
    required this.link,
    required this.author,
    required this.title,
    required this.description,
    required this.tag,
    required this.vpPercent,
    required this.vpBalance,
    required this.burnDtc,
    required this.dtcBalance,
    required this.duration,
    required this.thumbnailLocation,
    required this.localThumbnail,
    required this.videoLocation,
    required this.localVideoFile,
    required this.originalContent,
    required this.nSFWContent,
    required this.unlistVideo,
    required this.videoSourceHash,
    required this.video240pHash,
    required this.video480pHash,
    required this.videoSpriteHash,
    required this.thumbnail640Hash,
    required this.thumbnail210Hash,
  });
}

class UploadForm extends StatefulWidget {
  late UploadData uploadData;
  final Function(UploadData) callback;
  UploadForm({Key? key, required this.uploadData, required this.callback})
      : super(key: key);

  @override
  _UploadFormState createState() => _UploadFormState(uploadData);
}

class _UploadFormState extends State<UploadForm> {
  late UploadData stateUploadData;
  _UploadFormState(this.stateUploadData);

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();
  File? _image;
  String _imageHints = "";
  String _videoHints = "";
  File? _video;
  final _picker = ImagePicker();
  FocusNode _titleFocus = new FocusNode();
  FocusNode _tagFocus = new FocusNode();
  late UserBloc _userBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _titleController.text = stateUploadData.title;
    _descController.text = stateUploadData.description;
    _tagController.text = stateUploadData.tag;

    _userBloc = BlocProvider.of<UserBloc>(context);
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    _userBloc.add(FetchDTCVPEvent());
    _settingsBloc.add(FetchSettingsEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future getFile(bool video, bool camera) async {
    PickedFile? _pickedFile;
    if (video) {
      if (camera) {
        // TODO: rework the orientation stuff...
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
        _pickedFile = await _picker.getVideo(
            source: ImageSource
                .camera); // TODO: request needed permissions for camera
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } else {
        _pickedFile = await _picker.getVideo(source: ImageSource.gallery);
      }
      _titleFocus.requestFocus();
    } else {
      _pickedFile = await _picker.getImage(source: ImageSource.gallery);
      if (_pickedFile != null) {
        var _tempImage = File(_pickedFile.path);
        var decodedImage =
            await decodeImageFromList(_tempImage.readAsBytesSync());
        print(decodedImage.width);
        print(decodedImage.height);
        if (decodedImage.height != decodedImage.width / 16 * 9) {
          _imageHints =
              "We recommend to use a thumbnail with an aspect ration of 16:9. Yours is different.";
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
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, stateSettings) {
          if (stateSettings is SettingsLoadedState) {
            setState(() {
              stateUploadData.vpPercent = double.parse(
                  stateSettings.settings[settingKey_defaultVotingWeight]!);
              stateUploadData.author =
                  stateSettings.settings[authKey_usernameKey]!;
              stateUploadData.link = randomPermlink(11);
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
                SizedBox(height: 8),
                stateUploadData.videoLocation != ""
                    ? basicData()
                    : SizedBox(height: 50),
                SizedBox(height: 8),
                _titleController.text != "" &&
                        _descController.text != "" &&
                        _tagController.text != ""
                    ? imagePreview()
                    : SizedBox(height: 50),
                _titleController.text != "" &&
                        _descController.text != "" &&
                        _tagController.text != "" &&
                        stateUploadData.thumbnailLocation != null
                    ? Column(
                        children: [
                          moreSettings(),
                          SizedBox(height: 8),
                          InputChip(
                            label:
                                Text("upload", style: TextStyle(fontSize: 24)),
                            onPressed: () {
                              widget.callback(stateUploadData);
                            },
                          )
                        ],
                      )
                    : SizedBox(height: 50),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget videoPreview() {
    if (!stateUploadData.localVideoFile) {
      _tagFocus.requestFocus();
      return YTPlayerIFrame(
        videoUrl: stateUploadData.videoLocation,
        autoplay: false,
      );
    } else {
      return Column(
        children: [
          Text("1. Video file", style: TextStyle(fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InputChip(
                label: Row(
                  children: [
                    Icon(FontAwesomeIcons.solidFolderOpen),
                    SizedBox(width: 8),
                    Text(_video == null ? "pick video" : "change video file"),
                  ],
                ),
                onPressed: () {
                  getFile(true, false);
                },
              ),
              InputChip(
                label: Row(
                  children: [
                    Icon(FontAwesomeIcons.video),
                    SizedBox(width: 8),
                    Text(
                        _video == null ? "record video" : "record another one"),
                  ],
                ),
                onPressed: () {
                  getFile(true, true);
                },
              ),
            ],
          ),
          stateUploadData.videoLocation != ""
              ? BP(
                  videoUrl: _video!.path,
                  looping: false,
                  autoplay: false,
                  localFile: true,
                  controls: true,
                  // key: UniqueKey(), // TODO: fix "change video file" not showing new file - WITHOUT the need of a UniqueKey()
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      );
    }
  }

  Widget basicData() {
    return Column(
      children: [
        Text("2. Basic information", style: TextStyle(fontSize: 18)),
        TextFormField(
          decoration: new InputDecoration(labelText: "Title"),
          controller: _titleController,
          focusNode: _titleFocus,
        ),
        TextFormField(
          maxLines: 5,
          decoration: new InputDecoration(labelText: "Description"),
          controller: _descController,
        ),
        TextFormField(
          decoration: new InputDecoration(labelText: "Tag"),
          controller: _tagController,
          focusNode: _tagFocus,
        ),
      ],
    );
  }

  Widget imagePreview() {
    return Center(
      child: Column(
        children: [
          Text("3. Thumbnail", style: TextStyle(fontSize: 18)),
          InputChip(
            label: Text(stateUploadData.thumbnailLocation == null
                ? "pick your thumbnail next!"
                : "change thumbnail"),
            onPressed: () {
              getFile(false, false);
            },
          ),
          stateUploadData.thumbnailLocation != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 250,
                        child: stateUploadData.localThumbnail
                            ? Image.file(
                                File(stateUploadData.thumbnailLocation))
                            : CachedNetworkImage(
                                imageUrl: stateUploadData.thumbnailLocation)),
                    Container(width: 150, child: Text(_imageHints))
                  ],
                )
              : SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget moreSettings() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    // title: Text("original content"),
                    value: stateUploadData.originalContent,
                    // controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (dynamic value) {
                      setState(() {
                        stateUploadData.originalContent = value;
                      });
                    }),
                Text("original content"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    //title: Text("NSFW content"),
                    value: stateUploadData.nSFWContent,
                    //controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (dynamic value) {
                      setState(() {
                        stateUploadData.nSFWContent = value;
                      });
                    }),
                Text("NSFW content"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    //title: Text("unlist the video"),
                    value: stateUploadData.unlistVideo,
                    // controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (dynamic value) {
                      setState(() {
                        stateUploadData.unlistVideo = value;
                      });
                    }),
                Text("unlist the video"),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text("selfvote"),
                SfSlider.vertical(
                  min: 1.0,
                  max: 100.0,
                  value: stateUploadData.vpPercent,
                  interval: 10,
                  //showTicks: true,
                  numberFormat: NumberFormat(''),
                  // showLabels: true,

                  enableTooltip: true,
                  activeColor: Colors.red,
                  //minorTicksPerInterval: 10,
                  showDivisors: true,
                  onChanged: (dynamic value) {
                    setState(() {
                      stateUploadData.vpPercent = value;
                    });
                  },
                ),
                Text(
                  stateUploadData.vpPercent.floor().toString() + '%',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  '(' +
                      ((stateUploadData.vpBalance /
                                  100 *
                                  stateUploadData.vpPercent) /
                              1000)
                          .toStringAsFixed(2) +
                      'K VP)',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("promote"),
                  SfSlider.vertical(
                    min: 0.0,
                    max: (stateUploadData.dtcBalance + 0.0) / 100,
                    value: stateUploadData.burnDtc,
                    interval: 50,
                    //showTicks: true,
                    numberFormat: NumberFormat(''),
                    // showLabels: true,
                    enableTooltip: true,
                    activeColor: Colors.red,
                    //minorTicksPerInterval: 10,
                    showDivisors: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        stateUploadData.burnDtc = value;
                      });
                    },
                  ),
                  Text("burn"),
                  Text(
                    stateUploadData.burnDtc.floor().toString() + ' DTC',
                    style: TextStyle(fontSize: 18.0),
                  ),

                  // TODO: calculate approx. VP of burn
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
