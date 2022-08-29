import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/hivesigner/hivesigner_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/UnsortedCustomWidgets.dart';
import 'package:dtube_go/ui/pages/settings/HiveSignerForm.dart';
import 'package:dtube_go/ui/pages/settings/PinCodeDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:textfield_tags/textfield_tags.dart';

class SettingsTabContainerMobile extends StatefulWidget {
  SettingsTabContainerMobile({Key? key}) : super(key: key);

  @override
  _SettingsTabContainerMobileState createState() =>
      _SettingsTabContainerMobileState();
}

class _SettingsTabContainerMobileState extends State<SettingsTabContainerMobile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SettingsBloc _settingsBloc;
  late Map<String, String> settings;

  late double _defaultVote;
  late double _defaultVoteComments;
  late double _defaultTip;
  late double _defaultTipComments;

  late String _showHidden;
  late String _showNsfw;
  late String _hiveUsername;
  late String _hiveDefaultCommunity;
  late List<String> _hiveDefaultTags;
  late TextEditingController _hiveDefaultCommunityController;
  //late TextEditingController _hiveDefaultTagsController;
  late String _pinCode;
  late bool _videoAutoPause;
  late bool _disableAnimation;

  late String _imageUploadProvider;

  late TextEditingController _templateTitleController;
  late TextEditingController _templateBodyController;
  late TextEditingController _templateTagController;
  late String _templatePreviewBody;

  late TextEditingController _momentTitleController;
  late TextEditingController _momentBodyController;
  late String _momentPreviewBody;

  List<String> _showHiddentNsfwOptions = ['Show', 'Hide', 'Blur'];

  bool _defaultUploadOC = false;
  bool _defaultUploadUnlist = false;
  bool _defaultUploadNSFW = false;
  bool _defaultUploadCrossPost = false;
  double _defaultUploadVotingWeight = 5;

  bool _defaultMomentsOC = false;
  bool _defaultMomentsUnlist = false;
  bool _defaultMomentsNSFW = false;
  bool _defaultMomentsCrossPost = false;
  double _defaultMomentVotingWeight = 5;

  bool _downvoteFixed = false;
  double _downvoteFixedAmount = 1;

  bool _showDisplayHints = false;
  bool _showSecurityHints = false;
  bool _showBehaviourHints = false;

  bool _showInterestsHints = false;

  bool _showVotingWeightHints = false;
  bool _showVotingTipHints = false;
  bool _showDefaultDownvoteHints = false;

  bool _showVotingUploadDefaultsHints = false;
  bool _showVotingMomentDefaultsHints = false;
  bool _showHivesignerHints = false;
  bool _showHiveDefaultCommunityHint = false;
  bool _showHiveDefaultTagsHint = false;

  bool _showNSFWSettings = false;

  List<String> _imageUploadProviders = ['imgur', 'ipfs'];
  List<int> _visitedTabs = [];

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => PopUpDialogWithTitleLogo(
            showTitleWidget: true,
            callbackOK: () {},
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Do you really want to leave the settings without saving?',
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: 2.h),
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
                        "Yes",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(true);
                    }),
              ],
            )),
            titleWidget:
                Center(child: FaIcon(FontAwesomeIcons.doorOpen, size: 18.w)),
            titleWidgetPadding: 10.h,
            titleWidgetSize: 20.w,
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  void initState() {
    settings = {"none": "none"};
    _tabController = new TabController(length: 5, vsync: this);

    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _settingsBloc.add(FetchSettingsEvent()); // statements;
    _templateBodyController = TextEditingController(text: "");
    _templateTitleController = TextEditingController(text: "");
    _templateTagController = TextEditingController(text: "");
    _momentBodyController = TextEditingController(text: "");
    _momentTitleController = TextEditingController(text: "");
    _hiveDefaultCommunityController = TextEditingController(text: "");
    //  _hiveDefaultTagsController = TextEditingController(text: "");
    _templatePreviewBody = "";
    _momentPreviewBody = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup, //call function on back button press
      child: Scaffold(
        // Todo abstract this to dtubeSubAppBar
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: globalBGColor,
            elevation: 0,
            title: DTubeLogo(
              size: 60,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16.0, 0),
                child: HeartBeat(
                  preferences: AnimationPreferences(
                      autoPlay: AnimationPlayStates.Loop,
                      offset: Duration(seconds: 3),
                      duration: Duration(seconds: 1)),
                  child: GestureDetector(
                    child: FaIcon(FontAwesomeIcons.floppyDisk),
                    onTap: () async {
                      Map<String, String> newSettings = {
                        sec.settingKey_defaultVotingWeight:
                            _defaultVote.toString(),
                        sec.settingKey_defaultVotingWeightComments:
                            _defaultVoteComments.toString(),
                        sec.settingKey_defaultVotingTip: _defaultTip.toString(),
                        sec.settingKey_defaultVotingTipComments:
                            _defaultTipComments.toString(),
                        sec.settingKey_showHidden: _showHidden,
                        sec.settingKey_showNSFW: _showNsfw,
                        sec.settingKey_templateTitle:
                            _templateTitleController.value.text,
                        sec.settingKey_templateBody:
                            _templateBodyController.value.text,
                        sec.settingKey_templateTag:
                            _templateTagController.value.text,
                        sec.settingKey_imageUploadService: _imageUploadProvider,
                        sec.settingKey_DefaultUploadNSFW:
                            _defaultUploadNSFW.toString(),
                        sec.settingKey_DefaultUploadOC:
                            _defaultUploadOC.toString(),
                        sec.settingKey_DefaultUploadUnlist:
                            _defaultUploadUnlist.toString(),
                        sec.settingKey_DefaultUploadCrosspost:
                            _defaultUploadCrossPost.toString(),
                        sec.settingKey_DefaultMomentNSFW:
                            _defaultMomentsNSFW.toString(),
                        sec.settingKey_DefaultMomentOC:
                            _defaultMomentsOC.toString(),
                        sec.settingKey_DefaultMomentUnlist:
                            _defaultMomentsUnlist.toString(),
                        sec.settingKey_DefaultMomentCrosspost:
                            _defaultMomentsCrossPost.toString(),
                        sec.settingKey_DefaultUploadVotingWeigth:
                            _defaultUploadVotingWeight.toString(),
                        sec.settingKey_DefaultMomentVotingWeigth:
                            _defaultMomentVotingWeight.toString(),
                        sec.settingKey_momentTitle:
                            _momentTitleController.value.text,
                        sec.settingKey_momentBody:
                            _momentBodyController.value.text,
                        sec.settingKey_hiveSignerDefaultCommunity:
                            _hiveDefaultCommunityController.value.text,
                        sec.settingKey_hiveSignerDefaultTags:
                            _hiveDefaultTags.join(","),
                        sec.settingKey_FixedDownvoteActivated:
                            _downvoteFixed.toString(),
                        sec.settingKey_FixedDownvoteWeight:
                            _downvoteFixedAmount.toString(),
                        sec.settingKey_videoAutoPause:
                            _videoAutoPause.toString(),
                        sec.settingKey_disableAnimations:
                            _disableAnimation.toString(),
                      };

                      _settingsBloc.add(PushSettingsEvent(
                          newSettings: newSettings, context: context));
                    },
                  ),
                ),
              ),
            ]),
        resizeToAvoidBottomInset: true,
        body:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          if (state is SettingsLoadingState || state is SettingsSavingState) {
            return Center(
                child: DtubeLogoPulseWithSubtitle(
              subtitle: "loading settings..",
              size: 30.w,
            ));
          } else if (state is SettingsLoadedState) {
            if (settings.length == 1) {
              settings = state.settings;

              _showHidden = settings[sec.settingKey_showHidden] != null
                  ? settings[sec.settingKey_showHidden]!
                  : "Hide";

              _showNsfw = settings[sec.settingKey_showNSFW] != null
                  ? settings[sec.settingKey_showNSFW]!
                  : "Hide";
              _defaultVote = settings[sec.settingKey_defaultVotingWeight] !=
                      null
                  ? double.parse(settings[sec.settingKey_defaultVotingWeight]!)
                  : 5.0;
              _defaultVoteComments =
                  settings[sec.settingKey_defaultVotingWeightComments] != null
                      ? double.parse(
                          settings[sec.settingKey_defaultVotingWeightComments]!)
                      : 5.0;
              _defaultTip = settings[sec.settingKey_defaultVotingTip] != null
                  ? double.parse(settings[sec.settingKey_defaultVotingTip]!)
                  : 25;
              _defaultTipComments =
                  settings[sec.settingKey_defaultVotingTipComments] != null
                      ? double.parse(
                          settings[sec.settingKey_defaultVotingTipComments]!)
                      : 25.0;
              _hiveUsername =
                  settings[sec.settingKey_hiveSignerUsername] != null
                      ? settings[sec.settingKey_hiveSignerUsername]!
                      : "";
              _hiveDefaultCommunity =
                  settings[sec.settingKey_hiveSignerDefaultCommunity] != null &&
                          settings[sec.settingKey_hiveSignerDefaultCommunity] !=
                              ""
                      ? settings[sec.settingKey_hiveSignerDefaultCommunity]!
                      : "hive-196037";
              _hiveDefaultCommunityController = new TextEditingController(
                  text: settings[sec.settingKey_hiveSignerDefaultCommunity] !=
                              null &&
                          settings[sec.settingKey_hiveSignerDefaultCommunity]!
                              .startsWith("hive-")
                      ? settings[sec.settingKey_hiveSignerDefaultCommunity]!
                      : "hive-196037");

              _hiveDefaultTags =
                  settings[sec.settingKey_hiveSignerDefaultTags] != null &&
                          settings[sec.settingKey_hiveSignerDefaultTags] != ""
                      ? settings[sec.settingKey_hiveSignerDefaultTags]!
                          .split(",")
                      : [];

              _templateTitleController = new TextEditingController(
                  text: settings[sec.settingKey_templateTitle] != null
                      ? settings[sec.settingKey_templateTitle]!
                      : "");
              _templateBodyController = new TextEditingController(
                  text: settings[sec.settingKey_templateBody] != null
                      ? settings[sec.settingKey_templateBody]!
                      : "");
              _templatePreviewBody =
                  settings[sec.settingKey_templateBody] != null
                      ? settings[sec.settingKey_templateBody]!
                      : "";

              _momentTitleController = new TextEditingController(
                  text: settings[sec.settingKey_momentTitle] != null
                      ? settings[sec.settingKey_momentTitle]!
                      : "");
              _momentBodyController = new TextEditingController(
                  text: settings[sec.settingKey_momentBody] != null
                      ? settings[sec.settingKey_momentBody]!
                      : "");
              _momentPreviewBody = settings[sec.settingKey_momentBody] != null
                  ? settings[sec.settingKey_momentBody]!
                  : "";

              _templateTagController = new TextEditingController(
                  text: settings[sec.settingKey_templateTag] != null
                      ? settings[sec.settingKey_templateTag]!
                      : "");

              _pinCode = settings[sec.settingKey_pincode] != null
                  ? settings[sec.settingKey_pincode]!
                  : "";

              _videoAutoPause = settings[sec.settingKey_videoAutoPause] != null
                  ? settings[sec.settingKey_videoAutoPause]! == "true"
                  : false;
              _disableAnimation =
                  settings[sec.settingKey_disableAnimations] != null
                      ? settings[sec.settingKey_disableAnimations]! == "true"
                      : false;

              _imageUploadProvider =
                  settings[sec.settingKey_imageUploadService] != null
                      ? settings[sec.settingKey_imageUploadService]!
                      : "imgur";

              _defaultUploadNSFW =
                  settings[sec.settingKey_DefaultUploadNSFW] != null
                      ? settings[sec.settingKey_DefaultUploadNSFW]! == 'true'
                      : false;
              _defaultUploadOC =
                  settings[sec.settingKey_DefaultUploadOC] != null
                      ? settings[sec.settingKey_DefaultUploadOC]! == 'true'
                      : false;
              _defaultUploadUnlist =
                  settings[sec.settingKey_DefaultUploadUnlist] != null
                      ? settings[sec.settingKey_DefaultUploadUnlist]! == 'true'
                      : false;
              _defaultUploadCrossPost =
                  settings[sec.settingKey_DefaultUploadCrosspost] != null
                      ? settings[sec.settingKey_DefaultUploadCrosspost]! ==
                          'true'
                      : false;

              _defaultMomentsNSFW =
                  settings[sec.settingKey_DefaultMomentNSFW] != null
                      ? settings[sec.settingKey_DefaultMomentNSFW]! == 'true'
                      : false;
              _defaultMomentsOC =
                  settings[sec.settingKey_DefaultMomentOC] != null
                      ? settings[sec.settingKey_DefaultMomentOC]! == 'true'
                      : false;
              _defaultMomentsUnlist =
                  settings[sec.settingKey_DefaultMomentUnlist] != null
                      ? settings[sec.settingKey_DefaultMomentUnlist]! == 'true'
                      : false;
              _defaultMomentsCrossPost =
                  settings[sec.settingKey_DefaultMomentCrosspost] != null
                      ? settings[sec.settingKey_DefaultMomentCrosspost]! ==
                          'true'
                      : false;

              _defaultUploadVotingWeight =
                  settings[sec.settingKey_DefaultUploadVotingWeigth] != null
                      ? double.parse(
                          settings[sec.settingKey_DefaultUploadVotingWeigth]!)
                      : 5.0;
              _defaultMomentVotingWeight =
                  settings[sec.settingKey_DefaultMomentVotingWeigth] != null
                      ? double.parse(
                          settings[sec.settingKey_DefaultMomentVotingWeigth]!)
                      : 5.0;
              _downvoteFixed =
                  settings[sec.settingKey_FixedDownvoteActivated] != null
                      ? settings[sec.settingKey_FixedDownvoteActivated] ==
                          "true"
                      : true;
              _downvoteFixedAmount =
                  settings[sec.settingKey_FixedDownvoteWeight] != null
                      ? double.parse(
                          settings[sec.settingKey_FixedDownvoteWeight]!)
                      : 1.0;
            }

            return Column(
              children: [
                Container(
                  height: 7.h,
                  child: TabBar(
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
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
                        text: 'General',
                      ),
                      Tab(
                        text: 'Avalon',
                      ),
                      Tab(
                        text: 'Hive',
                      ),
                      Tab(
                        text: 'Uploads',
                      ),
                      Tab(
                        text: 'Moments',
                      ),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(
                      children: [
                        // GENERAL SETTINGS
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Visibility(
                                visible:
                                    false, // to get accepted by google we had to remove this option
                                child: DTubeFormCard(
                                  waitBeforeFadeIn: Duration(milliseconds: 200),
                                  avoidAnimation: _visitedTabs.contains(0) ||
                                      globals.disableAnimations,
                                  childs: [
                                    Stack(
                                      children: [
                                        ShowHintIcon(
                                          onPressed: () {
                                            setState(() {
                                              _showDisplayHints =
                                                  !_showDisplayHints;
                                            });
                                          },
                                          alignment: Alignment.topRight,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 1.h),
                                          child: Text("Display",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text(
                                          "How do you want to see those kind of videos in the app?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ),
                                    DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          //filled: true,
                                          //fillColor: Hexcolor('#ecedec'),
                                          labelText: 'negative videos:',
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .headline5
                                          //border: new CustomBorderTextFieldSkin().getSkin(),
                                          ),
                                      value: _showHidden,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _showHidden = newValue.toString();
                                          // widget.justSaved = false;
                                        });
                                      },
                                      items:
                                          _showHiddentNsfwOptions.map((option) {
                                        return DropdownMenuItem(
                                          child: new Text(option),
                                          value: option,
                                        );
                                      }).toList(),
                                    ),
                                    VisibilityHintText(
                                        showHint: _showDisplayHints,
                                        hintText:
                                            "If a video has a higher sum of VP spent for downvotes than for upvotes it counts as a \"negative\" video."),
                                    DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          //filled: true,
                                          //fillColor: Hexcolor('#ecedec'),
                                          labelText: 'NSFW videos:',
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .headline5
                                          //border: new CustomBorderTextFieldSkin().getSkin(),
                                          ),
                                      value: _showNsfw,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _showNsfw = newValue.toString();
                                          // widget.justSaved = false;
                                        });
                                      },
                                      items:
                                          _showHiddentNsfwOptions.map((option) {
                                        return DropdownMenuItem(
                                          child: new Text(option),
                                          value: option,
                                        );
                                      }).toList(),
                                    ),
                                    VisibilityHintText(
                                        showHint: _showDisplayHints,
                                        hintText:
                                            "The author can tag the new video as NSFW (not safe for work). But also curators can vote with the NSFW curator tag. If this tag has more VP spent than the original video tag the video will also count as \"NSFW\"."),
                                  ],
                                ),
                              ),

                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(0) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(
                                    children: [
                                      ShowHintIcon(
                                        onPressed: () {
                                          setState(() {
                                            _showSecurityHints =
                                                !_showSecurityHints;
                                          });
                                        },
                                        alignment: Alignment.topRight,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text("Security",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 60.w,
                                        child: Text(
                                            "secure your app with a 5 digit pin",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    BlocProvider<SettingsBloc>(
                                                        create: (BuildContext
                                                                context) =>
                                                            SettingsBloc(),
                                                        child: PinCodeDialog(
                                                          currentPin: _pinCode,
                                                        )));
                                          },
                                          child: Text(_pinCode != ""
                                              ? "change pin"
                                              : "set pin"))
                                    ],
                                  ),
                                  VisibilityHintText(
                                      showHint: _showSecurityHints,
                                      hintText:
                                          "Your login data is stored in a secure storage on your device. The app will automatically login you when you start the app. To prevent anyone else to use your account on your device, make sure to set this pin."),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(0) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(
                                    children: [
                                      ShowHintIcon(
                                        onPressed: () {
                                          setState(() {
                                            _showBehaviourHints =
                                                !_showBehaviourHints;
                                          });
                                        },
                                        alignment: Alignment.topRight,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text("Behaviour",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 60.w,
                                        child: Text("pause video on popups",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Switch(
                                        value: _videoAutoPause,
                                        onChanged: (value) {
                                          setState(() {
                                            _videoAutoPause = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  VisibilityHintText(
                                      showHint: _showBehaviourHints,
                                      hintText:
                                          "If you play back a video and you are goign to comment / vote on it - the video playback is automatically paused. You can turn off this behvaiour with this setting."),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 60.w,
                                        child: Text("disable app animations",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Switch(
                                        value: _disableAnimation,
                                        onChanged: (value) {
                                          setState(() {
                                            _disableAnimation = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  VisibilityHintText(
                                      showHint: _showBehaviourHints,
                                      hintText:
                                          "You can turn off all animations in the app to receive a more resource-saving experience without many distractions."),
                                ],
                              ),
                              // deactivated until we have more providers
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 16.0),
                              //   child: Text("Image upload",
                              //       style: Theme.of(context).textTheme.headline3),
                              // ),

                              // DTubeFormCard(
                              //   childs: [
                              //     DropdownButtonFormField(
                              //       decoration: InputDecoration(
                              //         //filled: true,
                              //         //fillColor: Hexcolor('#ecedec'),
                              //         labelText: 'storage provider',
                              //         //border: new CustomBorderTextFieldSkin().getSkin(),
                              //       ),
                              //       value: _imageUploadProvider,
                              //       onChanged: (newValue) {
                              //         setState(() {
                              //           _imageUploadProvider =
                              //               newValue.toString();
                              //           // widget.justSaved = false;
                              //         });
                              //       },
                              //       items: _imageUploadProviders.map((option) {
                              //         return DropdownMenuItem(
                              //           child: new Text(option),
                              //           value: option,
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),

                        // AVALON SETTINGS
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 200),
                                avoidAnimation: _visitedTabs.contains(1) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showVotingWeightHints =
                                              !_showVotingWeightHints;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text("Voting weight",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "default voting weight (posts):",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Slider(
                                          min: 1.0,
                                          max: 100.0,
                                          value: _defaultVote,
                                          label:
                                              _defaultVote.floor().toString() +
                                                  "%",
                                          divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _defaultVote = value;
                                              //  widget.justSaved = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        _defaultVote.floor().toString() + "%",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "default voting weight (comments):",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Slider(
                                          min: 0.0,
                                          max: 100.0,
                                          value: _defaultVoteComments,
                                          label: _defaultVoteComments
                                                  .floor()
                                                  .toString() +
                                              "%",
                                          divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _defaultVoteComments = value;
                                              //  widget.justSaved = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        _defaultVoteComments
                                                .floor()
                                                .toString() +
                                            "%",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  VisibilityHintText(
                                    showHint: _showVotingWeightHints,
                                    hintText:
                                        "Those settings set the default setting of the vote sliders. The voting weight defines how much of your VP you want to spend for the vote.",
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(1) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showVotingTipHints =
                                              !_showVotingTipHints;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text("Vote tipping",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Text("default voting tip (posts):",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Slider(
                                          min: 0.0,
                                          max: 100.0,
                                          value: _defaultTip,
                                          label:
                                              _defaultTip.floor().toString() +
                                                  "%",
                                          divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _defaultTip = value;
                                              // widget.justSaved = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        _defaultTip.floor().toString() + "%",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "default voting tip (comments):",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Slider(
                                          min: 0.0,
                                          max: 100.0,
                                          value: _defaultTipComments,
                                          label: _defaultTipComments
                                                  .floor()
                                                  .toString() +
                                              "%",
                                          divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _defaultTipComments = value;
                                              // widget.justSaved = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        _defaultTipComments.floor().toString() +
                                            "%",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  VisibilityHintText(
                                    showHint: _showVotingTipHints,
                                    hintText:
                                        "Those settings set the default setting of the tipping sliders. Every vote can generate DTC for you as curation rewards. By tipping you give away x % of those rewards to the content creator you are voting on.",
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(1) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showDefaultDownvoteHints =
                                              !_showDefaultDownvoteHints;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text("Downvotes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: _downvoteFixed,
                                          onChanged: (bool) {
                                            setState(() {
                                              _downvoteFixed = !_downvoteFixed;
                                            });
                                          }),
                                      Text("downvote with a FIXED weight",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)
                                    ],
                                  ),
                                  _downvoteFixed
                                      ? Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "default downvote weight:",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Slider(
                                                    min: 0.1,
                                                    max: 100.0,
                                                    value: _downvoteFixedAmount,
                                                    label: _downvoteFixedAmount
                                                            .floor()
                                                            .toString() +
                                                        "%",
                                                    divisions: 20,
                                                    inactiveColor: globalBlue,
                                                    activeColor: globalRed,
                                                    onChanged: (dynamic value) {
                                                      setState(() {
                                                        _downvoteFixedAmount =
                                                            value;
                                                        // widget.justSaved = false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  _downvoteFixedAmount
                                                          .floor()
                                                          .toString() +
                                                      "%",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  VisibilityHintText(
                                    showHint: _showDefaultDownvoteHints,
                                    hintText:
                                        "If you activate the fixed downvote setting you will not be able to set the downvote weight anymore. This setting does not affect the user experience inside of the app. All downvoted posts will get hidden automatically for you. ",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // POSTING SETTINGS
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              DTubeFormCard(
                                avoidAnimation: _visitedTabs.contains(2) ||
                                    globals.disableAnimations,
                                waitBeforeFadeIn: Duration(milliseconds: 600),
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showHivesignerHints =
                                              !_showHivesignerHints;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 1.h),
                                      child: Text("Hivesigner settings",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Container(
                                        width: 85.w,
                                        child: Column(
                                          children: [
                                            Text(
                                                "Cross-posting to the hive blockchain is possible by authorizing the app via hivesigner.",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  BlocProvider<HivesignerBloc>(
                                                create: (BuildContext
                                                        context) =>
                                                    HivesignerBloc(
                                                        repository:
                                                            HivesignerRepositoryImpl()),
                                                child: HiveSignerForm(
                                                  username: _hiveUsername,
                                                ),
                                              ),
                                            ),
                                            VisibilityHintText(
                                              showHint: _showHivesignerHints,
                                              hintText:
                                                  "This authorizing does not include voting, commenting or any other functionality of the hive blockchain! For security reasons you have to renew the connection every 7 days.",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              DTubeFormCard(
                                avoidAnimation: _visitedTabs.contains(2) ||
                                    globals.disableAnimations,
                                waitBeforeFadeIn: Duration(milliseconds: 800),
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showHiveDefaultCommunityHint =
                                              !_showHiveDefaultCommunityHint;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 1.h),
                                      child: Text("Hive community",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Container(
                                        width: 85.w,
                                        child: Column(
                                          children: [
                                            Text(
                                                "Cross-posted videos are usually published in the DTube-Community on Hive. Here you can change this to any other hive community by entering the correct community ID (e.g. hive-196037 for DTube).",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller:
                                                    _hiveDefaultCommunityController,
                                                cursorColor: globalRed,
                                                decoration: new InputDecoration(
                                                    labelText:
                                                        "hive community id:"),
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                            VisibilityHintText(
                                              showHint:
                                                  _showHiveDefaultCommunityHint,
                                              hintText:
                                                  "The code is very important in order to post your video in the correct community! You can look the id for your desired community up on a hive user interface like peakd.com.",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                avoidAnimation: _visitedTabs.contains(2) ||
                                    globals.disableAnimations,
                                waitBeforeFadeIn: Duration(milliseconds: 900),
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showHiveDefaultTagsHint =
                                              !_showHiveDefaultTagsHint;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 1.h),
                                      child: Text("Hive Tags",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Container(
                                        width: 85.w,
                                        child: Column(
                                          children: [
                                            Text(
                                                "Cross-posted videos can get tagged with up to 8 custom tags.",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFieldTags(
                                                  initialTags: _hiveDefaultTags,
                                                  textFieldStyler:
                                                      TextFieldStyler(
                                                    //These are properties you can tweek for customization

                                                    // bool textFieldFilled = false,
                                                    // Icon icon,
                                                    helperText: _hiveDefaultTags
                                                            .length
                                                            .toString() +
                                                        ' tags (hit space to add tag)\n' +
                                                        _hiveDefaultTags
                                                            .join("\n"),
                                                    // TextStyle helperStyle,
                                                    hintText: '',
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                    // TextStyle hintStyle,
                                                    // EdgeInsets contentPadding,
                                                    // Color textFieldFilledColor,
                                                    // bool isDense = true,
                                                    // bool textFieldEnabled = true,
                                                    // OutlineInputBorder textFieldBorder = const OutlineInputBorder(),
                                                    // OutlineInputBorder textFieldFocusedBorder,
                                                    // OutlineInputBorder textFieldDisabledBorder,
                                                    // OutlineInputBorder textFieldEnabledBorder
                                                  ),
                                                  tagsStyler: TagsStyler(
                                                    //These are properties you can tweek for customization

                                                    // showHashtag = false,
                                                    // EdgeInsets tagPadding = const EdgeInsets.all(4.0),
                                                    // EdgeInsets tagMargin = const EdgeInsets.symmetric(horizontal: 4.0),
                                                    tagDecoration:
                                                        BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                            color: globalRed),
                                                    tagTextStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                    tagCancelIcon: Icon(
                                                        Icons.cancel,
                                                        size: 4.w,
                                                        color:
                                                            globalAlmostWhite),
                                                  ),
                                                  onTag: (tag) {
                                                    setState(() {
                                                      _hiveDefaultTags.add(tag);
                                                    });
                                                  },
                                                  onDelete: (tag) {
                                                    setState(() {
                                                      _hiveDefaultTags
                                                          .remove(tag);
                                                    });
                                                  },
                                                  validator: (tag) {
                                                    if (_hiveDefaultTags
                                                            .length ==
                                                        8) {
                                                      return "max 8 tags allowed";
                                                    }
                                                    if (!RegExp(r'^[a-z]+$')
                                                        .hasMatch(tag)) {
                                                      return "only alhabetic characters allowed";
                                                    }
                                                    if (_hiveDefaultTags
                                                        .contains(tag)) {
                                                      return "tag is already in the list";
                                                    }
                                                    if (tag.toLowerCase() ==
                                                        "dtube") {
                                                      return "dtube is as default in the list";
                                                    }
                                                    return null;
                                                  },
                                                  tagsDistanceFromBorderEnd:
                                                      0.50,

                                                  //scrollableTagsMargin: EdgeInsets.only(left: 9),
                                                  //scrollableTagsPadding: EdgeInsets.only(left: 9),
                                                )

                                                // TextFormField(
                                                //   controller:
                                                //       _hiveDefaultTagsController,
                                                //   cursorColor: globalRed,
                                                //   decoration: new InputDecoration(
                                                //       labelText:
                                                //           "hive tags (space-separated):"),
                                                //   maxLines: 1,
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .bodyText1,
                                                // ),
                                                ),
                                            VisibilityHintText(
                                              showHint:
                                                  _showHiveDefaultTagsHint,
                                              hintText:
                                                  "Your cross-posted video will receive those tags on the hive blockchain. Only up to 8 tags are allowed (dtube and the tag of your post will be added automatically) and you should set them separated by spaces in the textfield above.",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // REGULAR UPLOAD SETTINGS &  TEMPLATE
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                                child: Text(
                                    "Default Values for Regular Uploads",
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 200),
                                avoidAnimation: _visitedTabs.contains(2) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showVotingUploadDefaultsHints =
                                              !_showVotingUploadDefaultsHints;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 1.h),
                                      child: Text(
                                          "Video upload default settings",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.spaceEvenly,
                                    children: [
                                      ChoiceChip(
                                          selected: _defaultUploadOC,
                                          label: Text('original content'),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          avatar: _defaultUploadOC
                                              ? FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 15,
                                                )
                                              : null,
                                          backgroundColor:
                                              Colors.grey.withAlpha(30),
                                          selectedColor: Colors.green[700],
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _defaultUploadOC =
                                                  !_defaultUploadOC;
                                            });
                                          }),
                                      Visibility(
                                        visible:
                                            false, // to get accepted by google we had to remove this option
                                        child: ChoiceChip(
                                            selected: _defaultUploadNSFW,
                                            label: Text('nsfw content'),
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            avatar: _defaultUploadNSFW
                                                ? FaIcon(
                                                    FontAwesomeIcons.check,
                                                    size: 15,
                                                  )
                                                : null,
                                            backgroundColor:
                                                Colors.grey.withAlpha(30),
                                            selectedColor: Colors.green[700],
                                            onSelected: (bool selected) {
                                              setState(() {
                                                _defaultUploadNSFW =
                                                    !_defaultUploadNSFW;
                                              });
                                            }),
                                      ),
                                      ChoiceChip(
                                          selected: _defaultUploadUnlist,
                                          label: Text('unlist video'),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          avatar: _defaultUploadUnlist
                                              ? FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 15,
                                                )
                                              : null,
                                          backgroundColor:
                                              Colors.grey.withAlpha(30),
                                          selectedColor: Colors.green[700],
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _defaultUploadUnlist =
                                                  !_defaultUploadUnlist;
                                            });
                                          }),
                                      _hiveUsername != ""
                                          ? ChoiceChip(
                                              selected: _defaultUploadCrossPost,
                                              label: Text('cross-post to hive'),
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              avatar: _defaultUploadCrossPost
                                                  ? FaIcon(
                                                      FontAwesomeIcons.check,
                                                      size: 15,
                                                    )
                                                  : null,
                                              backgroundColor:
                                                  Colors.grey.withAlpha(30),
                                              selectedColor: Colors.green[700],
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  _defaultUploadCrossPost =
                                                      !_defaultUploadCrossPost;
                                                });
                                              })
                                          : SizedBox(
                                              width: 0,
                                            ),
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("default voting weight:",
                                          style:
                                              TextStyle(color: Colors.grey))),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Slider(
                                          min: 1.0,
                                          max: 100.0,
                                          value: _defaultUploadVotingWeight,
                                          label: _defaultUploadVotingWeight
                                                  .floor()
                                                  .toString() +
                                              "%",
                                          divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _defaultUploadVotingWeight =
                                                  value;
                                              //  widget.justSaved = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        _defaultUploadVotingWeight
                                                .floor()
                                                .toString() +
                                            "%",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  VisibilityHintText(
                                    showHint: _showVotingUploadDefaultsHints,
                                    hintText:
                                        "Those are defaults so you can always change those values in the upload process. can also set a template (see tabs above).",
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                avoidAnimation: _visitedTabs.contains(3) ||
                                    globals.disableAnimations,
                                waitBeforeFadeIn: Duration(milliseconds: 200),
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Title",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  TextFormField(
                                    controller: _templateTitleController,
                                    cursorColor: globalRed,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(3) ||
                                    globals.disableAnimations,
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Body",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  TextFormField(
                                    controller: _templateBodyController,
                                    cursorColor: globalRed,
                                    maxLines: 6,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    onChanged: (String text) {
                                      setState(() {
                                        _templatePreviewBody = text;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 600),
                                avoidAnimation: _visitedTabs.contains(3) ||
                                    globals.disableAnimations,
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Tag",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  TextFormField(
                                    controller: _templateTagController,
                                    cursorColor: globalRed,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 800),
                                avoidAnimation: _visitedTabs.contains(3) ||
                                    globals.disableAnimations,
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Preview",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 90.w,
                                    height: 200,
                                    child: MarkdownBody(
                                        data: _templatePreviewBody),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // MOMENT SETTINGS & TEMPLATE
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                                child: Text("Moment Values",
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(4) ||
                                    globals.disableAnimations,
                                childs: [
                                  Stack(children: [
                                    ShowHintIcon(
                                      onPressed: () {
                                        setState(() {
                                          _showVotingMomentDefaultsHints =
                                              !_showVotingMomentDefaultsHints;
                                        });
                                      },
                                      alignment: Alignment.topRight,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.h, bottom: 1.h),
                                      child: Text("Moments upload settings",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ]),
                                  Text(
                                    "Define how your moments are being posted.",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    "You can not change those values in the upload process!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: globalRed),
                                  ),
                                  SizedBox(height: 2.h),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    runAlignment: WrapAlignment.spaceEvenly,
                                    children: [
                                      ChoiceChip(
                                          selected: _defaultMomentsOC,
                                          label: Text('original content'),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          avatar: _defaultMomentsOC
                                              ? FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 15,
                                                )
                                              : null,
                                          backgroundColor:
                                              Colors.grey.withAlpha(30),
                                          selectedColor: Colors.green[700],
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _defaultMomentsOC =
                                                  !_defaultMomentsOC;
                                            });
                                          }),
                                      Visibility(
                                        visible:
                                            false, // to get accepted by google we had to remove this option
                                        child: ChoiceChip(
                                            selected: _defaultMomentsNSFW,
                                            label: Text('nsfw content'),
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            avatar: _defaultMomentsNSFW
                                                ? FaIcon(
                                                    FontAwesomeIcons.check,
                                                    size: 15,
                                                  )
                                                : null,
                                            backgroundColor:
                                                Colors.grey.withAlpha(30),
                                            selectedColor: Colors.green[700],
                                            onSelected: (bool selected) {
                                              setState(() {
                                                _defaultMomentsNSFW =
                                                    !_defaultMomentsNSFW;
                                              });
                                            }),
                                      ),
                                      ChoiceChip(
                                          selected: _defaultMomentsUnlist,
                                          label: Text('only show in moments'),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          avatar: _defaultMomentsUnlist
                                              ? FaIcon(
                                                  FontAwesomeIcons.check,
                                                  size: 15,
                                                )
                                              : null,
                                          backgroundColor:
                                              Colors.grey.withAlpha(30),
                                          selectedColor: Colors.green[700],
                                          onSelected: (bool selected) {
                                            setState(() {
                                              _defaultMomentsUnlist =
                                                  !_defaultMomentsUnlist;
                                            });
                                          }),
                                      _hiveUsername != ""
                                          ? ChoiceChip(
                                              selected:
                                                  _defaultMomentsCrossPost,
                                              label: Text('cross-post to hive'),
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              avatar: _defaultMomentsCrossPost
                                                  ? FaIcon(
                                                      FontAwesomeIcons.check,
                                                      size: 15,
                                                    )
                                                  : null,
                                              backgroundColor:
                                                  Colors.grey.withAlpha(30),
                                              selectedColor: Colors.green[700],
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  _defaultMomentsCrossPost =
                                                      !_defaultMomentsCrossPost;
                                                });
                                              })
                                          : SizedBox(
                                              width: 0,
                                            ),
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("self voting weight:",
                                          style:
                                              TextStyle(color: Colors.grey))),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Slider(
                                          min: 1.0,
                                          max: 100.0,
                                          value: _defaultMomentVotingWeight,
                                          label: _defaultMomentVotingWeight
                                                  .floor()
                                                  .toString() +
                                              "%",
                                          divisions: 20,
                                          inactiveColor: globalBlue,
                                          activeColor: globalRed,
                                          onChanged: (dynamic value) {
                                            setState(() {
                                              _defaultMomentVotingWeight =
                                                  value;
                                              //  widget.justSaved = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        _defaultMomentVotingWeight
                                                .floor()
                                                .toString() +
                                            "%",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  VisibilityHintText(
                                    showHint: _showVotingMomentDefaultsHints,
                                    hintText:
                                        "To keep the posting process of moments as quick as possible there are no extra settings in the uploader. That's why you should set the desired values here.",
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 200),
                                avoidAnimation: _visitedTabs.contains(4) ||
                                    globals.disableAnimations,
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Title",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  TextFormField(
                                    controller: _momentTitleController,
                                    cursorColor: globalRed,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 400),
                                avoidAnimation: _visitedTabs.contains(4) ||
                                    globals.disableAnimations,
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Body",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  TextFormField(
                                    controller: _momentBodyController,
                                    cursorColor: globalRed,
                                    maxLines: 6,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    onChanged: (String text) {
                                      setState(() {
                                        _momentPreviewBody = text;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              DTubeFormCard(
                                waitBeforeFadeIn: Duration(milliseconds: 800),
                                avoidAnimation: _visitedTabs.contains(4) ||
                                    globals.disableAnimations,
                                childs: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1.h, bottom: 1.h),
                                    child: Text("Preview",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 90.w,
                                    height: 200,
                                    child:
                                        MarkdownBody(data: _momentPreviewBody),
                                  )
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
          } else if (state is SettingsErrorState) {
            return buildErrorUi(state.message);
          } else if (state is SettingsSavedState) {
            print("saved settings");
            // setState(() {
            //   _justSaved = true;
            // });
          } else {
            return Text("unknown state");
          }
          return DtubeLogoPulseWithSubtitle(
            subtitle: "loading settings..",
            size: 30.w,
          );
        }),
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

class ShowHintIcon extends StatelessWidget {
  ShowHintIcon({Key? key, required this.onPressed, required this.alignment})
      : super(key: key);

  final VoidCallback onPressed;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Swing(
          preferences: AnimationPreferences(
            autoPlay: AnimationPlayStates.Loop,
            magnitude: 0.4,
            offset: Duration(seconds: 4),
          ),
          child: FaIcon(FontAwesomeIcons.question, size: globalIconSizeSmall),
        ),
      ),
    );
  }
}

class VisibilityHintText extends StatefulWidget {
  const VisibilityHintText(
      {Key? key, required this.showHint, required this.hintText})
      : super(key: key);

  final bool showHint;
  final String hintText;

  @override
  State<VisibilityHintText> createState() => _VisibilityHintTextState();
}

class _VisibilityHintTextState extends State<VisibilityHintText> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.showHint,
      child: Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: FadeIn(
          preferences: AnimationPreferences(
              autoPlay: widget.showHint
                  ? AnimationPlayStates.Forward
                  : AnimationPlayStates.None,
              duration: Duration(seconds: 2)),
          child: Text(
            widget.hintText,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
