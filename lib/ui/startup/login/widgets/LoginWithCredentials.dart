import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/startup/login/pages/RegisterNewAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginWithCredentials extends StatefulWidget {
  LoginWithCredentials(
      {Key? key,
      required this.username,
      required this.message,
      required this.width})
      : super(key: key);
  final String? username;
  final String? message;
  final double width;

  @override
  State<LoginWithCredentials> createState() => _LoginWithCredentialsState();
}

class _LoginWithCredentialsState extends State<LoginWithCredentials> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController privateKeyController = new TextEditingController();

  late AuthBloc _loginBloc;

  String _scanBarcode = 'Unknown';
  bool _registerAccountScreen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loginBloc = BlocProvider.of<AuthBloc>(context);
    if (widget.username != null) {
      usernameController = TextEditingController(text: widget.username);
    }
  }

// QR scan is not shown until the QR generator on the website is fixed
  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
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
    return Center(
      child: Stack(
        children: [
          Visibility(
            visible: !_registerAccountScreen,
            child: Form(
              child: Container(
                width: widget.width,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text("Please enter your dtube credentials:",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: widget.width,
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyText1,
                            controller: usernameController,
                            cursorColor: globalRed,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: widget.width,
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyText1,
                            obscureText: true,
                            cursorColor: globalRed,
                            controller: privateKeyController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Private Key',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText1),
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
                                      FontAwesomeIcons.triangleExclamation,
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
                                        width: widget.width,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueListenableBuilder<TextEditingValue>(
                            valueListenable: usernameController,
                            builder: (context, value, child) {
                              return ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: privateKeyController,
                                  builder: (context, value, child) {
                                    return ElevatedButton(
                                        onPressed: usernameController
                                                        .value.text !=
                                                    "" &&
                                                privateKeyController
                                                        .value.text !=
                                                    ""
                                            ? () {
                                                _loginBloc.add(
                                                    SignInWithCredentialsEvent(
                                                  username: usernameController
                                                      .value.text,
                                                  privateKey:
                                                      privateKeyController
                                                          .value.text,
                                                ));
                                              }
                                            : null,
                                        child: Text(
                                          "Sign in",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ));
                                  });
                            }),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       setState(() {
                        //         _registerAccountScreen =
                        //             !_registerAccountScreen;
                        //       });
                        //     },
                        //     child: Text(
                        //       "register",
                        //       style: Theme.of(context).textTheme.headline5,
                        //     )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: _registerAccountScreen, child: RegisterNewAccount())
        ],
      ),
    );
  }
}
