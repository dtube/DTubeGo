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

const settingKey_tsLastNotificationSeen = 'LASTNOT';

const settingKey_pincode = "PINC";

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
  String showHidden,
  String showNsfw,
) async {
  await _storage.write(key: settingKey_showHidden, value: showHidden);
  await _storage.write(key: settingKey_showNSFW, value: showNsfw);
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
  var _username = await _storage.read(key: authKey_usernameKey);
  if (_username != null) {
    return _username;
  } else {
    return "";
  }
}

Future<String> getPinCode() async {
  var _pin = await _storage.read(key: settingKey_pincode);
  if (_pin != null) {
    return _pin;
  } else {
    return "";
  }
}

Future<String> getTemplateTitle() async {
  var _title = await _storage.read(key: settingKey_templateTitle);
  if (_title != null) {
    return _title;
  } else {
    return "";
  }
}

Future<String> getTemplateBody() async {
  var _body = await _storage.read(key: settingKey_templateBody);
  if (_body != null) {
    return _body;
  } else {
    return "";
  }
}

Future<String> getTemplateTag() async {
  var _tag = await _storage.read(key: settingKey_templateTag);
  if (_tag != null) {
    return _tag;
  } else {
    return "";
  }
}

Future<String> getPrivateKey() async {
  var _privKey = await _storage.read(key: authKey_privKey);
  if (_privKey != null) {
    return _privKey;
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
  var _node = await _storage.read(key: settingKey_avalonNode);
  if (_node != null) {
    return _node;
  } else {
    return 'https://avalon.d.tube';
  }
}

Future<String> getLastNotification() async {
  var _lastNotification =
      await _storage.read(key: settingKey_tsLastNotificationSeen);
  if (_lastNotification != null) {
    return _lastNotification;
  } else {
    return '0';
  }
}

Future<String> getDefaultVote() async {
  var _voteWeight = await _storage.read(key: settingKey_defaultVotingWeight);
  if (_voteWeight != null) {
    return _voteWeight;
  } else {
    return '5';
  }
}

Future<String> getDefaultVoteComments() async {
  var _voteWeight =
      await _storage.read(key: settingKey_defaultVotingWeightComments);
  if (_voteWeight != null) {
    return _voteWeight;
  } else {
    return '5';
  }
}

Future<String> getDefaultVoteTip() async {
  var _voteWeight = await _storage.read(key: settingKey_defaultVotingTip);
  if (_voteWeight != null) {
    return _voteWeight;
  } else {
    return '25';
  }
}

Future<String> getDefaultVoteTipComments() async {
  var _voteWeight =
      await _storage.read(key: settingKey_defaultVotingTipComments);
  if (_voteWeight != null) {
    return _voteWeight;
  } else {
    return '25';
  }
}

Future<String> getShowHidden() async {
  var _hiddenMode = await _storage.read(key: settingKey_showHidden);
  if (_hiddenMode != null) {
    return _hiddenMode;
  } else {
    return 'Hide';
  }
}

Future<String> getNSFW() async {
  var _nsfwMode = await _storage.read(key: settingKey_showNSFW);
  if (_nsfwMode != null) {
    return _nsfwMode;
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
