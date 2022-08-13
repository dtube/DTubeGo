import 'dart:convert';
import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const authKey_usernameKey = 'USERNAME';
const authKey_privKey = 'PRIV';
const settingKey_avalonNode = 'APINODE';

const settingKey_showHidden = 'HIDE';

const settingKey_showNSFW = 'NSFW';

const settingKey_defaultVotingWeight = 'DEFVOTE';
const settingKey_defaultVotingWeightComments = 'DEFVOTECOMMENTS';

const settingKey_defaultVotingTip = 'DEFTIP';
const settingKey_defaultVotingTipComments = 'DEFTIPCOMMENTS';

const settingKey_hiveSignerUsername = 'HSUN';
const settingKey_hiveSignerAccessToken = 'HSAT';
const settingKey_hiveSignerAccessTokenExpiresIn = 'HSEI';
const settingKey_hiveSignerAccessTokenRequestedOn = 'HSRO';

const settingKey_hiveSignerDefaultCommunity = 'HSCOMMUNITY';
const settingKey_hiveSignerDefaultTags = 'HSTAGS';

const settingKey_OpenedOnce = 'OPENEDONCE';
const settingKey_FirstLogin = 'FIRSTLOGIN';

const settingKey_templateTitle = 'TEMPLATETITLE';
const settingKey_templateBody = 'TEMPLATEBODY';
const settingKey_templateTag = 'TEMPLATETAG';

const settingKey_additionalTemplates = "ADDITIONALTEMPLATES";

const settingKey_momentTitle = 'MOMENTTITLE';
const settingKey_momentBody = 'MOMENTBODY';

const settingKey_DefaultUploadNSFW = "DFUNSFW";
const settingKey_DefaultUploadOC = "DFUOC";
const settingKey_DefaultUploadUnlist = "DFUNLIST";
const settingKey_DefaultUploadCrosspost = "DFUCP";
const settingKey_DefaultUploadVotingWeigth = "DFUVW";

const settingKey_FixedDownvoteActivated = "FIXEDDVACTIVE";
const settingKey_FixedDownvoteWeight = "FIXEDDVWEIGHT";

const settingKey_DefaultMomentNSFW = "DFMNSFW";
const settingKey_DefaultMomentOC = "DFMOC";
const settingKey_DefaultMomentUnlist = "DFMNLIST";
const settingKey_DefaultMomentCrosspost = "DFMCP";
const settingKey_DefaultMomentVotingWeigth = "DFMVW";

const settingKey_tsLastNotificationSeen = 'LASTNOT';

const settingKey_pincode = "PINC";
const settingKey_videoAutoPause = "VAPAUSE";
const settingKey_disableAnimations = "NOANIMS";

const settingKey_imageUploadService = "IMGUS";

const settingKey_ExploreTags = "EXPTAGS";
const settingKey_GenreTags = "GENRETAGS";

const settingKey_LastHivePost = "LASTHIVEPOST";
const settingKey_HiveStillInCooldown = "LASTHIVEPOSTCOOLDOWN";

const settingKey_BlockedUsers = "BLOCKEDUSERS";

const settingKey_suAcc = "SUACC";
const settingKey_suLogin = "SULOGIN";
const settingKey_twaKey = "TWAKEY";
const settingKey_twaSec = "TWASEC";
const settingKey_ghaCl = "GHACL";
const settingKey_ghaSec = "GHASEC";
const settingKey_ghaRU = "GHARU";
const settingKey_currentHF = "CURHF";

const settingKey_seenMoments = "SEENMOMENTS";

const settingKey_newsTS = "TSLASTNEWS";

const settingKey_TermsAcceptedVersion = "TERMS1.1"; // versioning because:
//if we would update the terms we want to view the updated version also for existing users

// const _txsKey = 'TXS';
const _storage = FlutterSecureStorage();

// PERSIST

Future<void> persistUsernameKey(String username, String priv) async {
  await _storage.write(key: authKey_usernameKey, value: username);
  await _storage.write(key: authKey_privKey, value: priv);
}

