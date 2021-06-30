import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';

import 'package:dtube_togo/ui/NavigationContainer.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class StartUp extends StatefulWidget {
  StartUp({Key? key}) : super(key: key);

  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
// Create storage

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state == SignedInState()) {
          return MultiBlocProvider(providers: [
            BlocProvider<UserBloc>(create: (context) {
              return UserBloc(repository: UserRepositoryImpl());
            }),
            BlocProvider<AuthBloc>(
              create: (BuildContext context) =>
                  AuthBloc(repository: AuthRepositoryImpl()),
            ),
          ], child: NavigationContainer());
        }
        if ([
          SignInFailedState(message: "login failed"),
          SignOutCompleteState(),
          NoSignInInformationFoundState()
        ].contains(state)) {
          // remove inputs and show snackbar
          //usernameController.text = "";
          return LoginForm();
        }

        return Scaffold(
          backgroundColor: globalBlue,
          body: Center(child: DTubeLogoPulse()),
        );
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: globalBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  Image.asset('assets/images/dtube_logo_white.png',
                      width: MediaQuery.of(context).size.width / 2),
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () {
                          _loginBloc.add(SignInWithCredentialsEvent(
                              usernameController.value.text,
                              privateKeyController.value.text));
                        },
                        child: Text("Sign in")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
