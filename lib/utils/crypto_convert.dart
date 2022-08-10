import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:elliptic/elliptic.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

String privToPub(String privateKey) {
  PrivateKey _pk = PrivateKey.fromHex(
      getSecp256k1(), HEX.encode(bs58check.base58.decode(privateKey)));
  return base58
      .encode(Uint8List.fromList(HEX.decode(_pk.publicKey.toCompressedHex())));
}

String getSHA256String(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}

String getMD5String(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