Future<void> persistNode(String node) async {
  await _storage.write(key: settingKey_avalonNode, value: node);
}

Future<void> persistExploreTags(String tags) async {
  await _storage.write(key: settingKey_ExploreTags, value: tags);
}

Future<void> persistBlockedUsers(String blocked) async {
  await _storage.write(key: settingKey_BlockedUsers, value: blocked);
}

Future<void> persistGenreTags(String tags) async {
  await _storage.write(key: settingKey_GenreTags, value: tags);
}

Future<void> persistImageUploadService(String service) async {
  await _storage.write(key: settingKey_imageUploadService, value: service);
}

Future<void> persistPinCode(String pin) async {
  await _storage.write(key: settingKey_pincode, value: pin);
}

Future<void> persistVideoAutoPause(String autoPause) async {
  await _storage.write(key: settingKey_videoAutoPause, value: autoPause);
}

Future<void> persistDisableAnimations(String disableAnimations) async {
  await _storage.write(
      key: settingKey_disableAnimations, value: disableAnimations);
}

Future<void> persistLastHivePost() async {
  await _storage.write(
      key: settingKey_LastHivePost, value: DateTime.now().toString());
}

Future<void> persistNotificationSeen(int tsLast) async {
  await _storage.write(
      key: settingKey_tsLastNotificationSeen, value: tsLast.toString());
}

Future<void> persistOnbordingJourneyDone() async {
  await _storage.write(key: settingKey_OpenedOnce, value: "true");
}

Future<void> persistFirstLogin() async {
  await _storage.write(key: settingKey_FirstLogin, value: "false");
}

Future<void> persistCurrentTermsAccepted() async {
  await _storage.write(key: settingKey_TermsAcceptedVersion, value: "true");
}

Future<void> persistHiveSignerData(String accessToken, String expiresIn,
    String requestedOn, String username) async {
  await _storage.write(
      key: settingKey_hiveSignerAccessToken, value: accessToken);
  await _storage.write(
      key: settingKey_hiveSignerAccessTokenExpiresIn, value: expiresIn);
  await _storage.write(
      key: settingKey_hiveSignerAccessTokenRequestedOn, value: requestedOn);
  await _storage.write(key: settingKey_hiveSignerUsername, value: username);
}

Future<void> persistHiveSignerAdditionalData(
    String community, String tags) async {
  await _storage.write(
      key: settingKey_hiveSignerDefaultCommunity, value: community);
  await _storage.write(key: settingKey_hiveSignerDefaultTags, value: tags);
}

// app settings

Future<void> persistGeneralSettings(
    String showHidden, String showNsfw, String imageUploadProvider) async {
  await _storage.write(key: settingKey_showHidden, value: showHidden);
  await _storage.write(key: settingKey_showNSFW, value: showNsfw);
  await _storage.write(
      key: settingKey_imageUploadService, value: imageUploadProvider);
}

Future<void> persistAvalonSettings(
  String defaultVotingWeight,
  String defaultVotingWeightComments,
  String defaultVotingTip,
  String defaultVotingTipComments,
  String fixedDownvoteActive,
  String fixedDownvoteWeight,
) async {
  await _storage.write(
      key: settingKey_defaultVotingWeight, value: defaultVotingWeight);
  await _storage.write(
      key: settingKey_defaultVotingWeightComments,
      value: defaultVotingWeightComments);
  await _storage.write(
      key: settingKey_defaultVotingTip, value: defaultVotingTip);
  await _storage.write(
      key: settingKey_defaultVotingTipComments,
      value: defaultVotingTipComments);
  await _storage.write(
      key: settingKey_FixedDownvoteActivated, value: fixedDownvoteActive);
  await _storage.write(
      key: settingKey_FixedDownvoteWeight, value: fixedDownvoteWeight);
}

Future<void> persistTemplateSettings(
  String templateTitle,
  String templateBody,
  String templateTag,
) async {
  await _storage.write(key: settingKey_templateTitle, value: templateTitle);
  await _storage.write(key: settingKey_templateBody, value: templateBody);
  await _storage.write(key: settingKey_templateTag, value: templateTag);
}

