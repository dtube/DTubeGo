import 'package:decorated_icon/decorated_icon.dart';
import 'package:dtube_togo/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_response_model.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/pages/settings/HiveSignerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class ProfileSettingsContainer extends StatefulWidget {
  ProfileSettingsContainer({Key? key}) : super(key: key);

  @override
  _ProfileSettingsContainerState createState() =>
      _ProfileSettingsContainerState();
}

class _ProfileSettingsContainerState extends State<ProfileSettingsContainer>
    with SingleTickerProviderStateMixin {
  List<String> _settingsTypes = ["Common", "Additionals"];
  List<String> _accountTypes = [
    'Content Creator',
    'Investor / Curator',
    'Business Account'
  ];

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

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(FetchMyAccountDataEvent()); // statements;
    _displayNameController = TextEditingController(text: "");
    _locationController = TextEditingController(text: "");
    _avatarController = TextEditingController(text: "");
    _coverImageController = TextEditingController(text: "");
    _aboutController = TextEditingController(text: "");
    _websiteController = TextEditingController(text: "");
    _accountType = "Content Creator";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserLoadingState) {
              return Center(
                child:
                    DTubeLogoPulse(size: MediaQuery.of(context).size.width / 3),
              );
            } else if (state is UserLoadedState) {
              if (!_userDataLoaded) {
                _userDataLoaded = true;
                // set textfields to content of user
                _originalUserData = state.user;
                _newUserData = state.user;
                // basic
                if (_originalUserData.jsonString?.profile?.about != null) {
                  _aboutController.text =
                      _originalUserData.jsonString!.profile!.about!;
                }

                if (_originalUserData.jsonString?.profile?.website != null) {
                  _websiteController.text =
                      _originalUserData.jsonString!.profile!.website!;
                }

                if (_originalUserData.jsonString?.profile?.location != null) {
                  _locationController.text =
                      _originalUserData.jsonString!.profile!.location!;
                }

                if (_originalUserData.jsonString?.profile?.avatar != null) {
                  _avatarController.text =
                      _originalUserData.jsonString!.profile!.avatar!;
                }
                if (_originalUserData.jsonString?.profile?.coverImage != null) {
                  _coverImageController.text =
                      _originalUserData.jsonString!.profile!.coverImage!;
                }

                // additionals
                if (_originalUserData.jsonString?.additionals?.displayName !=
                    null) {
                  _displayNameController.text =
                      _originalUserData.jsonString!.additionals!.displayName!;
                }
                if (_originalUserData.jsonString?.additionals?.accountType !=
                    null) {
                  _accountType =
                      _originalUserData.jsonString!.additionals!.accountType!;
                }
              }

              return Column(
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: globalAlmostWhite,
                    indicatorColor: globalRed,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Basic data",
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                                DTubeFormCard(
                                  childs: [
                                    TextFormField(
                                      controller: _aboutController,
                                      decoration:
                                          new InputDecoration(labelText: "Bio"),
                                      maxLines: 3,
                                    ),
                                    TextFormField(
                                      controller: _locationController,
                                      decoration: new InputDecoration(
                                          labelText: "Location"),
                                      maxLines: 1,
                                    ),
                                    TextFormField(
                                      controller: _websiteController,
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
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                                DTubeFormCard(
                                  childs: [
                                    TextFormField(
                                      controller: _avatarController,
                                      decoration: new InputDecoration(
                                          labelText: "Avatar Image URL"),
                                      maxLines: 1,
                                    ),
                                    TextFormField(
                                      controller: _coverImageController,
                                      decoration: new InputDecoration(
                                          labelText: "Channel Banner URL"),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 8.0),
                                  child: Text("Custom Type",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                ),
                                DTubeFormCard(
                                  childs: [
                                    TextFormField(
                                      controller: _displayNameController,
                                      decoration: new InputDecoration(
                                          labelText: "Custom Display Name"),
                                      maxLines: 1,
                                    ),
                                    DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        //filled: true,
                                        //fillColor: Hexcolor('#ecedec'),
                                        labelText: 'Account Type',
                                        //border: new CustomBorderTextFieldSkin().getSkin(),
                                      ),
                                      value: _accountType,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _accountType = newValue.toString();
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
            return Center(
                child: DTubeLogoPulse(
                    size: MediaQuery.of(context).size.width / 3));
          }),
          // Save button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 24.0, 80),
                child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                  if (state is TransactionPreprocessingState &&
                      state.txType == 6) {
                    return DTubeLogoPulse(size: 40);
                  }
                  if (state is TransactionSent) {
                    print("test");
                    _userDataLoaded = false;
                    BlocProvider.of<TransactionBloc>(context)
                        .add(SetInitState());
                    _userBloc.add(FetchMyAccountDataEvent()); // statements;
                  }
                  if (state is TransactionInitialState) {
                    return GestureDetector(
                        child: DecoratedIcon(
                          FontAwesomeIcons.save,
                          size: 40,
                          shadows: [
                            BoxShadow(
                              blurRadius: 24.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        onTap: () async {
                          // _newUserData.jsonString.profile.about =
                          //     _aboutController.text;

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
                                      coverImage: _coverImageController.text,
                                      hive: _originalUserData
                                          .jsonString!.profile?.hive,
                                      location: _locationController.text,
                                      steem: _originalUserData
                                          .jsonString!.profile?.steem,
                                      website: _websiteController.text),
                                  additionals: new Additionals(
                                      accountType: _accountType,
                                      displayName:
                                          _displayNameController.text)));

                          BlocProvider.of<TransactionBloc>(context)
                              .add(ChangeProfileData(_saveUserData));
                        });
                  }

                  return Text("test");
                })),
          ),
        ],
      ),
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
