class ApiResultModelAvalonConfig {
  late String status;

  late AvalonConfig conf;

  ApiResultModelAvalonConfig({required this.status, required this.conf});

  ApiResultModelAvalonConfig.fromJson(Map<String, dynamic> json) {
//    status = json['status'];

    conf = new AvalonConfig.fromJson(json);
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data = this.conf.toJson();

    return data;
  }
}

class AvalonConfig {
  late int accountPriceBase;
  late int accountPriceCharMult;
  late int accountPriceChars;
  late int accountPriceMin;
  late int accountMaxLength;
  late int accountMinLength;
  late String allowedUsernameChars;
  late String allowedUsernameCharsOnlyMiddle;
  late bool allowRevotes;
  late String b58Alphabet;
  late int block0ts;
  late int blockTime;
  late int bwGrowth;
  late int bwMax;
  late int consensusRounds;
  late double ecoBaseRent;
  late int ecoBlocks;
  late int ecoClaimPrecision;
  late int ecoClaimTime;
  late bool ecoPunishAuthor;
  late double ecoPunishPercent;
  late int ecoRentStartTime;
  late int ecoRentEndTime;
  late int ecoRentPrecision;
  late double ecoStartRent;
  late int followsMax;
  late bool hotfix1;
  late int jsonMaxBytes;
  late int keyIdMaxLength;
  late int leaderReward;
  late int leaderRewardVT;
  late int leaders;
  late int leaderShufflePrecision;
  late int leaderMaxVotes;
  late int masterBalance;
  late int masterFee;
  late String masterName;
  late bool masterPaysForUsernames;
  late String masterPub;
  late String masterPubLeader;
  late int maxDrift;
  late int maxTxPerBlock;
  late int memoMaxLength;
  late int notifPurge;
  late int notifPurgeAfter;
  late int notifMaxMentions;
  late String originHash;
  late int randomBytesLength;
  late int rewardPoolMin;
  late int rewardPoolMult;
  late double rewardPoolMaxShare;
  late int rewardPoolUsers;
  late int tagMaxLength;
  late int tagMaxPerContent;
  late int tippedVotePrecision;
  //late bool tmpForceTs;
  late int txExpirationTime;
  late TxLimits txLimits;
  late int vtGrowth;
  late int vtPerBurn;

  AvalonConfig(
      {required this.accountPriceBase,
      required this.accountPriceCharMult,
      required this.accountPriceChars,
      required this.accountPriceMin,
      required this.accountMaxLength,
      required this.accountMinLength,
      required this.allowedUsernameChars,
      required this.allowedUsernameCharsOnlyMiddle,
      required this.allowRevotes,
      required this.b58Alphabet,
      required this.block0ts,
      required this.blockTime,
      required this.bwGrowth,
      required this.bwMax,
      required this.consensusRounds,
      required this.ecoBaseRent,
      required this.ecoBlocks,
      required this.ecoClaimPrecision,
      required this.ecoClaimTime,
      required this.ecoPunishAuthor,
      required this.ecoPunishPercent,
      required this.ecoRentStartTime,
      required this.ecoRentEndTime,
      required this.ecoRentPrecision,
      required this.ecoStartRent,
      required this.followsMax,
      required this.hotfix1,
      required this.jsonMaxBytes,
      required this.keyIdMaxLength,
      required this.leaderReward,
      required this.leaderRewardVT,
      required this.leaders,
      required this.leaderShufflePrecision,
      required this.leaderMaxVotes,
      required this.masterBalance,
      required this.masterFee,
      required this.masterName,
      required this.masterPaysForUsernames,
      required this.masterPub,
      required this.masterPubLeader,
      required this.maxDrift,
      required this.maxTxPerBlock,
      required this.memoMaxLength,
      required this.notifPurge,
      required this.notifPurgeAfter,
      required this.notifMaxMentions,
      required this.originHash,
      required this.randomBytesLength,
      required this.rewardPoolMin,
      required this.rewardPoolMult,
      required this.rewardPoolMaxShare,
      required this.rewardPoolUsers,
      required this.tagMaxLength,
      required this.tagMaxPerContent,
      required this.tippedVotePrecision,
      //required this.tmpForceTs,
      required this.txExpirationTime,
      required this.txLimits,
      required this.vtGrowth,
      required this.vtPerBurn});

