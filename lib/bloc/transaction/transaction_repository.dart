import 'dart:typed_data';

import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'package:dtube_go/bloc/transaction/transaction_response_model.dart';

import 'package:hex/hex.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:bs58/bs58.dart';

import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';

// see more reference here: https://github.com/dtube/dtube/blob/master/client/broadcast.js

abstract class TransactionRepository {
  Future<Transaction> sign(
      Transaction tx, String applicationUser, String privKey);
  Future<String> send(String apiNode, Transaction tx);
}

class TransactionRepositoryImpl implements TransactionRepository {
  // TODO: still buggy
  // https://github.com/C0MM4ND/dart-secp256k1/issues/6

  Future<Transaction> sign(
      Transaction tx, String applicationUser, String privKey) async {
    var ec = getS256();

    Transaction txNew = Transaction(type: tx.type, data: tx.data);

    txNew.sender = applicationUser; // set sender of tx
    txNew.ts = DateTime.now().millisecondsSinceEpoch; // set timestamp

    var jsonString = jsonEncode(txNew.toJson());
    List<int> txBytes = utf8.encode(jsonString);

    Digest digest = sha256.convert(txBytes);
    var messageHash = digest.toString();

    txNew.hash = messageHash;

    String pkHex = HEX.encode(base58.decode(privKey));

    PrivateKey _pk = PrivateKey.fromHex(ec, pkHex);

    Signature _sig = deterministicSign(_pk, HEX.decode(messageHash));
    String _sigHex = _sig.R.toRadixString(16).padLeft(64, '0') + // r's hex
        _sig.S.toRadixString(16).padLeft(64, '0');
    // String _sigHex = _sig.toString();

    Uint8List sigBytes = Uint8List.fromList(HEX.decode(_sigHex));
    print(sigBytes.length);
    String _sigB58 = base58.encode(sigBytes);
    txNew.signature = _sigB58;
    return txNew;
  }

  Future<String> send(String apiNode, Transaction tx) async {
    var response =
        await http.post(Uri.parse(apiNode + AppConfig.sendTransactionUrl),
            headers: {
              'Accept': 'application/json, text/plain, */*',
              'Content-Type': 'application/json'
            },
            body: jsonEncode(tx.toJson()));
    print(jsonEncode(tx.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.body);
      throw Exception();
    } // should be the block
  }
}
