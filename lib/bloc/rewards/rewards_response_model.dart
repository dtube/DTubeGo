class ApiResultModel {
  late String status;
  late int totalResults;
  late List<Reward> rewardList;

  ApiResultModel(
      {required this.status,
      required this.totalResults,
      required this.rewardList});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    if (json != null) {
      rewardList = [];
      json.forEach((v) {
        rewardList.add(new Reward.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.rewardList != null) {
      data['FeedItems'] = this.rewardList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reward {
  late String author;
  late String link;
  late double claimable;
  late int vt;
  late int ts;
  late int contentTs;
  int? claimed;

  Reward(
      {required this.author,
      required this.link,
      required this.claimable,
      required this.vt,
      required this.ts,
      required this.contentTs,
      this.claimed});

  Reward.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    link = json['link'];
    claimable = json['claimable'];
    vt = json['vt'];
    ts = json['ts'];
    contentTs = json['contentTs'];
    claimed = json['claimed'] != null ? json['claimed'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['link'] = this.link;
    data['claimable'] = this.claimable;
    data['vt'] = this.vt;
    data['ts'] = this.ts;
    data['contentTs'] = this.contentTs;
    data['claimed'] = this.claimed != null ? this.claimed : null;
    return data;
  }
}
