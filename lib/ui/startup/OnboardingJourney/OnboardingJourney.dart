import 'package:dtube_go/ui/startup/OnboardingJourney/Pages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dtube_go/ui/startup/OnboardingJourney/Pages.dart';
import 'package:dtube_go/ui/widgets/dtubeLogoPulse/DTubeLogo.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:dtube_go/bloc/auth/auth_bloc_full.dart';
import 'package:dtube_go/style/ThemeData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;

class OnboardingJourney extends StatefulWidget {
  OnboardingJourney({Key? key, required this.journeyDoneCallback})
      : super(key: key);

  final VoidCallback journeyDoneCallback;
  @override
  _OnboardingJourneyState createState() => _OnboardingJourneyState();
}

class _OnboardingJourneyState extends State<OnboardingJourney> {
  final introKey = GlobalKey<IntroductionScreenState>();
  List<PageContent> walkThroughList = pageList;
  bool _textVisible = true;

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100.w,
        height: 100.h,
        color: globalBlue,
        child: Padding(
            padding: globals.mobileMode
                ? EdgeInsets.only(
                    top: 10.h, bottom: 10.h, left: 2.w, right: 2.w)
                : EdgeInsets.only(
                    top: 100, bottom: 100, left: 30.w, right: 30.w),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              PageView.builder(
                controller: pageController,
                itemCount: walkThroughList.length,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentIndexPage = value;
                    _textVisible = false;
                  });
                },
                itemBuilder: (context, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Container(
                          width: globals.mobileMode ? 90.w : 40.w,
                          height: globals.mobileMode ? 45.h : 35.h,
                          child: Image.asset(
                            walkThroughList[i].assetImage,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _textVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _textVisible
                                    ? walkThroughList[currentIndexPage].title
                                    : "",
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Text(
                                  _textVisible
                                      ? walkThroughList[currentIndexPage]
                                          .description
                                      : "",
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.center),
                            ),
                            currentIndexPage == walkThroughList.length - 1 &&
                                    _textVisible
                                ? Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.journeyDoneCallback();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                'assets/images/dtube_logo_white.png',
                                                width: 30),
                                          ),
                                          Text(
                                            "Enter DTube",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        ],
                                      ),
                                    ))
                                : SizedBox(height: 0),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                right: 20,
                top: 30,
                child: InkWell(
                  child: Text('SKIP INTRO',
                      style: Theme.of(context).textTheme.bodyText1),
                  onTap: () {
                    widget.journeyDoneCallback();
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: FaIcon(
                            FontAwesomeIcons.angleLeft,
                            color: currentIndexPage == 0
                                ? Colors.transparent
                                : globalAlmostWhite,
                          ),
                          onTap: () {
                            setState(() {
                              if (currentIndexPage > 0) {
                                _textVisible = false;
                                currentIndexPage--;
                                pageController
                                    .previousPage(
                                        duration: Duration(milliseconds: 350),
                                        curve: Curves.easeInOut)
                                    .whenComplete(() {
                                  setState(() {
                                    _textVisible = true;
                                  });
                                });
                              }
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < walkThroughList.length; i++)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                height: 4,
                                width: i == currentIndexPage ? 30 : 14,
                                decoration: BoxDecoration(
                                  color: i == currentIndexPage
                                      ? globalRed
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                          ],
                        ),
                        InkWell(
                          child: FaIcon(
                            FontAwesomeIcons.angleRight,
                            color:
                                currentIndexPage == walkThroughList.length - 1
                                    ? Colors.transparent
                                    : globalAlmostWhite,
                          ),
                          onTap: () {
                            setState(() {
                              if (currentIndexPage <
                                  walkThroughList.length - 1) {
                                _textVisible = false;
                                currentIndexPage++;
                                pageController
                                    .nextPage(
                                        duration: Duration(milliseconds: 350),
                                        curve: Curves.easeInOut)
                                    .whenComplete(() {
                                  setState(() {
                                    _textVisible = true;
                                  });
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ])));
  }
}
