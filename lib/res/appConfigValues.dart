// list of global static application configurations

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppConfig {
  // feed url schemes
  static String myFeedUrlFirst = "/feed/##USERNAME";
  static String myFeedUrlMore = "/feed/##USERNAME/##AUTHOR/##LINK";
  static String myFeedUrlFiltered =
      "/feed/##USERNAME/filter:limit=500##FILTERSTRING";
  static String newFeedUrlFirst = "/new";
  static String newFeedUrlMore = "/new/##AUTHOR/##LINK";
  static String newFeedUrlFiltered = "/new/filter:limit=500##FILTERSTRING";
  static String hotFeedUrlFirst = "/hot";
  static String hotFeedUrlMore = "/hot/##AUTHOR/##LINK";
  static String trendingFeedUrlFirst = "/trending";
  static String trendingFeedUrlMore = "/trending/##AUTHOR/##LINK";
  static String accountFeedUrlFirst = "/blog/##USERNAME";
  static String accountFeedWithTSFilterUrlFirst = "/blog/##USERNAME";
  static String accountFeedUrlMore = "/blog/##USERNAME/##AUTHORNAME/##LINK";
  static String notificationFeedUrl = "/notifications/##USERNAME";

  // rewards and history url schemes
  static String rewardsUrl = "/votes/##REWARDSTATE/##USERNAME/0";
  static String accountHistoryFeedUrl = "/history/##USERNAME/##FROMBLOC";
  static String accountHistoryFeedUrlFromBlock = "/history/##USERNAME/##BLOCK";

  // DAO url schemes
  static String daoUrl = "/dao/##STATUS/##TYPE";
  static String daoVotesUrl = "/proposal/votes/##DAOID";
  static String daoProposalUrl = "/proposal/##DAOID";

// leaderboard url schemes
  static String leaderboardUrl = "/allminers";

  // detail url schemes
  static String postDataUrl = "/content/##AUTHOR/##LINK";
  static String accountDataUrl = "/account/##USERNAME";

  // search url schemes
  static String searchAccountsUrl =
      "https://search.d.tube/avalon.accounts/_search?q=name:*##SEARCHSTRING*&size=50&sort=balance:desc";
  static String searchPostsUrl =
      "https://search.d.tube/avalon.contents/_search?default_operator=OR&q=json.title:*##SEARCHSTRING*+author:*##SEARCHSTRING*+json.desc:*##SEARCHSTRING*&size=50&sort=ts:desc";

  // other avalon url schemes
  static String sendTransactionUrl = "/transactWaitConfirm";
  static String avalonConfig = "/config";
  static String accountPriceUrl = "/accountPrice/##USERNAME";

// storage providers and upload endpoints
  static String ipfsVideoUrl = "https://ipfs.d.tube/ipfs/";
  static String siaVideoUrl = "https://siasky.net/";
  static String ipfsUploadUrl = "https://ipfs.d.tube/ipfs/";
  static List<String> btfsUploadEndpoints = [
    "https://1.btfsu.d.tube",
    "https://2.btfsu.d.tube",
    "https://3.btfsu.d.tube",
    "https://4.btfsu.d.tube"
  ];

  static List<String> web3StorageEndpoints = ["https://dtube.fso.ovh:5082/"];
  static String web3StorageGateway = "https://ipfs.io";
  static int maxUploadRetries = 2;

  static String ipfsSnapUrl = 'https://snap1.d.tube/ipfs/';
  static String ipfsSnapUploadUrl = 'https://snap1.d.tube';

// verified url schemes
  static String originalDtuberListUrl = "https://dtube.fso.ovh/oc/creators";
  static String originalDtuberCheckUrl =
      "https://dtube.fso.ovh/oc/creator/##USERNAME";

// hivesigner config
  static String hiveSignerCallbackUrlScheme = 'dtubego';
  static String hiveSignerRedirectUrlHTMLEncoded =
      hiveSignerCallbackUrlScheme + '%3A%2F%2Foauth2redirect';
  static String hiveSignerAccessTokenUrl =
      'https://hivesigner.com/oauth2/authorize?client_id=dtubemobile&redirect_uri=${hiveSignerRedirectUrlHTMLEncoded}&scope=vote,comment';

  static String hiveSignerBroadcastAddress =
      'https://hivesigner.com/api/broadcast';

// node discovery & api node configs

  static bool useDevNodes =
      false; //activate for new features which has not been integrated

  static List<String> apiNodesDev = [
    // development nodes for new features
    // 'https://dtube.club/mainnetapi',
    'https://testnetapi.avalonblocks.com'
    //'https://avalon.tibfox.com'
  ];

  static List<String> apiNodes = [
    // common api nodes
    'https://avalon.tibfox.com',
    'https://avalon.d.tube',
    // 'https://dtube.club/mainnetapi',
    'https://avalon.oneloved.tube',
    'https://dtube.fso.ovh'
  ];

// node discovery & api node configs
  static Duration nodeDescoveryTimeout = Duration(milliseconds: 200);

  static int minFreeSpaceRecordVideoInMB =
      50; // min free space to enable the user to record video in app

// urls for login screen
  static String signUpUrl = "https://signup.d.tube";
  static String readmoreUrl = "https://token.d.tube";
  static String discordUrl = "https://discord.gg/dtube";
  static String faqUrl = "https://d.tube/#!/wiki/faq/README";
  static String gitDTubeGoUrl = "https://github.com/dtube/DTubeGo";
  static String gitAvalonUrl = "https://github.com/dtube/avalon";
  static String gitDtubeUrl = "https://github.com/dtube/dtube";

  // activate/deactivate first user journey
  static bool faqStartup = true; // show on first startup
  static bool faqVisible = false; // make the FAQ videos visible

// generic curation tags to exclude from suggested channels/videos
  static List<String> genericCurationTags = ["vdc", "onelovedtube"];

// only show moments of the last x days
  static int momentsPastXDays = -30;

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
      "icon": FontAwesomeIcons.running,
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
      "icon": FontAwesomeIcons.heartbeat,
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
      "icon": FontAwesomeIcons.microphoneAlt,
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

  static var initiativePresets = [
    {
      "name": "cleanplanet",
      "icon": FontAwesomeIcons.globe,
      "tag": "cleanplanet",
      "subject": "Cleanplanet walk",
      "description": "",
      "details": "## BASICS\n" +
          "Cleanplanet is an initiative to reward you for the act of picking litter in nature and your neighborhood.\n" +
          "## PROVE IT\n" +
          "Take a video of you or your friends while you pick up litter, put what you have collected in a public trash and tell us the date and your username as proof.\n" +
          "## UPLOAD IT\n" +
          "Upload your video on d.tube using the preset.\n\n" +
          "## GET REWARDED\n" +
          "Get rewarded for your eco-citizen act by a big like of the community!",
      "moreInfoURL": "https://cleanplanet.io",
      "imageURL":
          "https://cleanplanet.io/wp-content/uploads/2019/01/logo_clean_planet_Plan-de-travail-1-copie-3-3.png"
    },
    {
      "name": "diyhub",
      "icon": FontAwesomeIcons.tools,
      "tag": "diyhub",
      "subject": "DIYHub: ",
      "description": "",
      "details": "## BASICS\n" +
          "DIYHub is an initiative to reward you for sharing your knowledge in form of how-tos with the community.\n" +
          "## TOPICS\n" +
          "As long as you provide a value by descibing a process the topic is not important.\n" +
          "## UPLOAD\n" +
          "Upload your video on d.tube using the preset.\n\n" +
          "## GET REWARDED\n" +
          "Get rewarded for the video by a big like of the community!",
      "moreInfoURL": "https://peakd.com/@diyhub",
      "imageURL":
          "https://images.hive.blog/p/5bEGgqZEHBMe6s3wiPgGFTi3naqHERgdwJew6rJYRaB3RR7sSAdZKnpKTieuFqSBhG6vQvFwpLVYoK2oxZAk7Ed6QDpcWhrN?format=match&mode=fit"
    },
    {
      "name": "aliveandthriving",
      "icon": FontAwesomeIcons.heartbeat,
      "tag": "aliveandthriving",
      "subject": "AliveAndThriving: ",
      "description": "",
      "details": "## BASICS\n" +
          "Alive And Thriving is about you sharing your journey to Thrive in life, physical, mental and financial, and to live your life to it's fullest.\n" +
          "## TOPICS\n" +
          "Share your journey to Thrive in life in your video, and how you live it to it's fullest.\n" +
          "## UPLOAD\n" +
          "Upload your video on d.tube using the preset.\n\n" +
          "## GET REWARDED\n" +
          "Get rewarded for the video by a big like of the community!",
      "moreInfoURL": "https://peakd.com/@aliveandthriving",
      "imageURL":
          "https://files.peakd.com/file/peakd-hive/aliveandthriving/RoundPhoto_Dec162021_163720.png?format=match&mode=fit"
    },
    // {
    //   "name": "alive",
    //   "icon": FontAwesomeIcons.handsHelping,
    //   "tag": "alive",
    //   "subject": "subject addition",
    //   "description": "description addition",
    //   "details": "more details text",
    //   "moreURL": "https://d.tube",
    //    "imageURL": ""
    // },
  ];

// REGISTER
  static int usernameMinLength = 12;
}
