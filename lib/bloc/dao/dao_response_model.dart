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
      this.threshold});

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
    return data;
  }
}
