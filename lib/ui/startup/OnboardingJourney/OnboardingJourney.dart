import 'package:dtube_go/ui/startup/OnboardingJourney/Pages.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';

import 'package:introduction_screen/introduction_screen.dart';

import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class OnboardingJourney extends StatefulWidget {
  OnboardingJourney({Key? key, required this.journeyDoneCallback})
      : super(key: key);

  VoidCallback journeyDoneCallback;
  @override
  _OnboardingJourneyState createState() => _OnboardingJourneyState();
}

class _OnboardingJourneyState extends State<OnboardingJourney> {
  late AuthBloc _loginBloc;

  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    _loginBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
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
            child: Align(
                alignment: Alignment.topCenter, child: DTubeLogo(size: 70)),
          ),
        ),
      ),

      pages: [
        welcomePage(pageDecoration, context),
        meaningOfDTubePage(pageDecoration, context),
        freeAccessPage(pageDecoration, context),
        globalCommunityPage(pageDecoration, context),
        dTubeCoinsPage(pageDecoration, context),
        exchangesPage(pageDecoration, context),
        engagementPage(pageDecoration, context),
        finishedPage(pageDecoration, context)
      ],
      onDone: () => widget.journeyDoneCallback(),
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
}
