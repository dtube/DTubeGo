import 'package:dtube_togo/utils/ResponsiveLayout.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dtube_togo/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/user/user_bloc_full.dart';
import 'package:dtube_togo/style/dtubeLoading.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';
import 'package:dtube_togo/ui/MainContainer/NavigationContainer.dart';
import 'package:dtube_togo/ui/widgets/PinPadWidget.dart';
import 'package:dtube_togo/utils/secureStorage.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:dtube_togo/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_togo/res/appConfigValues.dart';
import 'package:dtube_togo/style/OpenableHyperlink.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class PinPadScreen extends StatefulWidget {
  PinPadScreen({Key? key}) : super(key: key);

  @override
  _PinPadScreenState createState() => _PinPadScreenState();
}

class _PinPadScreenState extends State<PinPadScreen> {
  @override
  void initState() {
    BlocProvider.of<SettingsBloc>(context).add(FetchSettingsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoadedState) {
        if (state.settings[settingKey_pincode] != "") {
          return PinPad(
            storedPin: state.settings[settingKey_pincode],
          );
        } else {
          return MultiBlocProvider(providers: [
            BlocProvider<UserBloc>(
                create: (context) =>
                    UserBloc(repository: UserRepositoryImpl())),
            BlocProvider<AuthBloc>(
              create: (BuildContext context) =>
                  AuthBloc(repository: AuthRepositoryImpl()),
            ),
            BlocProvider(
              create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
            ),
          ], child: NavigationContainer());
        }
      }
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: globalBlue,
        body: Center(
            child: DTubeLogoPulse(size: MediaQuery.of(context).size.width / 3)),
      );
    });
  }
}

class PinPad extends StatefulWidget {
  String? storedPin;
  PinPad({Key? key, this.storedPin}) : super(key: key);

  @override
  _PinPadState createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  late AuthBloc _loginBloc;
  TextEditingController _pinPutController = new TextEditingController();

  void _printLatestValue() {
    print('Second text field: ${_pinPutController.text}');
    if (_pinPutController.text == widget.storedPin) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return MultiBlocProvider(providers: [
            BlocProvider<UserBloc>(
                create: (context) =>
                    UserBloc(repository: UserRepositoryImpl())),
            BlocProvider<AuthBloc>(
              create: (BuildContext context) =>
                  AuthBloc(repository: AuthRepositoryImpl()),
            ),
            BlocProvider(
              create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
            ),
          ], child: NavigationContainer());
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //  _loginBloc = BlocProvider.of<AuthBloc>(context);
    //if logindata already stored
    _pinPutController.addListener(_printLatestValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: globalBlue,
        body: ResponsiveLayout(
          portrait: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DTubeLogo(size: 50.w),
                  SizedBox(height: 10.h),
                  Container(
                    width: 60.w,
                    child: PinPadWidget(
                      pinPutController: _pinPutController,
                      requestFocus: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("enter your pin",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ],
              )),
          landscape: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DTubeLogo(size: 20.w),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("please enter your pin",
              //       style: Theme.of(context).textTheme.headline5),
              // ),
              Container(
                width: 60.w,
                height: 20.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      child: PinPadWidget(
                        pinPutController: _pinPutController,
                        requestFocus: true,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text("enter your pin",
                        style: Theme.of(context).textTheme.headline5),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
