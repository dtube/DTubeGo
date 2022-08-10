import 'package:dtube_go/bloc/appstate/appstate_bloc_full.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/bloc/thirdPartyLogin/thirdPartyLogin_bloc_full.dart';
import 'package:dtube_go/bloc/transaction/transaction_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:dtube_go/ui/MainContainer/NavigationContainer.dart';
import 'package:dtube_go/ui/startup/Startup.dart';
import 'package:dtube_go/ui/startup/login/pages/SocialUserNewAccount.dart';
import 'package:dtube_go/ui/widgets/DialogTemplates/DialogWithTitleLogo.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SocialUserActionPopup extends StatefulWidget {
  SocialUserActionPopup({Key? key, required this.socialUId}) : super(key: key);
  final String socialUId;
  @override
  State<SocialUserActionPopup> createState() => _SocialUserActionPopupState();
}

class _SocialUserActionPopupState extends State<SocialUserActionPopup> {
  TextEditingController passwordController = new TextEditingController();
  late ThirdPartyLoginBloc _loginBloc;
  @override
  void initState() {
    _loginBloc = BlocProvider.of<ThirdPartyLoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThirdPartyLoginBloc, ThirdPartyLoginState>(
        bloc: _loginBloc,
        builder: (context, state) {
          if (state is ThirdPartyLoginLoadedState) {
            return PopUpDialogWithTitleLogo(
              titleWidgetPadding: 5.w,
              titleWidgetSize: 20.w,
              callbackOK: () {},
              titleWidget: FaIcon(
                FontAwesomeIcons.key,
                size: 20.w,
                color: globalRed,
              ),
              showTitleWidget: true,
              child: Container(
                width: 95.w,
                height: 30.h,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text("Enter your password",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    Container(
                      width: 50.w,
                      child: TextField(
                        style: Theme.of(context).textTheme.bodyText1,
                        controller: passwordController,
                        cursorColor: globalRed,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                        valueListenable: passwordController,
                        builder: (context, value, child) {
                          return ElevatedButton(
                              onPressed: passwordController.text.length >= 8
                                  ? () {
                                      _loginBloc.add(
                                          DecryptThirdPartyLoginEvent(
                                              data: state.encryptedLoginData,
                                              password:
                                                  passwordController.value.text,
                                              socialUId: widget.socialUId));
                                    }
                                  : null,
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.headline5,
                              ));
                        }),
                  ],
                ),
              ),
            );
          } else if (state is ThirdPartyLoginNotFoundState) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                    create: (context) =>
                        UserBloc(repository: UserRepositoryImpl())),
                BlocProvider<AuthBloc>(
                    create: (BuildContext context) =>
                        AuthBloc(repository: AuthRepositoryImpl())),
                BlocProvider(
                    create: (context) => TransactionBloc(
                        repository: TransactionRepositoryImpl())),
              ],
              child: SocialUserNewAccount(
                socialLoginBaseData: state.encryptedLoginData,
                socialUId: widget.socialUId,
              ),
            );
          } else if (state is ThirdPartyLoginDecryptingState) {
            return DtubeLogoPulseWithSubtitle(
                subtitle: "Decrypting with your password...", size: 40.w);
          } else if (state is ThirdPartyLoginStoredState) {
            return signIn(state.decryptedLoginData.dTubeUsername,
                state.decryptedLoginData.dTubeDecyptedPrivateKey);
          } else if (state is ThirdPartyLoginDecryptedState) {
            return signIn(
              state.decryptedLoginData.dTubeUsername,
              state.decryptedLoginData.dTubeDecyptedPrivateKey,
            );
          } else {
            return Container(
                height: 50.h,
                width: 95.w,
                child: DtubeLogoPulseWithSubtitle(
                    subtitle: "loading..", size: 40.w));
          }
        });
  }

  Widget signIn(String username, String privateKey) {
    // return MultiBlocProvider(providers: [
    //   BlocProvider<UserBloc>(
    //       create: (context) => UserBloc(repository: UserRepositoryImpl())),
    //   BlocProvider<AuthBloc>(
    //     create: (BuildContext context) =>
    //         AuthBloc(repository: AuthRepositoryImpl())
    //           ..add(SignInWithCredentialsEvent(
    //               username: username, privateKey: privateKey)),
    //   ),
    //   BlocProvider(
    //     create: (context) =>
    //         IPFSUploadBloc(repository: IPFSUploadRepositoryImpl()),
    //   ),
    //   BlocProvider(
    //     create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
    //   ),
    //   BlocProvider(
    //     create: (context) => AppStateBloc(),
    //   ),
    // ], child: StartUp());
    return BlocProvider<AuthBloc>(
      create: (context) {
        // add the AppStartedEvent to try to login with perhaps existing login credentails and forward to the startup "dialog"
        return AuthBloc(repository: AuthRepositoryImpl())
          ..add(SignInWithCredentialsEvent(
              username: username, privateKey: privateKey));
      },
      child: StartUp(),
    );
  }
}
