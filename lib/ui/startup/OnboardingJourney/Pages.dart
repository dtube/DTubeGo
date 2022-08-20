import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:introduction_screen/introduction_screen.dart';

class PageContent {
  String title;
  String description;
  String assetImage;
  PageContent({
    required this.title,
    required this.description,
    required this.assetImage,
  });
}

List<PageContent> pageList = [
  new PageContent(
    title: "Welcome to DTube!",
    description:
        "DTube is an add-free social media platform based on the Avalon blockchain. On DTube you can share your videos, make friends with other creators and earn crypto at the same time.",
    assetImage: "assets/gifs/hovering_girl1.gif",
  ),
  new PageContent(
    title: "The Meaning of DTube",
    description:
        "The name DTube comes from D(ecentralized) Tube. The underlaying Avalon blockchain is a decentralized system which is managed, maintained and developed by various different persons around the globe.",
    assetImage: "assets/gifs/hovering_network.gif",
  ),
  new PageContent(
    title: "DTC and VP",
    description:
        "For every upload, comment and vote on DTube you'll need Voting Power (VP). This power is generated the cryptocurrency called DTC aka DTube Coins. You can earn DTC from other peoples upvotes on your content but also from upvotes made by you on others content.",
    assetImage: "assets/gifs/hovering_guy.gif",
  ),
  new PageContent(
    title: "Engagement is the Key",
    description:
        "Engagement is very important on any social media platform. Build a name, gain followers and find new friends by interacting with other peoples content. Commenting is only one of the many ways to engage on DTube.",
    assetImage: "assets/gifs/hovering_messages.gif",
  ),
  new PageContent(
    title: "Global Community",
    description:
        "Our community consists of people from all around the globe. You'll probably find someone from your country but also people and stories from the other side of the world.",
    assetImage: "assets/gifs/hovering_globe.gif",
  ),
  new PageContent(
    title: "How to get DTC",
    description:
        "Like mentioned before you can earn DTC by upvotes or from a tip by a viewer of your content. A faster way is to buy or swap DTC on the market. Make sure to check the FAQ section inside the app for more details and the supported exchanges.",
    assetImage: "assets/gifs/hovering_graph.gif",
  ),
  new PageContent(
    title: "DTube is Free",
    description:
        "DTube is a completely free platform and of course we do not sell any of your data because wefully respect your privacy!",
    assetImage: "assets/gifs/hovering_freeandprivate.gif",
  ),
  new PageContent(
    title: "Let's go!",
    description:
        "Now that you know all the basics of DTube and the Avalon blockchain, you are ready to signup, login and try DTube Go on your own!",
    assetImage: "assets/images/D_RocketOLC.png",
  ),
];
