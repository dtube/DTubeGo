import 'package:cloud_firestore/cloud_firestore.dart';

// https://github.com/davefaliskie/travel_treasury/blob/eecbff3444d5c8d9abf18cfea9932fcefe686ff3/lib/models/Trip.dart

class ThirdPartyLoginEncrypted {
  String socialLoginUid;
  String socialLoginProvider;
  String dTubePublicKey;
  String dTubeUsername;
  String dTubeEncyptedPrivateKey;

  ThirdPartyLoginEncrypted(
      {required this.socialLoginUid,
      required this.socialLoginProvider,
      required this.dTubePublicKey,
      required this.dTubeUsername,
      required this.dTubeEncyptedPrivateKey});
}

class ThirdPartyLoginDecrypted {
  String socialLoginUid;
  String socialLoginProvider;
  String dTubePublicKey;
  String dTubeUsername;
  String dTubeDecyptedPrivateKey;

  ThirdPartyLoginDecrypted(
      {required this.socialLoginUid,
      required this.socialLoginProvider,
      required this.dTubePublicKey,
      required this.dTubeUsername,
      required this.dTubeDecyptedPrivateKey});
}
