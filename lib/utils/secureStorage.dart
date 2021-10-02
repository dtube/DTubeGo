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

const settingKey_OpenedOnce = 'OPENEDONCE';

// TODO: multiple templates?
const settingKey_templateTitle = 'TEMPLATETITLE';
const settingKey_templateBody = 'TEMPLATEBODY';
const settingKey_templateTag = 'TEMPLATETAG';

const settingKey_DefaultUploadNSFW = "DFUNSFW";
const settingKey_DefaultUploadOC = "DFUOC";
const settingKey_DefaultUploadUnlist = "DFUNLIST";
const settingKey_DefaultUploadCrosspost = "DFUCP";
const settingKey_DefaultUploadVotingWeigth = "DFUVW";

const settingKey_DefaultMomentNSFW = "DFMNSFW";
const settingKey_DefaultMomentOC = "DFMOC";
const settingKey_DefaultMomentUnlist = "DFMNLIST";
const settingKey_DefaultMomentCrosspost = "DFMCP";
const settingKey_DefaultMomentVotingWeigth = "DFMVW";

const settingKey_tsLastNotificationSeen = 'LASTNOT';

const settingKey_pincode = "PINC";

const settingKey_imageUploadService = "IMGUS";

const settingKey_ExploreTags = "EXPTAGS";

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

Future<void> persistImageUploadService(String service) async {
  await _storage.write(key: settingKey_imageUploadService, value: service);
}

Future<void> persistPinCode(String pin) async {
  await _storage.write(key: settingKey_pincode, value: pin);
}

Future<void> persistNotificationSeen(int tsLast) async {
  await _storage.write(
      key: settingKey_tsLastNotificationSeen, value: tsLast.toString());
}

Future<void> persistOpenedOnce() async {
  await _storage.write(key: settingKey_OpenedOnce, value: "true");
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

// GET

Future<bool> getOpenedOnce() async {
  var _openedOnce = await _storage.read(key: settingKey_OpenedOnce);
  if (_openedOnce == null || _openedOnce != "true") {
    return false;
  } else {
    return true;
  }
}

Future<String> getUsername() async {
  var _setting = await _storage.read(key: authKey_usernameKey);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getImageUploadService() async {
  var _setting = await _storage.read(key: settingKey_imageUploadService);
  if (_setting != null) {
    return _setting;
  } else {
    return "imgur";
  }
}

Future<String> getPinCode() async {
  var _setting = await _storage.read(key: settingKey_pincode);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getTemplateTitle() async {
  var _setting = await _storage.read(key: settingKey_templateTitle);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getExploreTags() async {
  var _setting = await _storage.read(key: settingKey_ExploreTags);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getTemplateBody() async {
  var _setting = await _storage.read(key: settingKey_templateBody);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getTemplateTag() async {
  var _setting = await _storage.read(key: settingKey_templateTag);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadNSFW() async {
  var _setting = await _storage.read(key: settingKey_DefaultUploadNSFW);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadOC() async {
  var _setting = await _storage.read(key: settingKey_DefaultUploadOC);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadUnlist() async {
  var _setting = await _storage.read(key: settingKey_DefaultUploadUnlist);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadCrosspost() async {
  var _setting = await _storage.read(key: settingKey_DefaultUploadCrosspost);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentNSFW() async {
  var _setting = await _storage.read(key: settingKey_DefaultMomentNSFW);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentOC() async {
  var _setting = await _storage.read(key: settingKey_DefaultMomentOC);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentUnlist() async {
  var _setting = await _storage.read(key: settingKey_DefaultMomentUnlist);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getMomentCrosspost() async {
  var _setting = await _storage.read(key: settingKey_DefaultMomentCrosspost);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<String> getUploadVotingWeight() async {
  var _setting = await _storage.read(key: settingKey_DefaultUploadVotingWeigth);
  if (_setting != null) {
    return _setting;
  } else {
    return "5.0";
  }
}

Future<String> getMomentVotingWeight() async {
  var _setting = await _storage.read(key: settingKey_DefaultMomentVotingWeigth);
  if (_setting != null) {
    return _setting;
  } else {
    return "5.0";
  }
}

Future<String> getPrivateKey() async {
  var _setting = await _storage.read(key: authKey_privKey);
  if (_setting != null) {
    return _setting;
  } else {
    return "";
  }
}

Future<Map<String, String>> getAllSettings() async {
  var _allSettings = await _storage.readAll();
  return _allSettings;
}

Future<String> getHiveSignerAccessToken() async {
  var _accessToken = await _storage.read(key: settingKey_hiveSignerAccessToken);
  if (_accessToken != null) {
    return _accessToken;
  } else {
    return '';
  }
}

Future<String> getHiveSignerAccessTokenExpiresIn() async {
  var _accessTokenExpiresIn =
      await _storage.read(key: settingKey_hiveSignerAccessTokenExpiresIn);
  if (_accessTokenExpiresIn != null) {
    return _accessTokenExpiresIn;
  } else {
    return '';
  }
}

Future<String> getHiveSignerAccessTokenRequestedOn() async {
  var _accessTokenRequestedOn =
      await _storage.read(key: settingKey_hiveSignerAccessTokenRequestedOn);
  if (_accessTokenRequestedOn != null) {
    return _accessTokenRequestedOn;
  } else {
    return '';
  }
}

Future<String> getHiveSignerUsername() async {
  var _username = await _storage.read(key: settingKey_hiveSignerUsername);
  if (_username != null) {
    return _username;
  } else {
    return '';
  }
}

Future<String> getNode() async {
  var _setting = await _storage.read(key: settingKey_avalonNode);
  if (_setting != null) {
    return _setting;
  } else {
    return 'https://avalon.d.tube';
  }
}

Future<String> getLastNotification() async {
  var _setting = await _storage.read(key: settingKey_tsLastNotificationSeen);
  if (_setting != null) {
    return _setting;
  } else {
    return '0';
  }
}

Future<String> getDefaultVote() async {
  var _setting = await _storage.read(key: settingKey_defaultVotingWeight);
  if (_setting != null) {
    return _setting;
  } else {
    return '5';
  }
}

Future<String> getDefaultVoteComments() async {
  var _setting =
      await _storage.read(key: settingKey_defaultVotingWeightComments);
  if (_setting != null) {
    return _setting;
  } else {
    return '5';
  }
}

Future<String> getDefaultVoteTip() async {
  var _setting = await _storage.read(key: settingKey_defaultVotingTip);
  if (_setting != null) {
    return _setting;
  } else {
    return '25';
  }
}

Future<String> getDefaultVoteTipComments() async {
  var _setting = await _storage.read(key: settingKey_defaultVotingTipComments);
  if (_setting != null) {
    return _setting;
  } else {
    return '25';
  }
}

Future<String> getShowHidden() async {
  var _setting = await _storage.read(key: settingKey_showHidden);
  if (_setting != null) {
    return _setting;
  } else {
    return 'Hide';
  }
}

Future<String> getNSFW() async {
  var _setting = await _storage.read(key: settingKey_showNSFW);
  if (_setting != null) {
    return _setting;
  } else {
    return 'Hide';
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