  AvalonConfig.fromJson(Map<String, dynamic> json) {
    accountPriceBase = json['accountPriceBase'];
    accountPriceCharMult = json['accountPriceCharMult'];
    accountPriceChars = json['accountPriceChars'];
    accountPriceMin = json['accountPriceMin'];
    accountMaxLength = json['accountMaxLength'];
    accountMinLength = json['accountMinLength'];
    allowedUsernameChars = json['allowedUsernameChars'];
    allowedUsernameCharsOnlyMiddle = json['allowedUsernameCharsOnlyMiddle'];
    allowRevotes = json['allowRevotes'];
    b58Alphabet = json['b58Alphabet'];
    block0ts = json['block0ts'];
    blockTime = json['blockTime'];
    bwGrowth = json['bwGrowth'];
    bwMax = json['bwMax'];
    consensusRounds = json['consensusRounds'];
    ecoBaseRent = json['ecoBaseRent'];
    ecoBlocks = json['ecoBlocks'];
    ecoClaimPrecision = json['ecoClaimPrecision'];
    ecoClaimTime = json['ecoClaimTime'];
    ecoPunishAuthor = json['ecoPunishAuthor'];
    ecoPunishPercent = json['ecoPunishPercent'];
    ecoRentStartTime = json['ecoRentStartTime'];
    ecoRentEndTime = json['ecoRentEndTime'];
    ecoRentPrecision = json['ecoRentPrecision'];
    ecoStartRent = json['ecoStartRent'];
    followsMax = json['followsMax'];
    hotfix1 = json['hotfix1'];
    jsonMaxBytes = json['jsonMaxBytes'];
    keyIdMaxLength = json['keyIdMaxLength'];
    leaderReward = json['leaderReward'];
    leaderRewardVT = json['leaderRewardVT'];
    leaders = json['leaders'];
    leaderShufflePrecision = json['leaderShufflePrecision'];
    leaderMaxVotes = json['leaderMaxVotes'];
    masterBalance = json['masterBalance'];
    masterFee = json['masterFee'];
    masterName = json['masterName'];
    masterPaysForUsernames = json['masterPaysForUsernames'];
    masterPub = json['masterPub'];
    masterPubLeader = json['masterPubLeader'];
    maxDrift = json['maxDrift'];
    maxTxPerBlock = json['maxTxPerBlock'];
    memoMaxLength = json['memoMaxLength'];
    notifPurge = json['notifPurge'];
    notifPurgeAfter = json['notifPurgeAfter'];
    notifMaxMentions = json['notifMaxMentions'];
    originHash = json['originHash'];
    randomBytesLength = json['randomBytesLength'];
    rewardPoolMin = json['rewardPoolMin'];
    rewardPoolMult = json['rewardPoolMult'];
    rewardPoolMaxShare = json['rewardPoolMaxShare'];
    rewardPoolUsers = json['rewardPoolUsers'];
    tagMaxLength = json['tagMaxLength'];
    tagMaxPerContent = json['tagMaxPerContent'];
    tippedVotePrecision = json['tippedVotePrecision'];
    //tmpForceTs = json['tmpForceTs'];
    txExpirationTime = json['txExpirationTime'];
    txLimits = TxLimits.fromJson(json['txLimits']);
    vtGrowth = json['vtGrowth'];
    vtPerBurn = json['vtPerBurn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountPriceBase'] = this.accountPriceBase;
    data['accountPriceCharMult'] = this.accountPriceCharMult;
    data['accountPriceChars'] = this.accountPriceChars;
    data['accountPriceMin'] = this.accountPriceMin;
    data['accountMaxLength'] = this.accountMaxLength;
    data['accountMinLength'] = this.accountMinLength;
    data['allowedUsernameChars'] = this.allowedUsernameChars;
    data['allowedUsernameCharsOnlyMiddle'] =
        this.allowedUsernameCharsOnlyMiddle;
    data['allowRevotes'] = this.allowRevotes;
    data['b58Alphabet'] = this.b58Alphabet;
    data['block0ts'] = this.block0ts;
    data['blockTime'] = this.blockTime;
    data['bwGrowth'] = this.bwGrowth;
    data['bwMax'] = this.bwMax;
    data['consensusRounds'] = this.consensusRounds;
    data['ecoBaseRent'] = this.ecoBaseRent;
    data['ecoBlocks'] = this.ecoBlocks;
    data['ecoClaimPrecision'] = this.ecoClaimPrecision;
    data['ecoClaimTime'] = this.ecoClaimTime;
    data['ecoPunishAuthor'] = this.ecoPunishAuthor;
    data['ecoPunishPercent'] = this.ecoPunishPercent;
    data['ecoRentStartTime'] = this.ecoRentStartTime;
    data['ecoRentEndTime'] = this.ecoRentEndTime;
    data['ecoRentPrecision'] = this.ecoRentPrecision;
    data['ecoStartRent'] = this.ecoStartRent;
    data['followsMax'] = this.followsMax;
    data['hotfix1'] = this.hotfix1;
    data['jsonMaxBytes'] = this.jsonMaxBytes;
    data['keyIdMaxLength'] = this.keyIdMaxLength;
    data['leaderReward'] = this.leaderReward;
    data['leaderRewardVT'] = this.leaderRewardVT;
    data['leaders'] = this.leaders;
    data['leaderShufflePrecision'] = this.leaderShufflePrecision;
    data['leaderMaxVotes'] = this.leaderMaxVotes;
    data['masterBalance'] = this.masterBalance;
    data['masterFee'] = this.masterFee;
    data['masterName'] = this.masterName;
    data['masterPaysForUsernames'] = this.masterPaysForUsernames;
    data['masterPub'] = this.masterPub;
    data['masterPubLeader'] = this.masterPubLeader;
    data['maxDrift'] = this.maxDrift;
    data['maxTxPerBlock'] = this.maxTxPerBlock;
    data['memoMaxLength'] = this.memoMaxLength;
    data['notifPurge'] = this.notifPurge;
    data['notifPurgeAfter'] = this.notifPurgeAfter;
    data['notifMaxMentions'] = this.notifMaxMentions;
    data['originHash'] = this.originHash;
    data['randomBytesLength'] = this.randomBytesLength;
    data['rewardPoolMin'] = this.rewardPoolMin;
    data['rewardPoolMult'] = this.rewardPoolMult;
    data['rewardPoolMaxShare'] = this.rewardPoolMaxShare;
    data['rewardPoolUsers'] = this.rewardPoolUsers;
    data['tagMaxLength'] = this.tagMaxLength;
    data['tagMaxPerContent'] = this.tagMaxPerContent;
    data['tippedVotePrecision'] = this.tippedVotePrecision;
    //data['tmpForceTs'] = this.tmpForceTs;
    data['txExpirationTime'] = this.txExpirationTime;
    data['txLimits'] = this.txLimits.toJson();

    data['vtGrowth'] = this.vtGrowth;
    data['vtPerBurn'] = this.vtPerBurn;
    return data;
  }
}

class TxLimits {
  late int i14;
  late int i15;
  late int i19;

  TxLimits({required this.i14, required this.i15, required this.i19});

  TxLimits.fromJson(Map<String, dynamic> json) {
    i14 = json['14'];
    i15 = json['15'];
    i19 = json['19'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['14'] = this.i14;
    data['15'] = this.i15;
    data['19'] = this.i19;
    return data;
  }
}
