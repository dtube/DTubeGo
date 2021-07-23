import 'package:dtube_togo/bloc/hivesigner/hivesigner_response_model.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:elliptic/elliptic.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

abstract class HivesignerRepository {
  Future<bool> requestNewAccessToken();
  Future<bool> checkCurrentAccessToken();
}

// TODO: error handling
class HivesignerRepositoryImpl implements HivesignerRepository {
  @override
  Future<bool> requestNewAccessToken() async {
    final result = await FlutterWebAuth.authenticate(
        url: AppConfig.hiveSignerUrl,
        callbackUrlScheme: AppConfig.hiveSignerCallbackUrlScheme);

    Uri _uri = Uri.parse(result);
    String _accessToken = _uri.queryParameters['access_token'].toString();
    String _expiresIn = _uri.queryParameters['expires_in'].toString();

    String _accessTokenRequestedOn = new DateTime.now().toString();

    await sec.persistHiveSignerData(
        _accessToken, _expiresIn, _accessTokenRequestedOn);
    return true;
  }

  @override
  Future<bool> checkCurrentAccessToken() async {
    String _hivesignerAccessToken = await sec.getHiveSignerAccessToken();
    String _hivesignerAccessTokenExpiresIn =
        await sec.getHiveSignerAccessTokenExpiresIn();
    String _hivesignerAccessTokenRequestedOn =
        await sec.getHiveSignerAccessTokenRequestedOn();
    // check if set
    if (_hivesignerAccessToken != '') {
      DateTime requestDate = DateTime.parse(_hivesignerAccessTokenRequestedOn);
      if (DateTime.now().isAfter(requestDate.add(
          Duration(seconds: int.parse(_hivesignerAccessTokenExpiresIn))))) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
