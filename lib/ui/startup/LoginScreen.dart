import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:dtube_togo/style/OpenableHyperlink.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginForm extends StatefulWidget {
  String? message;
  LoginForm({Key? key, this.message}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late AuthBloc _loginBloc;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController privateKeyController = new TextEditingController();
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<AuthBloc>(context);
    //if logindata already stored
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("KEEEEEEEY: " + barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (!barcodeScanRes.contains('Failed')) {
        _scanBarcode = barcodeScanRes;
        privateKeyController.text = barcodeScanRes;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: globalBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/dtube_logo_white.png',
                        width: deviceWidth / 2),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 200,
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                          ),
                        ),
                        // Row(
                        //     children: [
                        ElevatedButton(
                            onPressed: () {
                              launch(AppConfig.signUpUrl);
                            },
                            child: Text(
                              "Sign-Up",
                            )),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 200,
                          child: TextField(
                            obscureText: true,
                            controller: privateKeyController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'key',
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: SizedBox(
                                width: 40,
                                child: Center(
                                    child: FaIcon(FontAwesomeIcons.qrcode)))),
                        // InputChip(
                        //   label: Text("QR-Scan"),
                        //   onPressed: () => scanQR(),
                        // ),
                      ],
                    ),

                    // ],
                    // ),
                    widget.message != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.exclamationTriangle,
                                      color: globalRed,
                                    ),
                                    SizedBox(width: 8),
                                    Text(widget.message!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ],
                                ),
                                widget.message == 'login failed'
                                    ? Container(
                                        width: deviceWidth - 100,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 8),
                                            Text(
                                                "Please check your username & private key!\n\nSometimes a login with the private master key does not work. Then please try to login with a custom key. More info on how to create such a custom key:\n",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1),
                                            OpenableHyperlink(
                                                url:
                                                    "https://d.tube/#!/wiki/faq/how-can-i-create-lesser-authority-keys")
                                          ],
                                        ),
                                      )
                                    : SizedBox(height: 0),
                              ],
                            ),
                          )
                        : SizedBox(height: 16),

                    ValueListenableBuilder<TextEditingValue>(
                        valueListenable: usernameController,
                        builder: (context, value, child) {
                          return ValueListenableBuilder<TextEditingValue>(
                              valueListenable: privateKeyController,
                              builder: (context, value, child) {
                                return ElevatedButton(
                                    onPressed: usernameController.value.text !=
                                                "" &&
                                            privateKeyController.value.text !=
                                                ""
                                        ? () {
                                            _loginBloc.add(
                                                SignInWithCredentialsEvent(
                                                    usernameController
                                                        .value.text,
                                                    privateKeyController
                                                        .value.text));
                                          }
                                        : null,
                                    child: Text(
                                      "Sign in",
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ));
                              });
                        }),
                        SignInButton(
                          Buttons.Google, onPressed: () async{
                            try {
                              await Firebase.initializeApp();

                              final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

                              final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

                              final String? accessToken = googleAuth!.accessToken;
                              final String? idToken = googleAuth.idToken;

                              final AuthCredential credential = GoogleAuthProvider.credential(
                                    accessToken: accessToken,
                                    idToken: idToken
                              );
                              print(credential);

                              await auth.signInWithCredential(credential);
                              print(auth);

                            } catch (error) {
                                print(error);
                            }
                          },
                        ),
                        SignInButton(
                          Buttons.Facebook, onPressed: () async{
                            try {
                              await Firebase.initializeApp();
                              final LoginResult result = await FacebookAuth.instance.login();
                              switch (result.status) {
                                case LoginStatus.success:
                                  final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
                                  print(facebookCredential);
                                  final userCredential = await auth.signInWithCredential(facebookCredential);
                                  print(userCredential);
                                  return userCredential;
                                case LoginStatus.cancelled:
                                  print("cancelled");
                                  return null;
                                case LoginStatus.failed:
                                  print("failed");
                                  return null;
                                default:
                                  print("default");
                                  return null;
                              }
                            } catch(error) {
                              print(error);
                            }
                          }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
