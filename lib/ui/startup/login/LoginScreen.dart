import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:dtube_go/ui/startup/login/Layouts/LoginScreenDesktop.dart';
import 'package:dtube_go/ui/startup/login/Layouts/LoginScreenMobile.dart';
import 'package:dtube_go/ui/startup/login/Layouts/LoginScreenTablet.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';

import 'package:dtube_go/ui/startup/OnboardingJourney/OnboardingJourney.dart';
import 'package:dtube_go/ui/startup/login/widgets/LoginWithCredentials.dart';
import 'package:dtube_go/ui/startup/login/pages/SocialUserActionPopup.dart';
import 'package:dtube_go/ui/startup/login/services/ressources.dart';
import 'package:dtube_go/ui/startup/login/widgets/sign_in_button.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatefulWidget {
  final String? message;
  final String? username;
  final bool showOnboardingJourney;

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
    String _hardfork = await sec.getLocalConfigString(sec.settingKey_currentHF);
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
    // await sec.persistOnbordingJourneyDone();
    setState(() {
      _journeyDone = true;
    });
    BlocProvider.of<AuthBloc>(context).add(StartBrowseOnlyMode());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody:
          LoginFormMobile(showOnboardingJourney: widget.showOnboardingJourney),
      tabletBody:
          LoginFormTablet(showOnboardingJourney: widget.showOnboardingJourney),
      desktopBody:
          LoginFormDesktop(showOnboardingJourney: widget.showOnboardingJourney),
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