Future<void> persistAdditionalTemplates(
  String templatesJSON,
) async {
  await _storage.write(
      key: settingKey_additionalTemplates, value: templatesJSON);
}

Future<void> persistCurrenNewsTS() async {
  await _storage.write(
      key: settingKey_newsTS,
      value: (DateTime.now().millisecondsSinceEpoch / 1000).toString());
}

Future<void> persistMomentTemplateSettings(
  String templateTitle,
  String templateBody,
) async {
  await _storage.write(key: settingKey_momentTitle, value: templateTitle);
  await _storage.write(key: settingKey_momentBody, value: templateBody);
}

Future<void> persistDefaultUploadAndMomentSettings(
  String uploadVotingWeight,
  String momentVotingWeight,
  String uploadNSFW,
  String uploadOC,
  String uploadUnlist,
  String uploadCrosspost,
  String momentNSFW,
  String momentOC,
  String momentUnlist,
  String momentCrosspost,
) async {
  await _storage.write(key: settingKey_DefaultUploadNSFW, value: uploadNSFW);
  await _storage.write(key: settingKey_DefaultUploadOC, value: uploadOC);
  await _storage.write(
      key: settingKey_DefaultUploadUnlist, value: uploadUnlist);
  await _storage.write(
      key: settingKey_DefaultUploadCrosspost, value: uploadCrosspost);

  await _storage.write(key: settingKey_DefaultMomentNSFW, value: momentNSFW);
  await _storage.write(key: settingKey_DefaultMomentOC, value: momentOC);
  await _storage.write(
      key: settingKey_DefaultMomentUnlist, value: momentUnlist);
  await _storage.write(
      key: settingKey_DefaultMomentCrosspost, value: momentCrosspost);
  await _storage.write(
      key: settingKey_DefaultUploadVotingWeigth, value: uploadVotingWeight);

  await _storage.write(
      key: settingKey_DefaultMomentVotingWeigth, value: momentVotingWeight);
}

Future<void> addSeenMoments(
  String seenMomentpostIdentity,
  String seenMomentTS,
) async {
  String? _seenMoments = "";
  int visibilityDuration = ((DateTime.now()
              .add(Duration(days: AppConfig.momentsPastXDays))
              .millisecondsSinceEpoch /
          1000))
      .round(); // duration until we hide moments from the moments page
  try {
    _seenMoments = await _storage.read(key: settingKey_seenMoments);
  } catch (e) {
    _seenMoments = "[]";
  }
  if (_seenMoments == null) {
    _seenMoments = "[]";
  }
  SeenMomentsList _seenMomentsList = new SeenMomentsList(seenMoments: []);
  // read previous seen Moments
  if (_seenMoments != "[]") {
    var _seenMomentsJSON = jsonDecode(_seenMoments);
    _seenMomentsList = SeenMomentsList.fromJson(_seenMomentsJSON);
  }
  // add new Moment
  _seenMomentsList.seenMoments.add(SeenMoment(
      ts: int.parse(seenMomentTS), postIdentity: seenMomentpostIdentity));

  // remove old moments outside of the duration we show
  for (var m in _seenMomentsList.seenMoments) {
    if (m.ts < visibilityDuration) {
      _seenMomentsList.seenMoments.remove(m);
    }
  }
  // convert new list
  var _seenMomentsJSONResult = _seenMomentsList.toJson();
  //store new list
  await _storage.write(
      key: settingKey_seenMoments, value: jsonEncode(_seenMomentsJSONResult));
}

// PODO Object class for the JSON mapping
class SeenMomentsList {
  late List<SeenMoment> seenMoments;

  SeenMomentsList({required this.seenMoments});

