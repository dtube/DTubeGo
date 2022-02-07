import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/OpenableHyperlink.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/utils/randomGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterNewAccount extends StatefulWidget {
  RegisterNewAccount({Key? key}) : super(key: key);

  @override
  State<RegisterNewAccount> createState() => _RegisterNewAccountState();
}

class _RegisterNewAccountState extends State<RegisterNewAccount> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController privateKeyController = new TextEditingController();
  TextEditingController publicKeyController = new TextEditingController();
  bool _keysGenerated = false;
  bool _usernameFree = true;
  bool _copyClicked = false;
  bool _keysSavedSecure = false;
  String _usernameHint = "enter a username";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getNewKeyPair() async {
    List<String> keys = generateNewKeyPair();
    setState(() {
      publicKeyController.text = keys[0];
      privateKeyController.text = keys[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Container(
          width: 80.w,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text("1. Enter your desired username",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.w,
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyText1,
                      controller: usernameController,
                      onChanged: (value) {
                        setState(() {
                          if (value.length < AppConfig.usernameMinLength) {
                            _usernameHint = "username needs " +
                                (12 - value.length).toString() +
                                " more characters";
                          } else {
                            // TODO: check username available
                            _usernameHint = "username not available";
                          }

                          privateKeyController.text = "";
                          publicKeyController.text = "";
                          _keysGenerated = false;
                          _copyClicked = false;
                        });
                      },
                      cursorColor: globalRed,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          labelStyle: Theme.of(context).textTheme.bodyText1),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                      valueListenable: usernameController,
                      builder: (context, value, child) {
                        return ElevatedButton(
                            onPressed: usernameController.value.text != "" &&
                                    usernameController.value.text.length >=
                                        12 &&
                                    _usernameFree
                                ? () {
                                    setState(() {
                                      _keysGenerated = true;
                                      getNewKeyPair();
                                    });
                                  }
                                : null,
                            child: Row(
                              children: [
                                _keysGenerated
                                    ? FaIcon(FontAwesomeIcons.undo)
                                    : Container(),
                                Text((_keysGenerated ? "" : "get") + " keys"),
                              ],
                            ));
                      }),
                ],
              ),
              Visibility(
                visible: !_keysGenerated,
                child: Text(_usernameHint),
              ),
              Visibility(
                visible: !_keysGenerated,
                child: Text(
                    "The username should be at least 12 characters. The username can include numbers, dashes (-) or dots (.)"),
              ),
              Visibility(
                visible: _keysGenerated,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text("2. Keys",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    Container(
                      width: 80.w,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1,
                        cursorColor: globalRed,
                        readOnly: true,
                        controller: publicKeyController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Public Key',
                            labelStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    Container(
                      width: 80.w,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1,
                        cursorColor: globalRed,
                        readOnly: true,
                        controller: privateKeyController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Private Key',
                            labelStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            width: 80.w,
                            child: Text(
                              "Now copy and save the keys secure. They can not get restored!",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: globalRed),
                            )),
                        Container(
                            width: 80.w,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _copyClicked = true;
                                  });
                                  Clipboard.setData(ClipboardData(
                                      text: 'username: ' +
                                          usernameController.value.text +
                                          '\r\n' +
                                          'public key: ' +
                                          publicKeyController.value.text +
                                          '\r\n' +
                                          'private key: ' +
                                          privateKeyController.value.text));
                                },
                                child: Center(
                                    child: Text("copy keys to clipboard")))),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _copyClicked,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: _keysSavedSecure,
                        onChanged: (val) {
                          setState(() {
                            _keysSavedSecure = !_keysSavedSecure;
                          });
                        }),
                    Container(
                      width: 50.w,
                      child: Text(
                          "I stored the keys securely and I understand that nobody can restore the keys."),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: _copyClicked,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                        valueListenable: usernameController,
                        builder: (context, value, child) {
                          return ValueListenableBuilder<TextEditingValue>(
                              valueListenable: privateKeyController,
                              builder: (context, value, child) {
                                return ElevatedButton(
                                    onPressed: _keysSavedSecure
                                        ? () {
                                            // TODO: create new account, store parameters and log the user in
                                          }
                                        : null,
                                    child: Text(
                                      "Create account",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ));
                              });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
