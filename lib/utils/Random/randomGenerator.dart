import 'package:bs58/bs58.dart';

import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:elliptic/elliptic.dart';
import 'dart:math';
import 'package:hex/hex.dart';
import 'dart:typed_data';

int generateRandom(int min, int max) {
  var _rn = new Random();
  var _randomInt = min + _rn.nextInt(max - min);
  print(_randomInt);
  return _randomInt;
}

List<String> generateNewKeyPair() {
  var ec = getSecp256k1();
  var _pk = ec.generatePrivateKey();

  var pub = base58
      .encode(Uint8List.fromList(HEX.decode(_pk.publicKey.toCompressedHex())));

  var priv = base58.encode(Uint8List.fromList(_pk.bytes));

  print('privateKey: 0x${priv}');
  print('publicKey: 0x$pub');
  return [pub, priv];
}
