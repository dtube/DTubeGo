import 'package:dtube_go/bloc/web3storage/web3storage_bloc_full.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

import 'package:dtube_go/ui/startup/eula/EulaScreen.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

import 'dart:math';
import 'package:dtube_go/bloc/appstate/appstate_bloc.dart';
import 'package:dtube_go/bloc/ipfsUpload/ipfsUpload_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:dtube_go/utils/Layout/ResponsiveLayout.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_go/bloc/user/user_bloc_full.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/dtubeLoading.dart';
import 'package:dtube_go/ui/MainContainer/NavigationContainer.dart';
import 'package:dtube_go/ui/widgets/PinPadWidget.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PinPadScreen extends StatefulWidget {
  PinPadScreen({Key? key, required this.currentTermsAccepted})
      : super(key: key);
  final bool currentTermsAccepted;

  @override
  _PinPadScreenState createState() => _PinPadScreenState();
}

class _PinPadScreenState extends State<PinPadScreen> {
  late bool _termsAccepted;
  late String apiNode;

  @override
  void initState() {
    super.initState();
    _termsAccepted = widget.currentTermsAccepted;
  }

  void eulaAcceptedCallback() async {
    await sec.persistCurrentTermsAccepted();

    setState(() {
      _termsAccepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_termsAccepted) {
      // if terms have changed or never have been accepted on this device
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: globalBlue,
        body: Center(
          child: EULAScreen(
            eulaAcceptedCallback: eulaAcceptedCallback,
          ),
        ),
      );
    } else {
      // if terms have been accepted and did not change since last version
      return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
        if (state is SettingsLoadedState) {
          if (state.settings[settingKey_pincode] != "") {
            // if the pin is set -> show PinPad
            return PinPad(
              storedPin: state.settings[settingKey_pincode],
            );
          } else {
            // if there is no pin set to secure the app -> forward directly to the main navigation container
            // with providing all necessary blocs
            return MultiBlocProvider(providers: [
              BlocProvider<UserBloc>(
                  create: (context) =>
                      UserBloc(repository: UserRepositoryImpl())),
              BlocProvider<AuthBloc>(
                create: (BuildContext context) =>
                    AuthBloc(repository: AuthRepositoryImpl()),
              ),
              // TODO: delete?
              // BlocProvider(
              //   create: (context) =>
              //       IPFSUploadBloc(repository: IPFSUploadRepositoryImpl()),
              // ),
              BlocProvider(
                create: (context) =>
                    Web3StorageBloc(repository: Web3StorageRepositoryImpl()),
              ),
              BlocProvider(
                create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
              ),
              BlocProvider(
                create: (context) => AppStateBloc(),
              ),
            ], child: NavigationContainer());
          }
        }

        // as long as the settings are not loaded show a loading screen
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: globalBlue,
            body: Center(
              child: DtubeLogoPulseWithSubtitle(
                subtitle: "we are using:\n" +
                    globals.currentApiNode +
                    "\n\nloading your settings..",
                size: kIsWeb ? 10.w : 40.w,
              ),
            ));
      });
    }
  }
}

class PinPad extends StatefulWidget {
  final String? storedPin;
  PinPad({Key? key, this.storedPin}) : super(key: key);

  @override
  _PinPadState createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  TextEditingController _pinPutController = new TextEditingController();
  String _pinMessage = "enter your pin";
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  void _checkLastCharacter() {
    if (_pinPutController.text.length == 5) {
      if (_pinPutController.text == widget.storedPin) {
        // if the pin is correct
        // forward the user to the main navigation container with providing all necessary blocs
        // but set the navigation container additionally as the "first screen"
        // to avoid bringing the user back to the pin dialog if the hardware back button is pressed
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
                create: (context) =>
                    IPFSUploadBloc(repository: IPFSUploadRepositoryImpl()),
              ),
              BlocProvider(
                create: (context) => FeedBloc(repository: FeedRepositoryImpl()),
              ),
              BlocProvider(
                create: (context) => AppStateBloc(),
              ),
            ], child: NavigationContainer());
          }),
        );
      } else {
        // if the pin is not correct
        setState(() {
          _pinPutController.text = "";
          _pinMessage = "please try again";
          _shakeKey.currentState?.shake();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _pinPutController.addListener(_checkLastCharacter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: globalBlue,
        body: ResponsiveLayout(
          mobileBody: PinPadMobile(pinPutController: _pinPutController),
          tabletBody: PinPadDesktop(
              pinPutController: _pinPutController,
              shakeKey: _shakeKey,
              pinMessage: _pinMessage),
          desktopBody: PinPadDesktop(
              pinPutController: _pinPutController,
              shakeKey: _shakeKey,
              pinMessage: _pinMessage),
        ));
  }
}

class PinPadMobile extends StatelessWidget {
  const PinPadMobile({
    Key? key,
    required TextEditingController pinPutController,
  })  : _pinPutController = pinPutController,
        super(key: key);

  final TextEditingController _pinPutController;

  @override
  Widget build(BuildContext context) {
    return Align(
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
        ));
  }
}

class PinPadDesktop extends StatelessWidget {
  const PinPadDesktop({
    Key? key,
    required TextEditingController pinPutController,
    required GlobalKey<ShakeWidgetState> shakeKey,
    required String pinMessage,
  })  : _pinPutController = pinPutController,
        _shakeKey = shakeKey,
        _pinMessage = pinMessage,
        super(key: key);

  final TextEditingController _pinPutController;
  final GlobalKey<ShakeWidgetState> _shakeKey;
  final String _pinMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DTubeLogo(size: 20.w),
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
                  key: ValueKey(0),
                  requestFocus: true,
                ),
              ),
              SizedBox(height: 5.h),
              ShakeWidget(
                shakeOffset: 10,
                key: _shakeKey,
                shakeCount: 4,
                shakeDuration: Duration(milliseconds: 500),
                child: Text(
                  _pinMessage,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class for shaking th error message when pin is incorrect
abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);
  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: animationController,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(sineValue * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }
}
