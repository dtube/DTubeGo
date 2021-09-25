import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/res/appConfigValues.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class HivesignerRepository {
  Future<bool> requestNewAccessToken(String username);
  Future<bool> checkCurrentAccessToken();
  Future<bool> broadcastPostToHive(String transactionBody);
  Future<String> preparePostTransaction(
      String permlink,
      String title,
      String body,
      String dtubeUrl,
      String thumbnailUrl,
      String videoUrl,
      String storageType,
      String tag);
}

// TODO: error handling
class HivesignerRepositoryImpl implements HivesignerRepository {
  @override
  Future<bool> requestNewAccessToken(String username) async {
    final result = await FlutterWebAuth.authenticate(
        url: AppConfig.hiveSignerAccessTokenUrl,
        callbackUrlScheme: AppConfig.hiveSignerCallbackUrlScheme);

    Uri _uri = Uri.parse(result);
    String _accessToken = _uri.queryParameters['access_token'].toString();
    String _expiresIn = _uri.queryParameters['expires_in'].toString();

    String _accessTokenRequestedOn = new DateTime.now().toString();

    await sec.persistHiveSignerData(
        _accessToken, _expiresIn, _accessTokenRequestedOn, username);
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

  @override
  Future<bool> broadcastPostToHive(String transactionBody) async {
    String _accessToken = await sec.getHiveSignerAccessToken();
    final headers = {
      'Authorization': _accessToken,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var response;
    try {
      response = await http
          .post(
        Uri.parse(AppConfig.hiveSignerBroadcastAddress),
        headers: headers,
        body: transactionBody,
      )
          .catchError((e) {
        throw Exception();
      });
    } catch (e) {
      throw Exception();
    }
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["errors"] == null) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception();
    }
  }

  @override
  Future<String> preparePostTransaction(
      String permlink,
      String title,
      String body,
      String dtubeUrl,
      String thumbnailUrl,
      String videoUrl,
      String storageType,
      String tag) async {
    String _hiveUsername = await sec.getHiveSignerUsername();
    String _hiveBody = genHiveBody(
        _hiveUsername, permlink, body, thumbnailUrl, videoUrl, storageType);

    var _transactionJson = {
      "operations": [
        [
          "comment",
          {
            "parent_author": "",
            "parent_permlink": 'hive-196037',

            "author": _hiveUsername,
            "category": 'hive-196037', // dtube community
            "permlink": permlink,
            "title": title,
            "body": _hiveBody,
            "json_metadata":
                "{\"tags\":[\"dtube\",\"${tag}\"],\"app\":\"dtubemobile\/1.0\"}"
          }
        ],
        [
          "comment_options",
          {
            "author": _hiveUsername,
            "permlink": permlink,
            "max_accepted_payout": "1000000.000 HBD",
            "percent_hbd": 10000,
            "allow_votes": true,
            "allow_curation_rewards": true,
            "extensions": [
              [
                0,
                {
                  "beneficiaries": [
                    {"account": "dtube", "weight": 1000}
                  ]
                }
              ]
            ]
          }
        ]
      ]
    };

    return json.encode(_transactionJson);
  }

  String genHiveBody(String author, String permlink, String postBody,
      String thumbnailUrl, String videoUrl, String storageType) {
    String body = '<center>';
    body += '<a href=\'https://d.tube/#!/v/' + author + '/' + permlink + '\'>';
    if (storageType == "ipfs") {
      body += '<img src=\'' +
          AppConfig.ipfsSnapUrl +
          thumbnailUrl +
          '\' ></a></center><hr>';
    }
    if (storageType == "youtube") {
      body += '<img src=\'' + thumbnailUrl + '\' ></a></center><hr>';
    }

    body += postBody;

    body += '\n\n<hr>';
    body += '<a href=\'https://d.tube/#!/v/' +
        author +
        '/' +
        permlink +
        '\'> ▶️ DTube</a><br />';

    if (storageType == "ipfs")
      body += '<a href=\'https://ipfs.io/ipfs/' +
          videoUrl +
          '\'> ▶️ IPFS</a><br />';
    if (storageType == "btfs")
      body += '<a href=\'https://btfs.d.tube/btfs/' +
          videoUrl +
          '\'> ▶️ BTFS</a><br />';
    if (storageType == "sia")
      body += '<a href=\'https://siasky.net/' +
          videoUrl +
          '\'> ▶️ Skynet</a><br />';
    return body;
  }
}
