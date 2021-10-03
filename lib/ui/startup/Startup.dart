import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_go/bloc/settings/settings_bloc.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/ui/startup/PinPad.dart';

import 'package:dtube_go/ui/startup/OnboardingJourney.dart';

import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/style/dtubeLoading.dart';
import 'package:dtube_go/ui/startup/LoginScreen.dart';
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
    print(Device.width);
    // sec.deleteAllSettings(); // flush ALL app settings including logindata, hivesigner and so on
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // if the app has never been opened before -> show faq
        if (AppConfig.faqStartup) {
          // currently disabled because of missing faq content
          if (state is NeverUsedTheAppBeforeState) {
            return OnboardingJourney(loggedIn: false);
          }
        }
        // if the user has been authenticated before using login credentials -> show Pinpad
        if (state is SignedInState) {
          return BlocProvider<SettingsBloc>(
              create: (BuildContext context) => SettingsBloc()
                ..add(
                    FetchSettingsEvent()), // add event FetchSettingsEvent to prepare the data for the pinpad dialog
              child: PinPadScreen());
        }
        // if credentials are wrong or key got deleted -> show login form with the prefilled username
        if (state is SignInFailedState) {
          return LoginForm(
            message: state.message,
            username: state.username,
          );
        }
        // if the user logged out or no login credentials have been found in the secure storage -> show login form
        if (state is SignOutCompleteState ||
            state is NoSignInInformationFoundState) {
          return LoginForm();
        }

        // as long as there are no informations from the authentication logic -> show loading animation
        return Scaffold(
          backgroundColor: globalBlue,
          body: Center(
              child:
                  DTubeLogoPulse(size: MediaQuery.of(context).size.width / 3)),
        );
      },
    );
  }
}
