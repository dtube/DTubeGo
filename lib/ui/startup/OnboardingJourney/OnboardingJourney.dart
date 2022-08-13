import 'package:responsive_sizer/responsive_sizer.dart';
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

  final VoidCallback journeyDoneCallback;
  @override
  _OnboardingJourneyState createState() => _OnboardingJourneyState();
}

class _OnboardingJourneyState extends State<OnboardingJourney> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.headline1!,
      bodyTextStyle: Theme.of(context).textTheme.bodyText1!,
      // descriptionPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      pageColor: globalBlue,
      imagePadding: EdgeInsets.only(top: 20.h),
      imageFlex: 3,
      bodyFlex: 1,

      imageAlignment: Alignment.bottomCenter,
      titlePadding: EdgeInsets.only(bottom: 0, top: 0),
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
                alignment: Alignment.topCenter, child: DTubeLogo(size: 20.w)),
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
      // skipFlex: 0,
      nextFlex: 0,
      dotsFlex: 0,
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
      controlsMargin: EdgeInsets.only(bottom: 2.h, right: 15.w),
      //controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 20.0, 4.0),
      controlsPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      dotsDecorator: DotsDecorator(
        size: Size(2.w, 2.w),
        color: globalAlmostWhite,
        activeSize: Size(5.w, 2.w),
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
