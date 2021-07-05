class AppStrings {
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

  static String notificationFeedUrl = "/notifications/##USERNAME";

  static String sendTransactionUrl = "/transactWaitConfirm";
  static String avalonConfig = "/config";

  static String ipfsVideoUrl = "https://ipfs.d.tube/ipfs/";
  static String siaVideoUrl = "https://siasky.net/";

  static String ipfsUploadUrl = "https://ipfs.d.tube/ipfs/";

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
    'https://avalon.oneloved.tube',
    'https://dtube.fso.ovh'
  ];
}
