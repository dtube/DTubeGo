import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:introduction_screen/introduction_screen.dart';

PageViewModel welcomePage(PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget:
        Text("Welcome to DTube!", style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "DTube is an add-free social media platform based on the Avalon blockchain. On DTube you can share your videos, make friends with other creators and earn crypto at the same time.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: FadeInUpBig(
        preferences: AnimationPreferences(
            offset: Duration(milliseconds: 120),
            duration: Duration(milliseconds: 1500)),
        child: Image.asset(
          "assets/gifs/hovering_girl1.gif",
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
      ),
      // ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel meaningOfDTubePage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget: Text("The Meaning of DTube",
        style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "The name DTube comes from D(ecentralized) Tube. The underlaying Avalon blockchain is a decentralized system which is managed, maintained and developed by various different persons around the globe.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: FadeInDownBig(
      preferences: AnimationPreferences(
          offset: Duration(milliseconds: 120),
          duration: Duration(milliseconds: 1500)),
      child: Image.asset(
        "assets/gifs/hovering_network.gif",
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel dTubeCoinsPage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget:
        Text("DTC and VP", style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "For every upload, comment and vote on DTube you'll need Voting Power (VP). This power is generated the cryptocurrency called DTC aka DTube Coins. You can earn DTC from other peoples upvotes on your content but also from upvotes made by you on others content.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: FadeInUpBig(
      preferences: AnimationPreferences(
          offset: Duration(milliseconds: 120),
          duration: Duration(milliseconds: 1500)),
      child: Image.asset(
        "assets/gifs/hovering_guy.gif",
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel engagementPage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget: Text("Engagement is the Key",
        style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "Engagement is very important on any social media platform. Build a name, gain followers and find new friends by interacting with other peoples content. Commenting is only one of the many ways to engage on DTube.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: Image.asset(
      "assets/gifs/hovering_messages.gif",
      fit: BoxFit.fill,
      filterQuality: FilterQuality.high,
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel globalCommunityPage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget:
        Text("Global Community", style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "Our community consists of people from all around the globe. You'll probably find someone from your country but also people and stories from the other side of the world.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: ZoomIn(
      preferences: AnimationPreferences(
          offset: Duration(milliseconds: 120),
          duration: Duration(milliseconds: 1500)),
      child: Image.asset(
        "assets/gifs/hovering_globe.gif",
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel exchangesPage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget:
        Text("How to get DTC", style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "Like mentioned before you can earn DTC by upvotes or from a tip by a viewer of your content. A faster way is to buy or swap DTC on the market. Make sure to check the FAQ section inside the app for more details and the supported exchanges.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: JackInTheBox(
      preferences: AnimationPreferences(
          offset: Duration(milliseconds: 120),
          duration: Duration(milliseconds: 1500)),
      child: Image.asset(
        "assets/gifs/hovering_graph.gif",
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel freeAccessPage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget:
        Text("DTube is Free", style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "DTube is a completely free platform and of course we do not sell any of your data because wefully respect your privacy!",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: Pulse(
      preferences: AnimationPreferences(
          magnitude: 0.2,
          autoPlay: AnimationPlayStates.Loop,
          offset: Duration(milliseconds: 1500),
          duration: Duration(milliseconds: 3000)),
      child: Image.asset(
        "assets/gifs/hovering_freeandprivate.gif",
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}

PageViewModel finishedPage(
    PageDecoration pageDecoration, BuildContext context) {
  return PageViewModel(
    titleWidget: Text("Now let's get started!",
        style: Theme.of(context).textTheme.headline1),
    bodyWidget: Text(
        "Now that you know all the basics of DTube and the Avalon blockchain, you are ready to signup, login and try DTube Go on your own!",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
        textAlign: TextAlign.justify),
    image: Pulse(
      preferences: AnimationPreferences(
          magnitude: 0.7,
          autoPlay: AnimationPlayStates.Loop,
          offset: Duration(milliseconds: 1500),
          duration: Duration(milliseconds: 3000)),
      child: JackInTheBox(
        preferences: AnimationPreferences(
            offset: Duration(milliseconds: 120),
            duration: Duration(milliseconds: 1500)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Container(
              width: 90.w,
              child: Image.asset(
                "assets/images/D_RocketOLC.png",
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    ),
    decoration: pageDecoration,
    reverse: false,
  );
}