  SeenMomentsList.fromJson(Map<String, dynamic> json) {
    if (json['seenMoments'] != null) {
      seenMoments = [];
      json['seenMoments'].forEach((v) {
        seenMoments.add(new SeenMoment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.seenMoments != null) {
      data['seenMoments'] = this.seenMoments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeenMoment {
  late int ts;
  late String postIdentity; // author/link;

  SeenMoment({required this.ts, required this.postIdentity});

  SeenMoment.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    postIdentity = json['postIdentity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ts'] = this.ts;
    data['postIdentity'] = this.postIdentity;

    return data;
  }
}

// GET

Future<bool> getSeenMomentAlready(String postIdentity) async {
  String? _seenMoments = "";
  try {
    _seenMoments = await _storage.read(key: settingKey_seenMoments);
    if (_seenMoments!.contains(postIdentity)) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false; // fallback: never opened that app before
  }
}

Future<bool> getOnbordingJourneyDone() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_OpenedOnce);
  } catch (e) {
    _setting = "false"; // fallback: never opened that app before
  }
  if (_setting != "true") {
    return false;
  } else {
    return true;
  }
}

Future<bool> getFirstLogin() async {
  String? _firstTimeLogin = "";
  try {
    _firstTimeLogin = await _storage.read(key: settingKey_FirstLogin);
  } catch (e) {
    _firstTimeLogin = "true"; // fallback: never opened that app before
  }
  if (_firstTimeLogin == null || _firstTimeLogin != "false") {
    return true;
  } else {
    return false;
  }
}

Future<bool> getTermsAccepted() async {
  String? _accepted = "";
  try {
    _accepted = await _storage.read(key: settingKey_TermsAcceptedVersion);
  } catch (e) {
    _accepted = "false"; // fallback: not accepted current terms
  }
  if (_accepted == null || _accepted != "true") {
    return false;
  } else {
    return true;
  }
}

Future<int> getSecondsUntilHiveCooldownEnds() async {
  DateTime _curTime = new DateTime.now(); //Current local time
  try {
    // read DateTime of last hive post
    String? _lastPostString = await _storage.read(key: settingKey_LastHivePost);
    if (_lastPostString != null) {
      DateTime _lastPost = DateTime.parse(_lastPostString);
      int _timeUntilCooldownEnds =
          _lastPost.add(Duration(seconds: 300)).difference(_curTime).inSeconds;
      if (_timeUntilCooldownEnds > 0) {
        return _timeUntilCooldownEnds;
      } else {
        return 0;
      }
    } else {
      return 0;
    }

    // if no DateTime found or it is not parsable
    // it was never set before
  } catch (e) {
    return 0;
  }
}

Future<String> getUsername() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: authKey_usernameKey);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getBlockedUsers() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_BlockedUsers);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getImageUploadService() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_imageUploadService);
  } catch (e) {
    _setting = "imgur";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "imgur";
  }
}

Future<String> getPinCode() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_pincode);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getVideoAutoPause() async {
  String? _setting = "false";
  try {
    _setting = await _storage.read(key: settingKey_videoAutoPause);
  } catch (e) {
    _setting = "false";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "false";
  }
}

Future<String> getDisableAnimations() async {
  String? _setting = "false";
  try {
    _setting = await _storage.read(key: settingKey_disableAnimations);
  } catch (e) {
    _setting = "false";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "false";
  }
}

Future<String> getTemplateTitle() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_templateTitle);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentTitle() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_momentTitle);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getExploreTags() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_ExploreTags);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getGenreTags() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_GenreTags);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getTemplateBody() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_templateBody);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getAdditionalTemplates() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_additionalTemplates);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentBody() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_momentBody);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getTemplateTag() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_templateTag);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadNSFW() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultUploadNSFW);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadOC() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultUploadOC);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadUnlist() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultUploadUnlist);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadCrosspost() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultUploadCrosspost);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentNSFW() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultMomentNSFW);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentOC() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultMomentOC);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentUnlist() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultMomentUnlist);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentCrosspost() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultMomentCrosspost);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadVotingWeight() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultUploadVotingWeigth);
  } catch (e) {
    _setting = "5.0";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "5.0";
  }
}

