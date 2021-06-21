import 'dart:typed_data';

import 'package:dtube_togo/res/strings/strings.dart';
import 'package:http/http.dart' as http;
import 'package:dtube_togo/bloc/transaction/transaction_response_model.dart';

import 'package:hex/hex.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:bs58/bs58.dart';

// see more reference here: https://github.com/dtube/dtube/blob/master/client/broadcast.js

abstract class TransactionRepository {
  Future<Transaction> sign(
      Transaction tx, String applicationUser, String privKey);
  Future<String> send(String apiNode, Transaction tx);
}

class TransactionRepositoryImpl implements TransactionRepository {
  // seek help here:
  // https://github.com/C0MM4ND/dart-secp256k1/issues/2

  Future<Transaction> sign(
      Transaction tx, String applicationUser, String privKey) async {
    Transaction txNew = Transaction(type: tx.type, data: tx.data);

    txNew.sender = applicationUser; // set sender of tx
    txNew.ts = DateTime.now().millisecondsSinceEpoch; // set timestamp

    var jsonString = jsonEncode(txNew.toJson());
    List<int> txBytes = utf8.encode(jsonString);

    Digest digest = sha256.convert(txBytes);
    txNew.hash = digest.toString();

    String pkHex = HEX.encode(base58.decode(privKey));

    PrivateKey _pk = PrivateKey.fromHex(pkHex);

    Signature _sig = _pk.signature(digest.toString());
    print(_sig.S);
    String _sigHex = _sig.toString();

    Uint8List sigBytes = Uint8List.fromList(HEX.decode(_sigHex));
    String _sigB58 = base58.encode(sigBytes);
    txNew.signature = _sigB58;

    print(_sig.verify(
        _pk.publicKey, digest.toString())); // of course always returns true

    return txNew;
  }

  Future<String> send(String apiNode, Transaction tx) async {
    var response =
        await http.post(Uri.parse(apiNode + AppStrings.sendTransactionUrl),
            headers: {
              'Accept': 'application/json, text/plain, */*',
              'Content-Type': 'application/json'
            },
            body: jsonEncode(tx.toJson()));
    print(jsonEncode(tx.toJson()));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      return response.body;
    } else {
      print(response.body);
      throw Exception();
    } // should be the block
  }
}
