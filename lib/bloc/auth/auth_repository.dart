import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/utils/globalVariables.dart' as globals;

import 'package:dtube_go/bloc/auth/auth_response_model.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/utils/privToPub.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:elliptic/elliptic.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

abstract class AuthRepository {
  Future<bool> signOut();
  Future<bool> signInWithCredentials(
      String apiNode, String username, String privateKey);
  void fetchAndStoreVerifiedUsers();
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
        throw e;
      });
    } catch (e) {
      throw e;
    }
    if (response.statusCode == 404) {
      // username unknown
      _keyIsValid = false;
    } else {
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        Auth authInformation = ApiResultModel.fromJson(data).auth;
        if (pub.toString() == authInformation.pub) {
          _keyIsValid = true;
          for (var txType in txTypes.keys) {
            globals.keyPermissions.add(txType);
          }
          print(globals.keyPermissions);
        } else {
          for (Keys key in authInformation.keys) {
            if (key.pub == pub.toString()) {
              _keyIsValid = true;
              globals.keyPermissions = key.types;
              print(globals.keyPermissions);
              break;
            }
          }
        }

        //check if key is enough to login

      } else {
        throw Exception();
      }
    }
    return _keyIsValid;
  }

  void fetchAndStoreVerifiedUsers() async {
    var response = await http.get(Uri.parse(AppConfig.originalDtuberListUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      globals.verifiedUsers = List.from(data);
    }
  }
}
