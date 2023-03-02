// @dart=2.9
//
import 'dart:io';

import 'package:dtube_go/App.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dtube_go/res/Config/secretConfigValues.dart' as secretConfig;

const MaterialColor kPrimaryColor = const MaterialColor(
  0xFF223154,
  const <int, Color>{
    50: const Color(0xFF223154),
    100: const Color(0xFF223154),
    200: const Color(0xFF223154),
    300: const Color(0xFF223154),
    400: const Color(0xFF223154),
    500: const Color(0xFF223154),
    600: const Color(0xFF223154),
    700: const Color(0xFF223154),
    800: const Color(0xFF223154),
    900: const Color(0xFF223154),
  },
);

void main() async {
  // deactivate landscape mode
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: secretConfig.fbWebApiKey,
          authDomain: secretConfig.fbWebAuthDomain,
          projectId: secretConfig.fbWebProjectId,
          storageBucket: secretConfig.fbWebStorageBucket,
          messagingSenderId: secretConfig.fbWebMessagingSenderId,
          appId: secretConfig.fbWebAppId,
          measurementId: secretConfig.fbWebMeasurementId),
    );
  } else {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp();
    }
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /////////////
  runApp(
    // embedding MyApp into a Pheonix widget to be able to restart the app from within the app itself
    // used for saving the global settings to reinitialize everything based on those settings
    Phoenix(
      child: App(),
    ),
  );
}
