import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_togo/ui/pages/post/postDetailPageV2.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:dtube_togo/style/ThemeData.dart';

import 'package:flutter/services.dart';

import 'dart:io';
import 'package:disk_space/disk_space.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/ui/pages/post/players/BetterPlayer.dart';
import 'package:dtube_togo/ui/pages/post/players/YTplayerIframe.dart';

import 'package:dtube_togo/utils/secureStorage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  late TransactionBloc _txBloc;
  late HivesignerBloc _hivesignerBloc;

  _UploadFormState(this.stateUploadData);

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();
  bool _formIsFilled = false;

  File? _image;
  String _imageHints = "";
  File? _video;
  final _picker = ImagePicker();
  FocusNode _titleFocus = new FocusNode();
  FocusNode _tagFocus = new FocusNode();
  late UserBloc _userBloc;
  late SettingsBloc _settingsBloc;
  final _formKey = GlobalKey<FormState>();

  void childCallback(String videoPath) {
    setState(() {
      _video = File(videoPath);
      stateUploadData.localVideoFile = true;
      stateUploadData.videoLocation = videoPath;
    });
  }

  void navigateToPostDetailPage(BuildContext context) async {
    String? _username = await sec.getUsername();
    stateUploadData.uploaded = true;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostDetailPage(
        author: _username!,
        link: stateUploadData.link,
        recentlyUploaded: true,
        directFocus: "noAutoplay",
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = stateUploadData.title;
    _descController.text = stateUploadData.description;
    _tagController.text = stateUploadData.tag;

    _userBloc = BlocProvider.of<UserBloc>(context);
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _hivesignerBloc = BlocProvider.of<HivesignerBloc>(context);

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

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (builder) => CameraScreen(
        //               callback: childCallback,
        //             )));
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
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, stateUpload) {
        if (stateUpload is TransactionSent) {
          if (stateUploadData.crossPostToHive) {
            _hivesignerBloc.add(SendPostToHive(
                postTitle: stateUploadData.title,
                postBody: stateUploadData.description,
                permlink: stateUploadData.link,
                dtubeUrl: stateUploadData.link,
                thumbnailUrl: stateUploadData.thumbnailLocation,
                videoUrl: stateUploadData.videoSourceHash,
                storageType: "ipfs",
                tag: stateUploadData.tag));
          }
          navigateToPostDetailPage(context);
        }
      },
      child: BlocListener<UserBloc, UserState>(
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
                  _formIsFilled ? imagePreview() : SizedBox(height: 50),
                  _formIsFilled
                      ? Column(
                          children: [
                            moreSettings(),
                            SizedBox(height: 8),
                            InputChip(
                              backgroundColor: globalRed,
                              label: Text("upload",
                                  style: TextStyle(fontSize: 24)),
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
                        _video == null ? "record video" : "record a new video"),
                  ],
                ),
                onPressed: () {
                  getFile(true, true);
                },
              ),
            ],
          ),
          stateUploadData.videoLocation != ""
              // TODO: react on possibly wrong orientation with videos in landscape
              // e.g. open issue on https://github.com/jhomlala/betterplayer/issues
              ? BP(
                  videoUrl: _video!.path,
                  looping: false,
                  autoplay: false,
                  localFile: true,
                  controls: true,
                  //key: UniqueKey(),
                  usedAsPreview: true,
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      );
    }
  }

  Widget basicData() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text("2. Basic information", style: TextStyle(fontSize: 18)),
          TextFormField(
            cursorColor: globalRed,
            decoration: new InputDecoration(labelText: "Title"),
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
            decoration: new InputDecoration(labelText: "Description"),
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
            decoration: new InputDecoration(labelText: "Tag"),
            controller: _tagController,
            focusNode: _tagFocus,
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
          Text("3. Thumbnail", style: TextStyle(fontSize: 18)),
          InputChip(
            label: Text(stateUploadData.thumbnailLocation == ""
                ? "pick a custom thumbnail"
                : "change thumbnail"),
            onPressed: () {
              getFile(false, false);
            },
          ),
          stateUploadData.thumbnailLocation != ""
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
                label: Text('original content'),
                labelStyle: TextStyle(color: Colors.white),
                avatar: stateUploadData.originalContent
                    ? FaIcon(
                        FontAwesomeIcons.check,
                        size: 15,
                      )
                    : null,
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
                label: Text('nsfw content'),
                labelStyle: TextStyle(color: Colors.white),
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
                label: Text('unlist video'),
                labelStyle: TextStyle(color: Colors.white),
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
            ChoiceChip(
                selected: stateUploadData.crossPostToHive,
                label: Text('cross-post to hive'),
                labelStyle: TextStyle(color: Colors.white),
                avatar: stateUploadData.crossPostToHive
                    ? FaIcon(
                        FontAwesomeIcons.check,
                        size: 15,
                      )
                    : null,
                backgroundColor: Colors.grey.withAlpha(30),
                selectedColor: Colors.green[700],
                onSelected: (bool selected) {
                  setState(() {
                    stateUploadData.crossPostToHive =
                        !stateUploadData.crossPostToHive;
                  });
                }),
          ],
        ),
        Row(
          children: [
            Container(
              width: deviceWidth * 0.6,
              child: Slider(
                min: 1.0,
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
            Column(
              children: [
                Text(
                  "initial vote: " +
                      stateUploadData.vpPercent.floor().toString() +
                      '%',
                  style: Theme.of(context).textTheme.headline5,
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
            )
          ],
        ),
        SizedBox(
          width: 8,
        ),
        Row(
          children: [
            Container(
              width: deviceWidth * 0.6,
              child: Slider(
                min: 0.0,
                max: (stateUploadData.dtcBalance + 0.0) / 100,
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
            Column(
              children: [
                Text(
                  "promote: " +
                      stateUploadData.burnDtc.floor().toString() +
                      ' DTC',
                  style: Theme.of(context).textTheme.headline5,
                ),
                // TODO: calculate approx. VP of burn
                // Text(
                //   '(' +
                //       ((stateUploadData.vpBalance /
                //                   100 *
                //                   stateUploadData.vpPercent) /
                //               1000)
                //           .toStringAsFixed(2) +
                //       'K VP)',
                //   style: TextStyle(fontSize: 14.0),
                // ),
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
