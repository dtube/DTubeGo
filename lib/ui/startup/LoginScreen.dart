import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:dtube_togo/style/OpenableHyperlink.dart';
import 'package:dtube_togo/style/ThemeData.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<AuthBloc>(context);
    //if logindata already stored
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
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: privateKeyController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'key',
                      ),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                launch(AppConfig.signUpUrl);
                              },
                              child: Text("Register")),
                          ElevatedButton(
                              onPressed: () {
                                _loginBloc.add(SignInWithCredentialsEvent(
                                    usernameController.value.text,
                                    privateKeyController.value.text));
                              },
                              child: Text("Sign in")),
                        ])
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
