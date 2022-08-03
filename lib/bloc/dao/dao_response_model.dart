class ApiResultModel {
  late String status;
  late int totalResults;
  late List<DAOItem> daoList;

  ApiResultModel(
      {required this.status,
      required this.totalResults,
      required this.daoList});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    daoList = [];
    if (json.isNotEmpty) {
      json.forEach((v) {
        daoList.add(new DAOItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.daoList.isNotEmpty) {
      data['FeedItems'] = this.daoList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DAOItem {
  int? iId;
  int? type;
  String? title;
  String? description;
  String? url;
  String? creator;
  String? receiver;
  int? requested;
  int? fee;
  int? raised;
  int? approvals;
  int? disapprovals;
  int? status;
  int? state;
  int? ts;
  int? votingEnds;
  int? fundingEnds;
  int? deadline;
  List<String>? leaderSnapshot;
  int? threshold;
  List<DaoVote>? votes;
  List<DaoContributor>? contrib;
  String? voters;

  DAOItem(
      {this.iId,
      this.type,
      this.title,
      this.description,
      this.url,
      this.creator,
      this.receiver,
      this.requested,
      this.fee,
      this.raised,
      this.approvals,
      this.disapprovals,
      this.status,
      this.state,
      this.ts,
      this.votingEnds,
      this.fundingEnds,
      this.deadline,
      this.leaderSnapshot,
      this.threshold,
      this.votes,
      this.contrib,
      this.voters});

  DAOItem.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    type = json['type'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    creator = json['creator'];
    receiver = json['receiver'];
    requested = json['requested'];
    fee = json['fee'];
    raised = json['raised'];
    approvals = json['approvals'];
    disapprovals = json['disapprovals'];
    status = json['status'];
    state = json['state'];
    ts = json['ts'];
    votingEnds = json['votingEnds'];
    fundingEnds = json['fundingEnds'];
    deadline = json['deadline'];
    threshold = json['threshold'];
    if (json['contrib'] != null) {
      contrib =
          ApiContributorResultModel.fromMap(json['contrib']).daoContributorList;
    } else
      contrib = [];
    leaderSnapshot = json['leaderSnapshot'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['creator'] = this.creator;
    data['receiver'] = this.receiver;
    data['requested'] = this.requested;
    data['fee'] = this.fee;
    data['raised'] = this.raised;
    data['approvals'] = this.approvals;
    data['disapprovals'] = this.disapprovals;
    data['status'] = this.status;
    data['state'] = this.state;
    data['ts'] = this.ts;
    data['votingEnds'] = this.votingEnds;
    data['fundingEnds'] = this.fundingEnds;
    data['deadline'] = this.deadline;
    data['threshold'] = this.threshold;
    data['leaderSnapshot'] = this.leaderSnapshot;
    data['votes'] = this.votes;
    data['voters'] = this.voters;
    data['contrib'] = this.contrib;
    return data;
  }
}

class ApiVoteResultModel {
  late String status;
  late int totalResults;
  late List<DaoVote> daoVoteList;

  ApiVoteResultModel(
      {required this.status,
      required this.totalResults,
      required this.daoVoteList});

  ApiVoteResultModel.fromJson(List<dynamic> json) {
    totalResults = json.length;
    daoVoteList = [];
    if (json.isNotEmpty) {
      json.forEach((v) {
        daoVoteList.add(new DaoVote.fromJson(v));
      });
    }
    print(daoVoteList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.daoVoteList.isNotEmpty) {
      data['FeedItems'] = this.daoVoteList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DaoVote {
  String? sId;
  int? proposalId;
  String? voter;
  int? amount;
  int? bonus;
  bool? veto;
  int? end;

  DaoVote(
      {this.sId,
      this.proposalId,
      this.voter,
      this.amount,
      this.bonus,
      this.veto,
      this.end});

  DaoVote.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    proposalId = json['proposal_id'];
    voter = json['voter'];
    amount = json['amount'];
    bonus = json['bonus'];
    veto = json['veto'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['proposal_id'] = this.proposalId;
    data['voter'] = this.voter;
    data['amount'] = this.amount;
    data['bonus'] = this.bonus;
    data['veto'] = this.veto;
    data['end'] = this.end;
    return data;
  }
}

class ApiContributorResultModel {
  late String status;
  late int totalResults;
  late List<DaoContributor> daoContributorList;

  ApiContributorResultModel(
      {required this.status,
      required this.totalResults,
      required this.daoContributorList});

  ApiContributorResultModel.fromMap(Map<String, dynamic> map) {
    totalResults = map.length;
    daoContributorList = [];
    if (map.isNotEmpty) {
      map.forEach((key, value) {
        daoContributorList.add(new DaoContributor.fromArguments(key, value));
      });
    }
    print(daoContributorList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.daoContributorList.isNotEmpty) {
      data['FeedItems'] =
          this.daoContributorList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DaoContributor {
  String? contribName;
  int? contribAmount;

  DaoContributor({
    this.contribName,
    this.contribAmount,
  });

  DaoContributor.fromArguments(String key, int value) {
    contribName = key;
    contribAmount = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contribName'] = this.contribName;
    data['contribAmount'] = this.contribAmount;
    return data;
  }
}
