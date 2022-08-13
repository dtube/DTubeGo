import 'package:dtube_go/utils/Crypto/crypto_convert.dart';
import 'package:encrypt/encrypt.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';

// https://medium.com/codechai/when-firebase-meets-bloc-pattern-fb5c405597e0

abstract class ThirdPartyLoginRepository {
  Future<ThirdPartyLoginEncrypted> tryThirdPartyLogin(
      String provider, String socialId);

  Future<bool> storeThirdPartyLogin(ThirdPartyLoginEncrypted data);

  Future<ThirdPartyLoginDecrypted> decryptThirdPartyLogin(
      ThirdPartyLoginEncrypted data, String password, String socialUId);
  Future<ThirdPartyLoginEncrypted> encryptThirdPartyLogin(
      ThirdPartyLoginDecrypted data, String password, String socialUId);
}

class ThirdPartyLoginRepositoryImpl implements ThirdPartyLoginRepository {
  @override
  Future<ThirdPartyLoginEncrypted> tryThirdPartyLogin(
      String provider, String uid) async {
    try {
      final String _uidHash = getSHA256String(uid);
      final CollectionReference _sociallogins =
          FirebaseFirestore.instance.collection('sociallogins');
// check if user already in firebase
      var queryresult = await _sociallogins
          .where("socialLogin_account", isEqualTo: _uidHash)
          .where("socialLogin_provider", isEqualTo: provider)
          .get();
      // print(queryresult.size);
      // if user already in firebase
      if (queryresult.size > 0) {
        // print(queryresult.docs[0].get('account'));
        // print(queryresult.docs[0].get('dtube_pub'));
        // print(queryresult.docs[0].get('provider'));
        // print(queryresult.docs[0].get('encrypted_key'));

        return ThirdPartyLoginEncrypted(
            socialLoginUid: queryresult.docs[0].get('socialLogin_account'),
            socialLoginProvider:
                queryresult.docs[0].get('socialLogin_provider'),
            dTubePublicKey: queryresult.docs[0].get('dtube_pub'),
            dTubeUsername: queryresult.docs[0].get('dtube_username'),
            dTubeEncyptedPrivateKey: queryresult.docs[0].get('encrypted_key'));
      } else {
        return new ThirdPartyLoginEncrypted(
            socialLoginUid: uid,
            socialLoginProvider: provider,
            dTubePublicKey: "na",
            dTubeUsername: "na",
            dTubeEncyptedPrivateKey: "na");
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> storeThirdPartyLogin(ThirdPartyLoginEncrypted data) async {
    final CollectionReference _sociallogins =
        FirebaseFirestore.instance.collection('sociallogins');
    try {
      await _sociallogins.add({
        "socialLogin_account": data.socialLoginUid,
        "socialLogin_provider": data.socialLoginProvider,
        "dtube_pub": data.dTubePublicKey,
        "dtube_username": data.dTubeUsername,
        "encrypted_key": data.dTubeEncyptedPrivateKey,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ThirdPartyLoginDecrypted> decryptThirdPartyLogin(
      ThirdPartyLoginEncrypted data, String password, String socialUId) async {
    //final String _uidHash = getSHA256String(data.socialLoginUid);
    String _encryptionKey = getSHA256String(password + socialUId);

    Encrypted encrypted;
    final key = Key.fromUtf8(getMD5String(_encryptionKey));
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    // final encrypted = encrypter.encrypt(data.dTubeDecyptedPrivateKey, iv: iv);
    final decrypted = encrypter
        .decrypt(Encrypted.fromBase64(data.dTubeEncyptedPrivateKey), iv: iv);

    return ThirdPartyLoginDecrypted(
        socialLoginUid: socialUId,
        socialLoginProvider: data.socialLoginProvider,
        dTubePublicKey: data.dTubePublicKey,
        dTubeUsername: data.dTubeUsername,
        dTubeDecyptedPrivateKey: decrypted);
  }

  Future<ThirdPartyLoginEncrypted> encryptThirdPartyLogin(
      ThirdPartyLoginDecrypted data, String password, String socialUId) async {
    String _encryptionKey = getSHA256String(password + socialUId);
    String _encryptedUId = getSHA256String(socialUId);

    final key = Key.fromUtf8(getMD5String(_encryptionKey));
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(data.dTubeDecyptedPrivateKey, iv: iv);

    return ThirdPartyLoginEncrypted(
        socialLoginUid: _encryptedUId,
        socialLoginProvider: data.socialLoginProvider,
        dTubePublicKey: data.dTubePublicKey,
        dTubeUsername: data.dTubeUsername,
        dTubeEncyptedPrivateKey: encrypted.base64);
  }
}
