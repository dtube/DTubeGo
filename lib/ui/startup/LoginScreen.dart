import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LoginForm extends StatefulWidget {
  String? message;
  String? username;
  LoginForm({Key? key, this.message, this.username}) : super(key: key);

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
    if (widget.username != null) {
      usernameController = TextEditingController(text: widget.username);
    }
    //if logindata already stored
  }

// QR scan is not shown until the QR generator on the website is fixed
  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("KEEEEEEEY: " + barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

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
    return Scaffold(
      backgroundColor: globalBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 5.h),
                  child: Image.asset('assets/images/dtube_logo_white.png',
                      width: 60.w),
                ),
                Text("Login with your DTube credentials",
                    style: Theme.of(context).textTheme.headline6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.w,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1,
                        controller: usernameController,
                        cursorColor: globalRed,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.w,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1,
                        obscureText: true,
                        cursorColor: globalRed,
                        controller: privateKeyController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Private Key',
                            labelStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),

                    // hidden until QR code is generated properly
                    // SizedBox(
                    //   width: 5.w,
                    // ),
                    // ElevatedButton(
                    //     onPressed: () => scanQR(),
                    //     child: SizedBox(
                    //         width: 40,
                    //         child: Center(
                    //             child: FaIcon(FontAwesomeIcons.qrcode)))),
                  ],
                ),
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
                                    style:
                                        Theme.of(context).textTheme.headline2),
                              ],
                            ),
                            widget.message == 'login failed'
                                ? Container(
                                    width: 90.w,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Please check your username & private key.\n\nWe also recommend to use a custom private key. More info on how to create one:\n",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
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
                                        privateKeyController.value.text != ""
                                    ? () {
                                        _loginBloc.add(
                                            SignInWithCredentialsEvent(
                                                usernameController.value.text,
                                                privateKeyController
                                                    .value.text));
                                      }
                                    : null,
                                child: Text(
                                  "Sign in",
                                  style: Theme.of(context).textTheme.headline5,
                                ));
                          });
                    }),
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Text("You don't have an account on DTube?",
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                ElevatedButton(
                    onPressed: () {
                      launch(AppConfig.signUpUrl);
                    },
                    child: Text(
                      "register for free!",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text("You want to know more about DTube?",
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                InputChip(
                    backgroundColor: globalAlmostWhite,
                    onPressed: () {
                      launch(AppConfig.signUpUrl);
                    },
                    label: Text(
                      "read the whitepaper!",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: globalBlue),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
