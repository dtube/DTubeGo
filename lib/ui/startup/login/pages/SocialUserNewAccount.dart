import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/avalonConfig/avalonConfig_bloc_full.dart';
import 'package:dtube_go/bloc/config/txTypes.dart';
import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/Inputs/CustomChoiceCard.dart';
import 'package:dtube_go/ui/widgets/Inputs/NextBackButtons.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/widgets/tags/TagChip.dart';
import 'package:dtube_go/utils/Random/randomGenerator.dart';
import 'package:dtube_go/utils/Global/secureStorage.dart';
import 'package:dtube_go/utils/Strings/stringCheckers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SocialUserNewAccount extends StatefulWidget {
  SocialUserNewAccount({
    Key? key,
    required this.socialLoginBaseData,
    required this.socialUId,
  }) : super(key: key);

  final String socialUId;

  ThirdPartyLoginEncrypted socialLoginBaseData;

  @override
  State<SocialUserNewAccount> createState() => _SocialUserNewAccountState();
}

class _SocialUserNewAccountState extends State<SocialUserNewAccount> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordRepeatController = new TextEditingController();
  TextEditingController privateKeyController = new TextEditingController();
  TextEditingController publicKeyController = new TextEditingController();

  late AuthBloc _checkLoginBloc;
  late AvalonConfigBloc _avalonBloc;
  late TransactionBloc _txBloc;
  late ThirdPartyLoginBloc _thirdPartyLoginBloc;

  int _step = 0;
  bool _usernameFree = true;
  bool _copyClicked = false;
  bool _keysSavedSecure = false;
  bool _signUpPressed = false;
  bool _linkAccountPressed = false;
  String _usernameHint = "";
  String _passwordHint = "";
  String _checkLoginHint = "";

  @override
  void initState() {
    _avalonBloc = BlocProvider.of<AvalonConfigBloc>(context);
    _txBloc = BlocProvider.of<TransactionBloc>(context);
    _thirdPartyLoginBloc = BlocProvider.of<ThirdPartyLoginBloc>(context);
    _checkLoginBloc = BlocProvider.of<AuthBloc>(context);
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
    return PopUpDialogWithTitleLogo(
        titleWidgetPadding: 5.w,
        titleWidgetSize: 20.w,
        callbackOK: () {},
        titleWidget: FaIcon(
          FontAwesomeIcons.userAstronaut,
          size: 20.w,
          color: globalRed,
        ),
        showTitleWidget: true,
        child: BlocBuilder<TransactionBloc, TransactionState>(
            bloc: _txBloc,
            builder: (context, state) {
              if (state is TransactionSent) {
                // new accout was created succesfully
                storeUserToFirebase();

                return DtubeLogoPulseWithSubtitle(
                    subtitle: "Saving your account data...", size: 40.w);
              } else if (state is TransactionSinging ||
                  state is TransactionSigned) {
                return DtubeLogoPulseWithSubtitle(
                    subtitle: "Creating your account...", size: 40.w);
              } else {
                return Container(
                    width: 95.w,
                    height: 45.h,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: _step == 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Social Login / Sign Up",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "If you are new here and you want to start you DTube journey now then feel free to tap \"Join DTube\". If you just want to link your DTube account to a social login then tap the right icon below."),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomChoiceCard(
                                              backgroundColor: globalRed,
                                              height: 15.h,
                                              icon: FontAwesomeIcons.plusCircle,
                                              iconColor: globalAlmostWhite,
                                              iconSize: 10.w,
                                              label: "Join DTube",
                                              onTapped: () {
                                                setState(() {
                                                  _step = 6;
                                                });
                                              },
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline6!,
                                              width: 35.w,
                                            ),
                                            CustomChoiceCard(
                                              backgroundColor: globalRed,
                                              height: 15.h,
                                              icon: FontAwesomeIcons.user,
                                              iconColor: globalAlmostWhite,
                                              iconSize: 10.w,
                                              label: "Link Account",
                                              onTapped: () {
                                                setState(() {
                                                  _step = 1;
                                                });
                                              },
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline6!,
                                              width: 35.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // EXISTING USER
                              // explain
                              Visibility(
                                visible: _step == 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Link your DTube Account",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "You can now link your existing DTube user to the selected social login in a secure way. We want to make clear that the public/private key method is still the most secure option even though we are doing our best to keep everything as secure as it can be.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 0;
                                                });
                                              },
                                            ),
                                            CustomNextButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 2;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("1. Enter your DTube credentials",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: usernameController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                (RegExp("[a-zA-Z0-9\.\-]")))
                                          ],
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Username',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                      ),
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: privateKeyController,
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Private Key',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                      ),
                                      Text(
                                          "Remember that you will only have the permissions your (custom) key is able to provide."),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 1;
                                                  usernameController.text = "";
                                                  privateKeyController.text =
                                                      "";
                                                });
                                              },
                                            ),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    usernameController,
                                                builder:
                                                    (context, value, child) {
                                                  return ValueListenableBuilder<
                                                          TextEditingValue>(
                                                      valueListenable:
                                                          privateKeyController,
                                                      builder: (context, value,
                                                          child) {
                                                        return CustomNextButton(
                                                            onTapped: (usernameController
                                                                            .value
                                                                            .text !=
                                                                        "" &&
                                                                    privateKeyController
                                                                            .value
                                                                            .text !=
                                                                        "")
                                                                ? () {
                                                                    setState(
                                                                        () {
                                                                      _step = 3;
                                                                    });
                                                                    _checkLoginBloc.add(CheckCredentialsEvent(
                                                                        username: usernameController
                                                                            .value
                                                                            .text,
                                                                        privateKey: privateKeyController
                                                                            .value
                                                                            .text));
                                                                  }
                                                                : null);
                                                      });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // check login & save
                              Visibility(
                                visible: _step == 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BlocBuilder<AuthBloc, AuthState>(
                                    bloc: _checkLoginBloc,
                                    builder: (context, state) {
                                      if (state is AuthInitialState) {
                                        return DtubeLogoPulseWithSubtitle(
                                            subtitle:
                                                "checking your credentials...",
                                            size: 40.w);
                                      } else if (state
                                          is CheckCredentialsValidState) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Your credentials are valid!",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5),
                                            state.txTypes.length >=
                                                    txTypes.length
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 1.h),
                                                    child: Text(
                                                        "It seams you have used the private master key with all permissions. We highly recommend to use a custom key for this login method.",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color:
                                                                    globalRed)),
                                                  )
                                                : Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1.h),
                                                        child: Text(
                                                            "The given custom key provides the following permissions:"),
                                                      ),
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,
                                                        spacing: 2.w,
                                                        children: state.txTypes
                                                            .map((i) => TagChipWidgetWithoutNavigation(
                                                                tagName: txTypes[
                                                                        i]
                                                                    .toString(),
                                                                width: 30.w,
                                                                fontStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption))
                                                            .toList(),
                                                      ),
                                                    ],
                                                  ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                  "Now allmost everything is prepared to link your DTube account. We just need a password to encrypt your private key and save it securely to our database.",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CustomBackButton(
                                                      onTapped: () {
                                                    setState(() {
                                                      _step = 2;
                                                    });
                                                  }),
                                                  CustomNextButton(
                                                    onTapped: () {
                                                      setState(() {
                                                        _step = 4;
                                                        publicKeyController
                                                                .text =
                                                            state.publicKey;
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                "Invalid User or Private Key",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Text(
                                                  "The app was not able to verify the given credentials. Please go back to check your data and try again!"),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: CustomBackButton(
                                                onTapped: () {
                                                  _checkLoginBloc
                                                      .add(AuthSetInitState());
                                                  setState(() {
                                                    _step = 2;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: passwordController,
                                          obscureText: true,
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Password',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          onChanged: (value) {
                                            setState(() {
                                              _passwordHint =
                                                  checkPasswordCompliance(
                                                      value, 8);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: passwordRepeatController,
                                          obscureText: true,
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'repeat Password',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                      ),
                                      Text(
                                        _passwordHint,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 3;

                                                  passwordController.text = "";
                                                  passwordRepeatController
                                                      .text = "";
                                                });
                                              },
                                            ),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    passwordController,
                                                builder:
                                                    (context, value, child) {
                                                  return ValueListenableBuilder<
                                                          TextEditingValue>(
                                                      valueListenable:
                                                          passwordRepeatController,
                                                      builder: (context, value,
                                                          child) {
                                                        return CustomNextButton(
                                                          onTapped: isPasswordCompliant(
                                                                          passwordController
                                                                              .value
                                                                              .text,
                                                                          8) ==
                                                                      true &&
                                                                  passwordController
                                                                          .value
                                                                          .text ==
                                                                      passwordRepeatController
                                                                          .value
                                                                          .text
                                                              ? () {
                                                                  setState(() {
                                                                    _step = 5;
                                                                  });
                                                                }
                                                              : null,
                                                        );
                                                      });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // forward to logged in app
                              Visibility(
                                visible: _step == 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Congratulations!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "Now everything is set up to link your DTube user to the social login on ${widget.socialLoginBaseData.socialLoginProvider}!\n\nIf you want to proceed feel free to click \"Link it\". You will then get logged in automatically!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                                onTapped: !_linkAccountPressed
                                                    ? () {
                                                        setState(() {
                                                          _step = 4;
                                                        });
                                                      }
                                                    : null),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    passwordController,
                                                builder:
                                                    (context, value, child) {
                                                  return ElevatedButton(
                                                    onPressed:
                                                        !_linkAccountPressed
                                                            ? () {
                                                                setState(() {
                                                                  _linkAccountPressed =
                                                                      true;
                                                                  storeUserToFirebase();
                                                                });
                                                              }
                                                            : null,
                                                    child: Container(
                                                      width: 25.w,
                                                      child:
                                                          !_linkAccountPressed
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Link it",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline5,
                                                                    ),
                                                                    FaIcon(
                                                                      FontAwesomeIcons
                                                                          .rocket,
                                                                      size: 5.w,
                                                                    )
                                                                  ],
                                                                )
                                                              : Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // NEW USER
                              Visibility(
                                visible: _step == 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Sign Up for DTube",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "You can now create a new DTube user and we will automatically link it to your ${widget.socialLoginBaseData.socialLoginProvider} account.\n\nIf you're already signed up on DTube please login manually with your private key. You can link your DTube user to any social login within the profile settings.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 0;
                                                });
                                              },
                                            ),
                                            CustomNextButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 7;
                                                  getNewKeyPair();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("1. Choose a username",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: usernameController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                (RegExp("[a-zA-Z0-9\.\-]")))
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              if (value.length <
                                                  AppConfig.usernameMinLength) {
                                                _usernameHint =
                                                    "username needs " +
                                                        (12 - value.length)
                                                            .toString() +
                                                        " more characters";
                                              } else {
                                                _usernameHint = "";
                                                _avalonBloc.add(
                                                    FetchAvalonAccountPriceEvent(
                                                        value));
                                              }

                                              privateKeyController.text = "";
                                              publicKeyController.text = "";
                                              _step = 7;
                                            });
                                          },
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Username',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                      ),
                                      _usernameHint == ""
                                          ? BlocBuilder<AvalonConfigBloc,
                                                  AvalonConfigState>(
                                              bloc: _avalonBloc,
                                              builder: (context, state) {
                                                if (state
                                                    is AvalonAccountLoadingState) {
                                                  return Text(
                                                      "checking account name... ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1);
                                                } else if (state
                                                        is AvalonAccountAvailableState &&
                                                    usernameController.value
                                                            .text.length >=
                                                        12) {
                                                  return Text(
                                                      "account name available",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              color: Colors
                                                                  .green));
                                                } else if (state
                                                    is AvalonAccountNotAvailableState) {
                                                  return Text(
                                                      "account name not available",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              color:
                                                                  globalRed));
                                                } else {
                                                  return Text(
                                                    _usernameHint,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            color: globalRed),
                                                  );
                                                }
                                              })
                                          : Text(
                                              _usernameHint,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(color: globalRed),
                                            ),
                                      Text(
                                        "The username should be at least 12 characters & it can include numbers, dashes (-) or dots (.)\nDon't worry: inside the app you can set a custom display name however and how often you want.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 6;
                                                  usernameController.text = "";
                                                  privateKeyController.text =
                                                      "";
                                                  publicKeyController.text = "";
                                                });
                                              },
                                            ),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    usernameController,
                                                builder:
                                                    (context, value, child) {
                                                  return CustomNextButton(
                                                      onTapped: (usernameController
                                                                      .value
                                                                      .text !=
                                                                  "" &&
                                                              usernameController
                                                                      .value
                                                                      .text
                                                                      .length >=
                                                                  12 &&
                                                              _usernameFree)
                                                          ? () {
                                                              setState(() {
                                                                _step = 8;
                                                                getNewKeyPair();
                                                              });
                                                            }
                                                          : null);
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("2. Copy your keys",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "A DTube user account also got its own login key (private key). To be able to login on other DTube user interfaces (eg. the DTube website) you'll need the private key. \n\nImportant: Nobody will ever be able to reset it except you - so store the keys very safe and secure.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 7;
                                                });
                                              },
                                            ),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    usernameController,
                                                builder:
                                                    (context, value, child) {
                                                  return CustomNextButton(
                                                      onTapped: () {
                                                    setState(() {
                                                      _step = 9;
                                                    });
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 9,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: !_copyClicked,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 70.w,
                                              child: TextField(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                cursorColor: globalRed,
                                                readOnly: true,
                                                controller: publicKeyController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Public Key',
                                                    labelStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1),
                                              ),
                                            ),
                                            Container(
                                              width: 70.w,
                                              child: TextField(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                cursorColor: globalRed,
                                                readOnly: true,
                                                controller:
                                                    privateKeyController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Private Key',
                                                    labelStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1),
                                              ),
                                            ),
                                            Text(
                                                "When you click on \"copy\" your keys and your username will land inside of your clipboard. Open the password manager of your choice or a notepad and save them."),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CustomBackButton(
                                                    onTapped: () {
                                                      setState(() {
                                                        _step = 8;
                                                      });
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _copyClicked = true;
                                                        });
                                                        Clipboard.setData(ClipboardData(
                                                            text: 'username: ' +
                                                                usernameController
                                                                    .value
                                                                    .text +
                                                                '\r\n' +
                                                                'public key: ' +
                                                                publicKeyController
                                                                    .value
                                                                    .text +
                                                                '\r\n' +
                                                                'private key: ' +
                                                                privateKeyController
                                                                    .value
                                                                    .text));
                                                      },
                                                      child: Container(
                                                        width: 17.w,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("copy"),
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .copy,
                                                              size: 5.w,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: _copyClicked,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Checkbox(
                                                      value: _keysSavedSecure,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _keysSavedSecure =
                                                              !_keysSavedSecure;
                                                        });
                                                      }),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _keysSavedSecure =
                                                            !_keysSavedSecure;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 60.w,
                                                      child: Text(
                                                        "I stored the keys securely and I understand that nobody can restore nor reset the keys except of myself.",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CustomBackButton(
                                                      onTapped: () {
                                                    setState(() {
                                                      _copyClicked = false;
                                                      _keysSavedSecure = false;
                                                    });
                                                  }),
                                                  CustomNextButton(
                                                      onTapped: _keysSavedSecure
                                                          ? () {
                                                              setState(() {
                                                                _step = 10;
                                                              });
                                                            }
                                                          : null)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("3. Set a password",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "Now allmost everything is prepared to create your new DTube account. We just need a password to encrypt your private key and save it securely to our database.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(onTapped: () {
                                              setState(() {
                                                _step = 9;
                                                _copyClicked = false;
                                                _keysSavedSecure = false;
                                              });
                                            }),
                                            CustomNextButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 11;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 11,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: passwordController,
                                          obscureText: true,
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Password',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                          onChanged: (value) {
                                            setState(() {
                                              _passwordHint =
                                                  checkPasswordCompliance(
                                                      value, 8);
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 75.w,
                                        child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          controller: passwordRepeatController,
                                          obscureText: true,
                                          cursorColor: globalRed,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'repeat Password',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                      ),
                                      Text(
                                        _passwordHint,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                              onTapped: () {
                                                setState(() {
                                                  _step = 10;
                                                  _copyClicked = false;
                                                  _keysSavedSecure = false;
                                                  passwordController.text = "";
                                                  passwordRepeatController
                                                      .text = "";
                                                });
                                              },
                                            ),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    passwordController,
                                                builder:
                                                    (context, value, child) {
                                                  return ValueListenableBuilder<
                                                          TextEditingValue>(
                                                      valueListenable:
                                                          passwordRepeatController,
                                                      builder: (context, value,
                                                          child) {
                                                        return CustomNextButton(
                                                          onTapped: isPasswordCompliant(
                                                                          passwordController
                                                                              .value
                                                                              .text,
                                                                          8) ==
                                                                      true &&
                                                                  passwordController
                                                                          .value
                                                                          .text ==
                                                                      passwordRepeatController
                                                                          .value
                                                                          .text
                                                              ? () {
                                                                  setState(() {
                                                                    _step = 12;
                                                                  });
                                                                }
                                                              : null,
                                                        );
                                                      });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _step == 12,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Congratulations!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Text(
                                            "Now everything is set up to create your new DTube user!\n\nIf you are ready to start your DTube journey feel free to click \"Sign Up\". You will get logged in automatically!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CustomBackButton(
                                                onTapped: !_signUpPressed
                                                    ? () {
                                                        setState(() {
                                                          _step = 10;
                                                        });
                                                      }
                                                    : null),
                                            ValueListenableBuilder<
                                                    TextEditingValue>(
                                                valueListenable:
                                                    passwordController,
                                                builder:
                                                    (context, value, child) {
                                                  return ElevatedButton(
                                                    onPressed: !_signUpPressed
                                                        ? () {
                                                            createUserAccount();
                                                            setState(() {
                                                              _signUpPressed =
                                                                  true;
                                                            });
                                                          }
                                                        : null,
                                                    child: Container(
                                                      width: 25.w,
                                                      child: !_signUpPressed
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Sign Up",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline5,
                                                                ),
                                                                FaIcon(
                                                                  FontAwesomeIcons
                                                                      .rocket,
                                                                  size: 5.w,
                                                                )
                                                              ],
                                                            )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }
            }));
  }

  createUserAccount() async {
    String _signUpAccount = await sec.getLocalConfigString(settingKey_suAcc);

    String _signUpKey = await sec.getLocalConfigString(settingKey_suLogin);

    TxData txdata = TxData(
        name: usernameController.value.text,
        pub: publicKeyController.value.text);
    // TODO: replace txType 0 with 24 and provide the bw to transfer to the new account!
    Transaction newTx = Transaction(type: 0, data: txdata);

    _txBloc.add(SignAndSendTransactionEvent(
        tx: newTx,
        administrativeUsername: _signUpAccount,
        administrativePrivateKey: _signUpKey));
  }

  storeUserToFirebase() async {
    _thirdPartyLoginBloc.add(StoreThirdPartyLoginEvent(
        data: ThirdPartyLoginDecrypted(
            socialLoginUid: widget.socialLoginBaseData.socialLoginUid,
            socialLoginProvider: widget.socialLoginBaseData.socialLoginProvider,
            dTubePublicKey: publicKeyController.value.text,
            dTubeUsername: usernameController.value.text,
            dTubeDecyptedPrivateKey: privateKeyController.value.text),
        password: passwordController.value.text,
        socialUId: widget.socialUId));
    // just to be very sure that the data got saved we are waiting for 4 seconds
    await Future.delayed(Duration(milliseconds: 4000));
  }
}
