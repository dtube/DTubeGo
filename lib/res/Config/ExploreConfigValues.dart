import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExploreConfig {
  // generic curation tags to exclude from suggested channels/videos
  static List<String> genericCurationTags = ["vdc", "onelovedtube"];

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
        "acapella",
        "livemusic",
        "electromusic",
        "rock",
        "hiphop",
        "musictheory",
        "drums",
        "beat",
        "beats",
        "lofi",
        "punk",
        "metal",
        "classical",
        "musictutorial"
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
        "workout",
        "gymnastics",
        "voleyball",
        "socker",
        "basketball",
        "jogging",
        "pushups",
        "situps",
        "muscles"
      ],
    },
    {
      "mainTag": "gaming",
      "icon": FontAwesomeIcons.gamepad,
      "subtags": [
        "ps4",
        "ps5",
        "gaming",
        "simulation",
        "shooter",
        "sports",
        "retro",
        "cardgame",
        "adventure",
        "games",
        "game",
        "metaverse",
        "vr"
      ],
    },
    {
      "mainTag": "health",
      "icon": FontAwesomeIcons.heartPulse,
      "subtags": [
        "yoga",
        "health",
        "healthtips",
        "meditation",
      ],
    },
    {
      "mainTag": "science",
      "icon": FontAwesomeIcons.userAstronaut,
      "subtags": [
        "physics",
        "chemistry",
        "math",
        "science",
        "languages",
        "learning"
      ],
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
        "tutorial",
        "repair",
        "coding",
        "techtutorial",
        "musictutorial",
        "howto",
      ],
    },
    {
      "mainTag": "tech",
      "icon": FontAwesomeIcons.laptop,
      "subtags": [
        "coding",
        "tech",
        "software",
        "hardware",
        "server",
        "api",
        "node",
        "avalon",
        "programming"
      ],
    },
    {
      "mainTag": "blockchains",
      "icon": FontAwesomeIcons.dice,
      "subtags": [
        "nft",
        "crypto",
        "cryptocurrency",
        "bitcoin",
        "etherium",
        "opensea",
        "objkt",
        "tezos",
        "litecoin",
        "binance",
        "hex",
        "eth",
        "ltc",
        "bnc",
        "btc",
        "bnb",
        "smartcontract",
        "avalon",
        "dtc",
        "proposal",
        "fundrequest",
        "dao",
        "decentralized",
        "decentralization",
        "hive",
        "blurt",
        "steem"
      ],
    },
    {
      "mainTag": "art",
      "icon": FontAwesomeIcons.paintbrush,
      "subtags": [
        "drawing",
        "painting",
        "art",
        "dance",
        "dancing",
        "videoart",
        "sculpting",
        "digitalart"
      ],
    },
    {
      "mainTag": "vlogs",
      "icon": FontAwesomeIcons.video,
      "subtags": [
        "vlog",
        "dailyvlog",
        "vlogs",
        "travel",
        "roadtrip",
      ],
    },
    {
      "mainTag": "communities",
      "icon": FontAwesomeIcons.cubes,
      "subtags": [
        "cleanplanet",
        "skatehive",
        "dtube",
        "hive",
        "blurt",
        "steem",
      ],
    },
    {
      "mainTag": "lifestyle",
      "icon": FontAwesomeIcons.vestPatches,
      "subtags": [
        "lifestyle",
        "fashion",
        "makeup",
        "travel",
        "haul",
      ],
    },
    {
      "mainTag": "fun",
      "icon": FontAwesomeIcons.tv,
      "subtags": [
        "funny",
        "entertainment",
        "skit",
        "comedy",
        "challenge",
      ],
    },
    {
      "mainTag": "news",
      "icon": FontAwesomeIcons.newspaper,
      "subtags": [
        "news",
        "politics",
        "crypto",
        "tech",
      ],
    },
    {
      "mainTag": "talks",
      "icon": FontAwesomeIcons.microphoneLines,
      "subtags": [
        "talks",
        "podcasts",
        "chatting",
        "justchatting",
        "zoom",
      ],
    },
    {
      "mainTag": "nature",
      "icon": FontAwesomeIcons.leaf,
      "subtags": [
        "nature",
        "animals",
        "animal",
        "gardening",
        "harvest",
        "forrest",
        "cleanplanet",
        "trees",
        "beach",
        "field"
      ],
    },
    {
      "mainTag": "food",
      "icon": FontAwesomeIcons.utensils,
      "subtags": [
        "cooking",
        "restaurant",
        "dinner",
        "lunch",
        "food",
        "eating",
        "meal",
        "breakfast",
      ]
    },
  ];
  // suggestion params
  static int maxUserSuggestions =
      30; // max count of users shown in the suggestions
  static int maxPostSuggestions =
      30; // max count of posts shown in the suggestions

  static int maxDaysInPastForSuggestions =
      150; // max count of days the suggestion algorythm should check the past

}
