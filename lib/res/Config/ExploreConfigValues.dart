import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreConfig {
  // generic curation tags to exclude from suggested channels/videos
  static List<String> genericCurationTags = ["vdc", "onelovedtube"];

  // global settings -> tags: those are the possible tags
  static List<String> possibleExploreTags = [
    "dtube",
    "dtubeGo",
    // outside

    "travel",
    "gardening",
    "nature",
    "animals",

    // knowhow
    "howto",
    "tutorial",
    "DIY",
    "cooking",
    // tech
    "tech",
    "blockchain",
    "crypto",
    // news
    "news",
    "politics",
    // entertainment
    "entertainment",
    "funny",
    "gaming",
    "dailyvlog",
    "vlog",
    // art
    "art",
    "painting",
    "music",
    "dance",
    // lifestyle
    "fashion",
    "lifestyle",
    "health",
    "sports",
    "skate",
    // others
    "psychology",
    "horology",
    // communities
    "skatehive",
    "cleanplanet"
  ];
  static var genreTags = [
    {
      "mainTag": "music",
      "icon": FontAwesomeIcons.music,
      "subtags": [
        "song",
        "music",
        "acoustic",
        "songs",
        "guitar",
        "piano",
        "acapella"
      ]
    },
    {
      "mainTag": "sports",
      "icon": FontAwesomeIcons.personRunning,
      "subtags": [
        "sports",
        "football",
        "skate",
        "skatehive",
        "running",
        "marathon",
        "gym",
        "workout"
      ],
    },
    {
      "mainTag": "gaming",
      "icon": FontAwesomeIcons.gamepad,
      "subtags": ["ps4", "ps5", "gaming"],
    },
    {
      "mainTag": "health",
      "icon": FontAwesomeIcons.heartPulse,
      "subtags": ["yoga", "health"],
    },
    {
      "mainTag": "science",
      "icon": FontAwesomeIcons.userAstronaut,
      "subtags": ["physics", "chemistry", "math"],
    },
    {
      "mainTag": "diy",
      "icon": FontAwesomeIcons.wrench,
      "subtags": [
        "woodworking",
        "diy",
        "crafting",
        "3dprinting",
        "cooking",
        "tutorial"
      ],
    },
    {
      "mainTag": "tech",
      "icon": FontAwesomeIcons.laptop,
      "subtags": ["coding", "tech", "software"],
    },
    {
      "mainTag": "blockchains",
      "icon": FontAwesomeIcons.dice,
      "subtags": [
        "nft",
        "crypto",
        "cryptocurrency",
        "bitcoing",
        "etherium",
        "opensea",
        "objkt",
        "tezos",
        "litecoin",
        "binance",
        "hex",
        // asd
        "nft",
        "crypto",
        "cryptocurrency",
        "bitcoing",
        "etherium",
        "opensea",
        "objkt",
        "tezos",
        "litecoin",
        "binance",
        "hex"
      ],
    },
    {
      "mainTag": "art",
      "icon": FontAwesomeIcons.paintBrush,
      "subtags": ["drawing", "painting", "art", "dance", "dancing"],
    },
    {
      "mainTag": "vlogs",
      "icon": FontAwesomeIcons.video,
      "subtags": ["vlog", "dailyvlog", "vlogs"],
    },
    {
      "mainTag": "communities",
      "icon": FontAwesomeIcons.cubes,
      "subtags": ["cleanplanet", "skatehive"],
    },
    {
      "mainTag": "lifestyle",
      "icon": FontAwesomeIcons.vestPatches,
      "subtags": ["lifestyle", "fashion", "makeup", "travel"],
    },
    {
      "mainTag": "fun",
      "icon": FontAwesomeIcons.tv,
      "subtags": ["funny", "entertainment", "skit", "comedy"],
    },
    {
      "mainTag": "news",
      "icon": FontAwesomeIcons.newspaper,
      "subtags": ["news", "politics"],
    },
    {
      "mainTag": "talks",
      "icon": FontAwesomeIcons.microphoneLines,
      "subtags": ["talks", "podcasts"],
    },
    {
      "mainTag": "nature",
      "icon": FontAwesomeIcons.leaf,
      "subtags": ["nature", "animals", "gardening", "forrest"],
    },
    {
      "mainTag": "food",
      "icon": FontAwesomeIcons.utensils,
      "subtags": ["cooking", "restaurant", "dinner", "lunch", "food"]
    },
  ];
  // suggestion params
  static int maxUserSuggestions =
      50; // max count of users shown in the suggestions
  static int maxPostSuggestions =
      50; // max count of posts shown in the suggestions

  static int maxDaysInPastForSuggestions =
      75; // max count of days the suggestion algorythm should check the past

}
