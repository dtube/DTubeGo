import 'package:dtube_go/ui/widgets/system/ColorChangeCircularProgressIndicator.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/thirdpartyloader/thirdpartyloader_bloc_full.dart';
import 'package:dtube_go/res/Config/secretConfigValues.dart' as secretConfig;
import 'package:dtube_go/ui/pages/user/Widgets/ConnectYTChannelDialog.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc.dart';
import 'package:dtube_go/bloc/ThirdPartyUploader/ThirdPartyUploader_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsContainer extends StatefulWidget {
  ProfileSettingsContainer({Key? key, required this.userBloc})
      : super(key: key);
  final UserBloc userBloc;

  @override
  _ProfileSettingsContainerState createState() =>
      _ProfileSettingsContainerState();
}

class _ProfileSettingsContainerState extends State<ProfileSettingsContainer>
    with SingleTickerProviderStateMixin {
  List<String> _settingsTypes = ["Common", "Additionals"];
  List<String> _accountTypes = [
    'Content Creator',
    'Community / Group',
    'Investor / Curator',
    'Business Account'
  ];
  List<int> _visitedTabs = [];
  late TabController _tabController;
  late UserBloc _userBloc;
  late User _originalUserData;
  late User _newUserData;

  late TextEditingController _displayNameController;
  late TextEditingController _locationController;
  late TextEditingController _avatarController;
  late TextEditingController _coverImageController;
  late TextEditingController _aboutController;
  late TextEditingController _websiteController;
  late String _accountType;

  bool _userDataLoaded = false;

  // late Map<String, String> currentSettings;

  List<List<String>> _connectedYTChannels = [];

  void addChannelToNewList(List<String> params) {
    setState(() {
      _connectedYTChannels.add([params[0], params[1]]);
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchMyAccountDataEvent());
    _displayNameController = TextEditingController(text: "");
    _locationController = TextEditingController(text: "");
    _avatarController = TextEditingController(text: "");
    _coverImageController = TextEditingController(text: "");
    _aboutController = TextEditingController(text: "");
    _websiteController = TextEditingController(text: "");
    _accountType = "Content Creator";
    BlocProvider.of<TransactionBloc>(context).add(SetInitState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Todo abstract this to dtubeSubAppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 28,
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          BlocBuilder<UserBloc, UserState>(
              bloc: _userBloc,
              builder: (context, state) {
                if (state is UserLoadingState) {
                  return DtubeLogoPulseWithSubtitle(
                    subtitle: "loading settings..",
                    size: 30.w,
                  );
                } else if (state is UserLoadedState) {
                  if (!_userDataLoaded) {
                    _userDataLoaded = true;

                    _originalUserData = state.user;
                    _newUserData = state.user;

                    if (_originalUserData.jsonString?.profile?.about != null) {
                      _aboutController.text =
                          _originalUserData.jsonString!.profile!.about!;
                    }

                    if (_originalUserData.jsonString?.profile?.website !=
                        null) {
                      _websiteController.text =
                          _originalUserData.jsonString!.profile!.website!;
                    }

                    if (_originalUserData.jsonString?.profile?.location !=
                        null) {
                      _locationController.text =
                          _originalUserData.jsonString!.profile!.location!;
                    }

                    if (_originalUserData.jsonString?.profile?.avatar != null) {
                      _avatarController.text =
                          _originalUserData.jsonString!.profile!.avatar!;
                    }
                    if (_originalUserData.jsonString?.profile?.coverImage !=
                        null) {
                      _coverImageController.text =
                          _originalUserData.jsonString!.profile!.coverImage!;
                    }

                    // additionals
                    if (_originalUserData
                            .jsonString?.additionals?.displayName !=
                        null) {
                      _displayNameController.text = _originalUserData
                          .jsonString!.additionals!.displayName!;
                    }
                    if (_originalUserData
                            .jsonString?.additionals?.accountType !=
                        null) {
                      _accountType = _originalUserData
                          .jsonString!.additionals!.accountType!;
                    }
                  }

                  return Column(
                    children: [
                      Align(
                        child: Container(
                          width: 80.w,
                          child: TabBar(
                            unselectedLabelColor: Colors.grey,
                            labelColor: globalAlmostWhite,
                            indicatorColor: globalRed,
                            onTap: (index) {
                              setState(() {
                                if (!_visitedTabs.contains(index)) {
                                  // add page to visited to avoid rebuilding the animation
                                  _visitedTabs.add(index);
                                }
                                //add first tab to visited because it is the default one
                                if (index > 0 && !_visitedTabs.contains(0)) {
                                  // add page to visited to avoid rebuilding the animation
                                  _visitedTabs.add(0);
                                }
                              });
                            },
                            tabs: [
                              Tab(
                                text: _settingsTypes[0],
                              ),
                              Tab(
                                text: _settingsTypes[1],
                              ),
                            ],
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TabBarView(
                            children: [
                              // COMMON SETTINGS
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Basic data",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    ),
                                    DTubeFormCard(
                                      waitBeforeFadeIn:
                                          Duration(milliseconds: 200),
                                      avoidAnimation: _visitedTabs.contains(0),
                                      childs: [
                                        TextFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: _aboutController,
                                          cursorColor: Colors.red,
                                          decoration: new InputDecoration(
                                              labelText: "Bio"),
                                          maxLines: 3,
                                        ),
                                        TextFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: _locationController,
                                          cursorColor: Colors.red,
                                          decoration: new InputDecoration(
                                              labelText: "Location"),
                                          maxLines: 1,
                                        ),
                                        TextFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: _websiteController,
                                          cursorColor: Colors.red,
                                          decoration: new InputDecoration(
                                              labelText: "Website"),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Images",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    ),
                                    BlocProvider<ThirdPartyUploaderBloc>(
                                      create: (BuildContext context) =>
                                          ThirdPartyUploaderBloc(
                                              repository:
                                                  ThirdPartyUploaderRepositoryImpl()),
                                      child: DTubeFormCard(
                                        waitBeforeFadeIn:
                                            Duration(milliseconds: 400),
                                        avoidAnimation:
                                            _visitedTabs.contains(0),
                                        childs: [
                                          BlocBuilder<ThirdPartyUploaderBloc,
                                                  ThirdPartyUploaderState>(
                                              builder: (context, state) {
                                            if (state
                                                is ThirdPartyUploaderUploadingState) {
                                              return ColorChangeCircularProgressIndicator();
                                            }
                                            if (state
                                                is ThirdPartyUploaderUploadedState) {
                                              _avatarController.text =
                                                  state.uploadResponse;
                                              return Column(
                                                children: [
                                                  TextFormField(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                    controller:
                                                        _avatarController,
                                                    cursorColor: Colors.red,
                                                    decoration: new InputDecoration(
                                                        labelText:
                                                            "Avatar Image URL"),
                                                    maxLines: 1,
                                                  ),
                                                  UploadImageButton(),
                                                ],
                                              );
                                            }
                                            return Column(
                                              children: [
                                                TextFormField(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                  controller: _avatarController,
                                                  cursorColor: Colors.red,
                                                  decoration: new InputDecoration(
                                                      labelText:
                                                          "Avatar Image URL"),
                                                  maxLines: 1,
                                                ),
                                                UploadImageButton(),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    BlocProvider<ThirdPartyUploaderBloc>(
                                      create: (BuildContext context) =>
                                          ThirdPartyUploaderBloc(
                                              repository:
                                                  ThirdPartyUploaderRepositoryImpl()),
                                      child: DTubeFormCard(
                                        waitBeforeFadeIn:
                                            Duration(milliseconds: 600),
                                        avoidAnimation:
                                            _visitedTabs.contains(0),
                                        childs: [
                                          BlocBuilder<ThirdPartyUploaderBloc,
                                                  ThirdPartyUploaderState>(
                                              builder: (context, state) {
                                            if (state
                                                is ThirdPartyUploaderUploadingState) {
                                              return ColorChangeCircularProgressIndicator();
                                            }
                                            if (state
                                                is ThirdPartyUploaderUploadedState) {
                                              _coverImageController.text =
                                                  state.uploadResponse;
                                              return Column(
                                                children: [
                                                  TextFormField(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                    cursorColor: Colors.red,
                                                    controller:
                                                        _coverImageController,
                                                    decoration:
                                                        new InputDecoration(
                                                            labelText:
                                                                "Cover Image URL"),
                                                    maxLines: 1,
                                                  ),
                                                  UploadImageButton(),
                                                ],
                                              );
                                            }
                                            return Column(
                                              children: [
                                                TextFormField(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                  controller:
                                                      _coverImageController,
                                                  cursorColor: Colors.red,
                                                  decoration:
                                                      new InputDecoration(
                                                          labelText:
                                                              "Cover Image URL"),
                                                  maxLines: 1,
                                                ),
                                                UploadImageButton(),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    )
                                  ],
                                ),
                              ),
                              // ADDITIONAL SETTINGS
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 8.0),
                                      child: Text(
                                        "Custom Data",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    ),
                                    DTubeFormCard(
                                      waitBeforeFadeIn:
                                          Duration(milliseconds: 200),
                                      avoidAnimation: _visitedTabs.contains(1),
                                      childs: [
                                        TextFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: _displayNameController,
                                          cursorColor: Colors.red,
                                          decoration: new InputDecoration(
                                              labelText: "Custom Display Name"),
                                          maxLines: 1,
                                        ),
                                        DropdownButtonFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          decoration: InputDecoration(
                                            labelText: 'Account Type',
                                          ),
                                          value: _accountType,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _accountType =
                                                  newValue.toString();
                                              // widget.justSaved = false;
                                            });
                                          },
                                          items: _accountTypes.map((option) {
                                            return DropdownMenuItem(
                                              child: new Text(option),
                                              value: option,
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Connected YT channels",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    DTubeFormCard(
                                        waitBeforeFadeIn:
                                            Duration(milliseconds: 200),
                                        avoidAnimation:
                                            _visitedTabs.contains(1),
                                        childs: [
                                          InputChip(
                                            isEnabled: globals.keyPermissions
                                                .contains(6),
                                            label: Text("connect to youtube"),
                                            backgroundColor: globalRed,
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    BlocProvider<
                                                        ThirdPartyMetadataBloc>(
                                                  create: (BuildContext
                                                          context) =>
                                                      ThirdPartyMetadataBloc(
                                                          repository:
                                                              ThirdPartyMetadataRepositoryImpl()),
                                                  child: ConnectYTChannelDialog(
                                                      user: _originalUserData,
                                                      connectCallback:
                                                          addChannelToNewList),
                                                ),
                                              );
                                            },
                                          ),
                                          _connectedYTChannels.length > 0
                                              ? Text(
                                                  "new added yt channels (saving still required):")
                                              : Container(),
                                          ListView.builder(
                                              key: new PageStorageKey(
                                                  'newytchannels'),
                                              //addAutomaticKeepAlives: true,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount:
                                                  _connectedYTChannels.length,
                                              itemBuilder: (ctx, pos) {
                                                return Text(pos.toString() +
                                                    ': ' +
                                                    _connectedYTChannels[pos]
                                                        [0]);
                                              }),
                                          Text(
                                              "your connected youtube channels:"),
                                          _originalUserData
                                                          .jsonString !=
                                                      null &&
                                                  _originalUserData.jsonString!
                                                          .additionals !=
                                                      null &&
                                                  _originalUserData
                                                          .jsonString!
                                                          .additionals!
                                                          .ytchannels !=
                                                      null
                                              ? ListView.builder(
                                                  key: new PageStorageKey(
                                                      'linkedytchannels'),
                                                  //addAutomaticKeepAlives: true,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  itemCount: _originalUserData
                                                      .jsonString!
                                                      .additionals!
                                                      .ytchannels!
                                                      .length,
                                                  itemBuilder: (ctx, pos) {
                                                    return Text(pos.toString() +
                                                        ': ' +
                                                        secretConfig.decryptYTChannelId(
                                                            _originalUserData,
                                                            _originalUserData
                                                                    .jsonString!
                                                                    .additionals!
                                                                    .ytchannels![
                                                                pos]));
                                                  })
                                              : Container()
                                        ])
                                  ],
                                ),
                              ),
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is UserErrorState) {
                  return buildErrorUi(state.message);
                }
                return DtubeLogoPulseWithSubtitle(
                  subtitle: "loading settings..",
                  size: 30.w,
                );
              }),
          // Save button
          Align(
              alignment: Alignment.topRight,
              child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                if (state is TransactionPreprocessingState &&
                    state.txType == 6) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(0, 1.h, 4.w, 0),
                      child: DTubeLogoPulse(size: 9.w));
                }

                if (state is TransactionInitialState) {
                  return GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 4.w, 0),
                        child: HeartBeat(
                          preferences: AnimationPreferences(
                              autoPlay: AnimationPlayStates.Loop,
                              offset: Duration(seconds: 3),
                              duration: Duration(seconds: 1)),
                          child: DecoratedIcon(
                            FontAwesomeIcons.floppyDisk,
                            color: globals.keyPermissions.contains(6)
                                ? globalAlmostWhite
                                : Colors.grey,
                            size: 8.w,
                            shadows: [
                              BoxShadow(
                                blurRadius: 24.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: !globals.keyPermissions.contains(6)
                          ? null
                          : () async {
                              List<String> ytChannels = [];
                              if (_originalUserData.jsonString != null &&
                                  _originalUserData.jsonString!.additionals!
                                          .ytchannels !=
                                      null) {
                                ytChannels = _originalUserData
                                    .jsonString!.additionals!.ytchannels!;
                              }
                              if (_connectedYTChannels.length > 0) {
                                for (List<String> item
                                    in _connectedYTChannels) {
                                  // add encrypted yt channel id if not already in list
                                  if (!ytChannels.contains(item[1])) {
                                    ytChannels.add(item[1]);
                                  }
                                }
                              }

                              User _saveUserData = new User(
                                  sId: _originalUserData.sId,
                                  name: _originalUserData.name,
                                  pub: _originalUserData.pub,
                                  balance: _originalUserData.balance,
                                  keys: _originalUserData.keys,
                                  alreadyFollowing: false,
                                  jsonString: new JsonString(
                                      node: _originalUserData.jsonString?.node,
                                      profile: new Profile(
                                          about: _aboutController.text,
                                          avatar: _avatarController.text,
                                          coverImage: _coverImageController
                                              .text,
                                          hive: _originalUserData
                                              .jsonString?.profile?.hive,
                                          location: _locationController.text,
                                          steem: _originalUserData
                                              .jsonString?.profile?.steem,
                                          website: _websiteController.text),
                                      additionals: new Additionals(
                                          accountType: _accountType,
                                          displayName:
                                              _displayNameController.text,
                                          blocking:
                                              _originalUserData.jsonString !=
                                                          null &&
                                                      _originalUserData
                                                              .jsonString!
                                                              .additionals !=
                                                          null
                                                  ? _originalUserData
                                                      .jsonString!
                                                      .additionals!
                                                      .blocking
                                                  : [],
                                          ytchannels: ytChannels)));

                              BlocProvider.of<TransactionBloc>(context).add(
                                  ChangeProfileData(_saveUserData, context));
                              // ignore: empty_statements
                            });
                } else {
                  return Container();
                }
              })),
        ],
      ),
      //Container()
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class UploadImageButton extends StatefulWidget {
  UploadImageButton({Key? key}) : super(key: key);

  @override
  State<UploadImageButton> createState() => _UploadImageButtonState();
}

class _UploadImageButtonState extends State<UploadImageButton> {
  Future<String> getAndUploadFile() async {
    BlocProvider.of<ThirdPartyUploaderBloc>(context)
        .add(SetThirdPartyUploaderInitState());
    XFile? _pickedFile;

    final _picker = ImagePicker();
    _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      BlocProvider.of<ThirdPartyUploaderBloc>(context)
          .add(UploadFile(filePath: _pickedFile.path));
      return _pickedFile.path;
    }
    return "no image selected";
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          String imagePath = await getAndUploadFile();
        },
        child: Text("upload"));
  }
}
