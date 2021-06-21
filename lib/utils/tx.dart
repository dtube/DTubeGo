import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:secp256k1/secp256k1.dart';

import 'dart:convert';

// Future<void> signTx(String username, String priv) async {
//   await _storage.write(key: _usernameKey, value: username);
//   await _storage.write(key: _privKey, value: priv);
// }

class Tx {
  String? sender;
  int? ts;
  String? signature;
  String? hash;
  int type;
  String data;

  Tx({required this.type, required this.data});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['ts'] = this.ts;
    data['signature'] = this.signature;
    data['hash'] = this.hash;
    data['type'] = this.type;
    data['data'] = this.data;

    return data;
  }

// usage:
// Tx tx = new Tx(type: 4, data: '{target: "bob"}');
  // var sig =
  //     tx.sign('HbC8b2xaELb1CC4qWGHWgWd5JoyVhb2UKYzaKvQUrTpp', 'tibfox', tx);

  Tx sign(String privKey, String sender, Tx tx) {
    final jsonEncoder = JsonEncoder();

    tx.sender = sender;
    // add timestamp to seed the hash (avoid transactions reuse)
    tx.ts = DateTime.now().millisecondsSinceEpoch;
    var txBytes = utf8.encode(jsonEncoder.convert(tx));
// // hash the transaction
    tx.hash = sha256.convert(txBytes).toString();
    var pk = PrivateKey.fromHex(HEX.encode(bs58check.base58.decode(privKey)));

    var sig = pk.signature(tx.hash!);
    // sign verification result -> probably always true
    print(sig.verify(pk.publicKey, tx.hash!));

    return tx;
  }
}



// privToPub: (priv) => {
//         return bs58.encode(
//             secp256k1.publicKeyCreate(
//                 bs58.decode(priv)))
//     },
//     sign: (privKey, sender, tx) => {
//         if (typeof tx !== 'object')
//             try {
//                 tx = JSON.parse(tx)
//             } catch(e) {
//                 console.log('invalid transaction')
//                 return
//             }


//         tx.sender = sender
//         // add timestamp to seed the hash (avoid transactions reuse)
//         tx.ts = new Date().getTime()
//         // hash the transaction
//         tx.hash = CryptoJS.SHA256(JSON.stringify(tx)).toString()
//         // sign the transaction
//         let signature = secp256k1.ecdsaSign(Buffer.from(tx.hash, 'hex'), bs58.decode(privKey))
//         tx.signature = bs58.encode(signature.signature)
//         return tx
//     },
//     sendTransaction: (tx, cb) => {
//         // sends a transaction to a node
//         // waits for the transaction to be included in a block
//         // 200 with head block number if confirmed
//         // 408 if timeout
//         // 500 with error if transaction is invalid
//         fetch(avalon.randomNode()+'/transactWaitConfirm', {
//             method: 'post',
//             headers: {
//                 'Accept': 'application/json, text/plain, */*',
//                 'Content-Type': 'application/json'
//             },
//             body: JSON.stringify(tx)
//         }).then(function(res) {
//             if (res.status === 500 || res.status === 408) 
//                 res.json().then(function(err) {
//                     cb(err)
//                 })
//             else if (res.status === 404)
//                 cb({error: 'Avalon API is down'})
//             else 
//                 res.text().then(function(headBlock) {
//                     cb(null, parseInt(headBlock))
//                 })
//         })
//     },