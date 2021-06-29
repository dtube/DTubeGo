class AppStrings {
  static String myFeedUrl = "/feed/##USERNAME";
  static String newFeedUrl = "/new";
  static String hotFeedUrl = "/hot";
  static String trendingFeedUrl = "/trending";
  static String accountDataUrl = "/account/##USERNAME";

  static String postDataUrl = "/content/##AUTHOR/##LINK";

  static String rewardsUrl = "/votes/##REWARDSTATE/##USERNAME/0";

  static String accountFeedUrl = "/blog/##USERNAME";

  static String notificationFeedUrl = "/notifications/##USERNAME";

  static String sendTransactionUrl = "/transactWaitConfirm";
  static String avalonConfig = "/config";

  static String ipfsVideoUrl = "https://ipfs.d.tube/ipfs/";
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
