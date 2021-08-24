class AppConfig {
  static String myFeedUrlFirst = "/feed/##USERNAME";
  static String myFeedUrlMore = "/feed/##USERNAME/##AUTHOR/##LINK";
  static String newFeedUrlFirst = "/new";
  static String newFeedUrlMore = "/new/##AUTHOR/##LINK";

  static String hotFeedUrlFirst = "/hot";
  static String hotFeedUrlMore = "/hot/##AUTHOR/##LINK";
  static String trendingFeedUrlFirst = "/trending";
  static String trendingFeedUrlMore = "/trending/##AUTHOR/##LINK";

  static String accountDataUrl = "/account/##USERNAME";

  static String postDataUrl = "/content/##AUTHOR/##LINK";

  static String rewardsUrl = "/votes/##REWARDSTATE/##USERNAME/0";

  static String accountFeedUrlFirst = "/blog/##USERNAME";
  static String accountFeedUrlMore = "/blog/##USERNAME/##AUTHORNAME/##LINK";

  static String accountHistoryFeedUrl = "/history/##USERNAME/##FROMBLOC";
  static String accountHistoryFeedUrlFromBlock = "/history/##USERNAME/##BLOCK";

  static String notificationFeedUrl = "/notifications/##USERNAME";

  static String sendTransactionUrl = "/transactWaitConfirm";
  static String avalonConfig = "/config";

  static String ipfsVideoUrl = "https://ipfs.d.tube/ipfs/";
  static String siaVideoUrl = "https://siasky.net/";

  static String ipfsUploadUrl = "https://ipfs.d.tube/ipfs/";

  static String originalDtuberListUrl = "https://dtube.fso.ovh/oc/creators";
  static String originalDtuberCheckUrl =
      "https://dtube.fso.ovh/oc/creator/##USERNAME";

  static List<String> btfsUploadEndpoints = [
    "https://1.btfsu.d.tube",
    "https://2.btfsu.d.tube",
    "https://3.btfsu.d.tube",
    "https://4.btfsu.d.tube"
  ];

  static String ipfsSnapUrl = 'https://snap1.d.tube/ipfs/';
  static String ipfsSnapUploadUrl = 'https://snap1.d.tube';

  static List<String> apiNodes = [
    'https://avalon.tibfox.com',
    'https://avalon.d.tube',
    // 'https://avalon.oneloved.tube',
    'https://dtube.fso.ovh'
  ];
  static int minFreeSpaceRecordVideoInMB = 10;

  static String hiveSignerCallbackUrlScheme = 'dtubetogo';
  static String hiveSignerRedirectUrlHTMLEncoded =
      'dtubetogo%3A%2F%2Foauth2redirect';
  static String hiveSignerAccessTokenUrl =
      'https://hivesigner.com/oauth2/authorize?client_id=dtubemobile&redirect_uri=${hiveSignerRedirectUrlHTMLEncoded}&scope=vote,comment';

  static String hiveSignerBroadcastAddress =
      'https://hivesigner.com/api/broadcast';

  static String signUpUrl = "https://signup.d.tube";

  static String searchAccountsUrl =
      "https://search.d.tube/avalon.accounts/_search?q=name:*##SEARCHSTRING*&size=50&sort=balance:desc";

  static String searchPostsUrl =
      "https://search.d.tube/avalon.contents/_search?default_operator=OR&q=json.title:*##SEARCHSTRING*+author:*##SEARCHSTRING*+json.desc:*##SEARCHSTRING*&size=50&sort=ts:desc";

  static bool faqStartup = false;
}
