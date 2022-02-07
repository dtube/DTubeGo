import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/ui/startup/OnboardingJourney/OnboardingJourney.dart';
import 'package:dtube_go/ui/startup/login/pages/LoginWithCredentials.dart';
import 'package:dtube_go/ui/startup/login/pages/SocialUserActionPopup.dart';
import 'package:dtube_go/ui/startup/login/services/ressources.dart';
import 'package:dtube_go/ui/startup/login/widgets/sign_in_button.dart';
import 'package:dtube_go/utils/secureStorage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatefulWidget {
  String? message;
  String? username;
  bool showOnboardingJourney;

  LoginForm(
      {Key? key,
      this.message,
      this.username,
      required this.showOnboardingJourney})
      : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late bool _journeyDone;
  late AuthBloc _loginBloc;
  bool _loginWithCredentialsVisible = false;

  bool _authIsLoading = false;
  String _uid = "";
  late String _currentHF = "0";

  void getCurrentHF() async {
    String _hardfork = await sec.getLocalConfigString(settingKey_currentHF);
    setState(() {
      // override this to simulate another hardfork
      _currentHF = _hardfork;
      // _currentHF = "6"; // example: setting current active hardfork to hf6
    });
  }

  @override
  void initState() {
    _journeyDone = !widget.showOnboardingJourney;

    _loginBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();

    getCurrentHF();
  }

  void journeyDoneCallback() async {
    await sec.persistOnbordingJourneyDone();
    setState(() {
      _journeyDone = true;
    });
    BlocProvider.of<AuthBloc>(context).add(StartBrowseOnlyMode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalBlue,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                height: 95.h,
                width: 95.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Image.asset('assets/images/dtube_logo_white.png',
                          width: 30.w),
                    ),
                    Column(
                      children: [
                        Text("Login / Sign Up",
                            style: Theme.of(context).textTheme.headline4),
                        // DTube Credentials
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _loginWithCredentialsVisible =
                                  !_loginWithCredentialsVisible;
                            });
                          },
                          child: Container(
                            width: 45.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: _loginWithCredentialsVisible,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 2.w),
                                    child: FaIcon(FontAwesomeIcons.arrowLeft),
                                  ),
                                ),
                                Image.asset(
                                    'assets/images/dtube_logo_white.png',
                                    width: 7.w),
                                Text("Credentials")
                              ],
                            ),
                          ),
                        ),
                        // Social Providers
                        Visibility(
                          visible: !_loginWithCredentialsVisible,
                          child: Container(
                            width: 80.w,
                            child: Column(
                              children: [
                                int.parse(_currentHF) >= 6
                                    ? Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 2.w,
                                        children: [
                                          SignInButton(
                                            faIcon:
                                                FaIcon(FontAwesomeIcons.google),
                                            loginType: LoginType.Google,
                                            activated: true,
                                            loggedInCallback: loggedInCallback,
                                          ),
                                          SignInButton(
                                            faIcon: FaIcon(
                                                FontAwesomeIcons.facebook),
                                            loginType: LoginType.Facebook,
                                            activated: true,
                                            loggedInCallback: loggedInCallback,
                                          ),
                                          SignInButton(
                                            faIcon:
                                                FaIcon(FontAwesomeIcons.github),
                                            loginType: LoginType.Github,
                                            activated: true,
                                            loggedInCallback: loggedInCallback,
                                          ),
                                          SignInButton(
                                            faIcon: FaIcon(
                                                FontAwesomeIcons.twitter),
                                            loginType: LoginType.Twitter,
                                            activated: true,
                                            loggedInCallback: loggedInCallback,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                InputChip(
                                    backgroundColor: Colors.green.shade700,
                                    onPressed: () {
                                      _loginBloc.add(StartBrowseOnlyMode());
                                    },
                                    label: Text(
                                      "continue without login",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _loginWithCredentialsVisible,
                          child: LoginWithCredentials(
                            username: widget.username,
                            message: widget.message,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: !_loginWithCredentialsVisible,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text("You want to know more about DTube?",
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InputChip(
                                  backgroundColor: globalAlmostWhite,
                                  onPressed: () {
                                    launch(AppConfig.readmoreUrl);
                                  },
                                  label: Text(
                                    "read the Whitepaper",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: globalBlue),
                                  )),
                              InputChip(
                                  backgroundColor: globalAlmostWhite,
                                  onPressed: () {
                                    launch(AppConfig.discordUrl);
                                  },
                                  label: Container(
                                    width: 60.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Join the DTube Discord",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: globalBlue),
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.discord,
                                          color: globalBGColor,
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // onboarding Journey
          Visibility(
            child: OnboardingJourney(
              journeyDoneCallback: journeyDoneCallback,
            ),
            visible: !_journeyDone,
          ),
        ],
      ),
    );
  }

  void loggedInCallback(String socialUId, String socialProvider) async {
    setState(() {
      _uid = socialUId;
    });
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => MultiBlocProvider(
                providers: [
                  BlocProvider<ThirdPartyLoginBloc>(
                      create: (context) => ThirdPartyLoginBloc(
                          repository: ThirdPartyLoginRepositoryImpl())
                        ..add(TryThirdPartyLoginEvent(
                            socialUId: socialUId,
                            socialProvider: socialProvider))),
                  BlocProvider<AvalonConfigBloc>(
                      create: (context) => AvalonConfigBloc(
                          repository: AvalonConfigRepositoryImpl())),
                  BlocProvider<TransactionBloc>(
                      create: (context) => TransactionBloc(
                          repository: TransactionRepositoryImpl())),
                ],
                child: SocialUserActionPopup(
                  socialUId: socialUId,
                )));
  }
}
