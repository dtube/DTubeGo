import 'package:dtube_go/utils/SecureStorage.dart' as sec;
import 'dart:io';

import 'package:dtube_go/ui/widgets/players/BetterPlayer.dart';
import 'package:dtube_go/utils/GetAppDocDirectory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dtube_go/style/styledCustomWidgets.dart';
import 'package:dtube_go/ui/startup/LoginScreen.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class OnboardingJourney extends StatefulWidget {
  bool loggedIn;
  OnboardingJourney({Key? key, required this.loggedIn}) : super(key: key);

  @override
  _OnboardingJourneyState createState() => _OnboardingJourneyState();
}

class _OnboardingJourneyState extends State<OnboardingJourney> {
  late AuthBloc _loginBloc;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController privateKeyController = new TextEditingController();

  @override
  void initState() {
    _saveAssetVideoToFile("firstpage.mp4");
    super.initState();
    _loginBloc = BlocProvider.of<AuthBloc>(context);
    //if logindata already stored
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context, bool loggedIn) async {
    if (!loggedIn) {
      await sec.persistOpenedOnce();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider<AuthBloc>(
              create: (BuildContext context) =>
                  AuthBloc(repository: AuthRepositoryImpl()),
              child: LoginForm()),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headline1!,
      bodyTextStyle: Theme.of(context).textTheme.bodyText1!,
      descriptionPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      pageColor: globalBlue,
      imagePadding: EdgeInsets.all(16),
      imageFlex: 3,
      bodyFlex: 1,
      titlePadding: EdgeInsets.only(bottom: 8, top: 16),
      bodyAlignment: Alignment.bottomCenter,
      //imageAlignment: Alignment.topLeft
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: globalBlue,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Align(alignment: Alignment.topLeft, child: DTubeLogo(size: 70)),
          ),
        ),
      ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'I know this already',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        PageViewModel(
          title: "Intro page",
          body: "This is the subtitle of the intro page to prepare for videos.",
          image: Align(
              alignment: Alignment.topCenter,
              child: DTubeLogo(
                size: 150,
              )),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "First page",
          body: "This is the subtitle of the first video.",
          image: Align(
              alignment: Alignment.topCenter,
              child: OnboardingVideo(videoname: "firstpage.mp4")),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Second page",
          body: "This is the subtitle of the second video.",
          image: OnboardingVideo(videoname: "firstpage.mp4"),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Third page",
          body: "This is the subtitle of the third video.",
          image: OnboardingVideo(videoname: "firstpage.mp4"),
          decoration: pageDecoration,
          reverse: true,
        ),
        PageViewModel(
          title: "Final page",
          body: "This is the subtitle of the final video.",
          image: OnboardingVideo(videoname: "firstpage.mp4"),
          decoration: pageDecoration,
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context, widget.loggedIn),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: Text(
        'Skip',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      next: Icon(
        Icons.arrow_forward,
        color: globalAlmostWhite,
      ),
      done: Text(
        'Done',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(20.0, 10.0),
        color: globalAlmostWhite,
        activeSize: Size(32.0, 10.0),
        activeColor: globalRed,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: globalBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  ///Save video to file, so we can use it later
  Future _saveAssetVideoToFile(String assetFile) async {
    var content = await rootBundle.load("assets/videos/" + assetFile);
    final directory = await getApplicationDocumentsDirectory();
    var file = File(directory.path + '/' + assetFile);
    file.writeAsBytesSync(content.buffer.asUint8List());
    print("test");
  }
}

class OnboardingVideo extends StatelessWidget {
  OnboardingVideo({Key? key, required this.videoname}) : super(key: key);
  String videoname;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      //height: deviceHeight * 0.6,
      width: deviceWidth * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<String>(
          future: getFileUrl(videoname),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data != null) {
              //return BetterPlayer.file(snapshot.data!);
              return BP(
                videoUrl: snapshot.data!,
                looping: false,
                autoplay: true,
                localFile: true,
                controls: false,
                usedAsPreview: false,
                allowFullscreen: false,
                portraitVideoPadding: 50.0,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