Future<String> getMomentVotingWeight() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_DefaultMomentVotingWeigth);
  } catch (e) {
    _setting = "5.0";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "5.0";
  }
}

Future<String> getPrivateKey() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: authKey_privKey);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<Map<String, String>> getAllSettings() async {
  // here perhaps trycatch
  var _allSettings = await _storage.readAll();
  return _allSettings;
}

Future<String> getHiveSignerAccessToken() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_hiveSignerAccessToken);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '';
  }
}

Future<String> getHiveSignerDefaultCommunity() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_hiveSignerDefaultCommunity);
  } catch (e) {
    _setting = "hive-196037";
  }

  if (_setting != null && _setting.startsWith("hive-")) {
    return _setting;
  } else {
    return 'hive-196037';
  }
}

Future<String> getHiveSignerDefaultTags() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_hiveSignerDefaultTags);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getHiveSignerAccessTokenExpiresIn() async {
  String? _setting = "";
  try {
    _setting =
        await _storage.read(key: settingKey_hiveSignerAccessTokenExpiresIn);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '';
  }
}

Future<String> getHiveSignerAccessTokenRequestedOn() async {
  String? _setting = "";
  try {
    _setting =
        await _storage.read(key: settingKey_hiveSignerAccessTokenRequestedOn);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '';
  }
}

Future<String> getHiveSignerUsername() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_hiveSignerUsername);
  } catch (e) {
    _setting = "";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '';
  }
}

Future<String> getNode() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_avalonNode);
  } catch (e) {
    _setting = "https://avalon.d.tube";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return 'https://avalon.d.tube';
  }
}

Future<String> getLastNotification() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_tsLastNotificationSeen);
  } catch (e) {
    _setting = "0";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '0';
  }
}

Future<String> getNewsTS() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_newsTS);
  } catch (e) {
    _setting = "0";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return "0";
  }
}

Future<String> getDefaultVote() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_defaultVotingWeight);
  } catch (e) {
    _setting = "5";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '5';
  }
}

Future<String> getDefaultVoteComments() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_defaultVotingWeightComments);
  } catch (e) {
    _setting = "5";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '5';
  }
}

Future<String> getDefaultVoteTip() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_defaultVotingTip);
  } catch (e) {
    _setting = "25";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '25';
  }
}

Future<String> getDefaultVoteTipComments() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_defaultVotingTipComments);
  } catch (e) {
    _setting = "25";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '25';
  }
}

Future<String> getFixedDownvoteActivated() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_FixedDownvoteActivated);
  } catch (e) {
    _setting = "true";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return 'true';
  }
}

Future<String> getFixedDownvoteWeight() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_FixedDownvoteWeight);
  } catch (e) {
    _setting = "1";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return '1';
  }
}

Future<String> getShowHidden() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_showHidden);
  } catch (e) {
    _setting = "Hide";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return 'Hide';
  }
}

Future<String> getNSFW() async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: settingKey_showNSFW);
  } catch (e) {
    _setting = "Hide";
  }

  if (_setting != null) {
    return _setting;
  } else {
    return 'Hide';
  }
}

Future<String> getLocalConfigString(String configKey) async {
  String? _setting = "";
  try {
    _setting = await _storage.read(key: configKey);
  } catch (e) {
    _setting = "";
  }
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

// DELETE

Future<bool> deleteUsernameKey() async {
  await _storage.delete(key: authKey_usernameKey);
  await _storage.delete(key: authKey_privKey);
  return true;
}

Future<bool> deleteAllSettings() async {
  await _storage.deleteAll();
  return true;
}

Future<bool> deleteHiveSignerSettings() async {
  await _storage.delete(key: settingKey_hiveSignerUsername);
  await _storage.delete(key: settingKey_hiveSignerAccessToken);
  await _storage.delete(key: settingKey_hiveSignerAccessTokenExpiresIn);
  await _storage.delete(key: settingKey_hiveSignerAccessTokenRequestedOn);
  return true;
}
