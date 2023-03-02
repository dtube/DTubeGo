import 'dart:convert';
import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:crypto/crypto.dart';
import 'package:dtube_go/utils/Crypto/crypto_convert.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:hex/hex.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class SignData {
  String? username;
  int? ts;
  String? signature;
  String? hash;
  String? pubkey;
  Object? data;

  SignData({required this.data, this.ts, this.username, this.pubkey});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> txdata = new Map<String, dynamic>();
    txdata['data'] = this.data;

    if (this.username != null) {
      txdata['username'] = this.username;
    }

    if (this.ts != null) {
      txdata['ts'] = this.ts;
    }

    if (this.signature != null) {
      txdata['signature'] = this.signature;
    }

    if (this.hash != null) {
      txdata['hash'] = this.hash;
    }

    if (this.pubkey != null) {
      txdata['pubkey'] = this.pubkey;
    }

    return txdata;
  }
}

class DataSigner extends Object {
  String? signature;
  int? ts;
  String? hash;

  String? username;
  String? data;
  String? pubkey;

  Map<String, dynamic> toJson() {
    return {
      'data': this.data,
      'ts': this.ts,
      'username': this.username,
      'pubkey': this.pubkey,
      'hash': this.hash,
      'signature': this.signature
    };
  }
  Future<SignData> signOffchainData(
      String data, String applicationUser, int ts) async {
    var ec = getS256();
    final String privKey = await sec.getPrivateKey();
    var dataNew = new SignData(data: data, ts: ts, pubkey: privToPub(privKey), username: applicationUser);

    //var jsonString = dataNew.toString();
    var jsonString = data;
    List<int> txBytes = utf8.encode(jsonString);

    Digest digest = sha256.convert(txBytes);
    var messageHash = digest.toString();

    dataNew.hash = messageHash;
    dataNew.pubkey = privToPub(privKey);

    String pkHex = HEX.encode(base58.decode(privKey));

    PrivateKey _pk = PrivateKey.fromHex(ec, pkHex);

    Signature _sig = deterministicSign(_pk, HEX.decode(messageHash));
    String _sigHex = _sig.R.toRadixString(16).padLeft(64, '0') + // r's hex
        _sig.S.toRadixString(16).padLeft(64, '0');
    // String _sigHex = _sig.toString();

    Uint8List sigBytes = Uint8List.fromList(HEX.decode(_sigHex));
    print(sigBytes.length);
    String _sigB58 = base58.encode(sigBytes);
    dataNew.signature = _sigB58;
    return dataNew;
  }
}