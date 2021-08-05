import 'package:dtube_togo/ui/startup/OnboardingJourney.dart';

import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';

import 'package:dtube_togo/ui/NavigationContainer.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/ui/startup/LoginScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    // sec.deleteAllSettings(); // flush ALL app settings including logindata, hivesigner and so on
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
        if (state is SignInFailedState) {
          return LoginForm(message: state.message);
        }

        if (state is SignOutCompleteState ||
            state is NoSignInInformationFoundState) {
          return LoginForm();
        }

        if (state is NeverUsedTheAppBeforeState) {
          return OnboardingJourney();
        }

        return Scaffold(
          backgroundColor: globalBlue,
          body: Center(child: DTubeLogoPulse()),
        );
      },
    );
  }
}
