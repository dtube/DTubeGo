class APIUrlSchema {
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

// other avalon url schemes
  static String sendTransactionUrl = "/transactWaitConfirm";
  static String avalonConfig = "/config";
  static String accountPriceUrl = "/accountPrice/##USERNAME";

  // search url schemes
  static String searchAccountsUrl =
      "https://search.d.tube/avalon.accounts/_search?q=name:*##SEARCHSTRING*&size=50&sort=balance:desc";
  static String searchPostsUrl =
      "https://search.d.tube/avalon.contents/_search?default_operator=OR&q=json.title:*##SEARCHSTRING*+author:*##SEARCHSTRING*+json.desc:*##SEARCHSTRING*&size=50&sort=ts:desc";
}
