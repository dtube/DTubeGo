import 'package:dtube_togo/bloc/auth/auth_response_model.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO: refactor and put in the right place ;)

import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:elliptic/elliptic.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

abstract class AuthRepository {
  Future<bool> signOut();
  Future<bool> signInWithCredentials(
      String apiNode, String username, String privateKey);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  @override
  Future<bool> signOut() async {
    var deleted = await sec.deleteUsernameKey();
    if (deleted) {
      return true;
    } else {
      throw Exception();
    }
  }

  @override
  Future<bool> signInWithCredentials(
      String apiNode, String username, String privateKey) async {
    bool _keyIsValid = false;

    var pub = privToPub(privateKey);

//load user
    var response;
    try {
      response = await http
          .get(
        Uri.parse(apiNode +
            AppConfig.accountDataUrl.replaceAll("##USERNAME", username)),
      )
          .catchError((e) {
        throw Exception();
      });
    } catch (e) {
      throw Exception();
    }
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Auth authInformation = ApiResultModel.fromJson(data).auth;
      if (pub.toString() == authInformation.pub) {
        _keyIsValid = true;
      } else {
        for (Keys key in authInformation.keys) {
          if (key.pub == pub.toString()) {
            // availableTxTypes = key.types;
            _keyIsValid = true;
            break;
          }
        }
      }
      //check if key is enough to login
      return _keyIsValid;
    } else {
      throw Exception();
    }
  }

  String privToPub(String privateKey) {
    PrivateKey _pk = PrivateKey.fromHex(
        getSecp256k1(), HEX.encode(bs58check.base58.decode(privateKey)));

    var pub = base58.encode(
        Uint8List.fromList(HEX.decode(_pk.publicKey.toCompressedHex())));

    return pub;
  }
}
