class ApiResultModel {
  late String status;
  late int totalResults;
  late List<Leader> leaderboardList;

  ApiResultModel(
      {required this.status,
      required this.totalResults,
      required this.leaderboardList});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    leaderboardList = [];
    if (json.isNotEmpty) {
      json.forEach((v) {
        leaderboardList.add(new Leader.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.leaderboardList.isNotEmpty) {
      data['FeedItems'] = this.leaderboardList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leader {
  String? sId;
  String? name;
  String? pub;
  int? balance;
  Bw? bw;
  Bw? vt;
  Bw? pr;
  int? uv;
  JsonMeta? jsonString;
  List<String>? approves;
  int? nodeAppr;
  String? pubLeader;
  int? voteLock;
  // List<Null>? proposalVotes;
  int? subbed;
  int? subs;
  LeaderStat? leaderStat;

  Leader(
      {this.sId,
      this.name,
      this.pub,
      this.balance,
      this.bw,
      this.vt,
      this.pr,
      this.uv,
      this.jsonString,
      this.approves,
      this.nodeAppr,
      this.pubLeader,
      this.voteLock,
      //this.proposalVotes,
      this.subbed,
      this.subs,
      this.leaderStat});

  Leader.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    pub = json['pub'];
    balance = json['balance'];
    bw = json['bw'] != null ? new Bw.fromJson(json['bw']) : null;
    vt = json['vt'] != null ? new Bw.fromJson(json['vt']) : null;
    pr = json['pr'] != null ? new Bw.fromJson(json['pr']) : null;
    uv = json['uv'];
    jsonString =
        json['json'] != null ? new JsonMeta.fromJson(json['json']) : null;

    if (json['approves'] != null) {
      approves = json['approves'].cast<String>();
    }
    nodeAppr = json['node_appr'];
    pubLeader = json['pub_leader'];
    voteLock = json['voteLock'];
    // if (json['proposalVotes'] != null) {
    //   proposalVotes = <Null>[];
    //   json['proposalVotes'].forEach((v) {
    //     proposalVotes!.add(new Null.fromJson(v));
    //   });
    // }
    subbed = json['subbed'];
    subs = json['subs'];
    leaderStat = json['leaderStat'] != null
        ? new LeaderStat.fromJson(json['leaderStat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['pub'] = this.pub;
    data['balance'] = this.balance;
    if (this.bw != null) {
      data['bw'] = this.bw!.toJson();
    }
    if (this.vt != null) {
      data['vt'] = this.vt!.toJson();
    }
    if (this.pr != null) {
      data['pr'] = this.pr!.toJson();
    }
    data['uv'] = this.uv;
    if (this.jsonString != null) {
      data['jsonString'] = this.jsonString!.toJson();
    }
    data['approves'] = this.approves;
    data['node_appr'] = this.nodeAppr;
    data['pub_leader'] = this.pubLeader;
    data['voteLock'] = this.voteLock;
    // if (this.proposalVotes != null) {
    //   data['proposalVotes'] =
    //       this.proposalVotes!.map((v) => v.toJson()).toList();
    // }
    data['subbed'] = this.subbed;
    data['subs'] = this.subs;
    if (this.leaderStat != null) {
      data['leaderStat'] = this.leaderStat!.toJson();
    }
    return data;
  }
}

class Bw {
  int? v;
  int? t;

  Bw({this.v, this.t});

  Bw.fromJson(Map<String, dynamic> json) {
    v = json['v'];
    t = json['t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v'] = this.v;
    data['t'] = this.t;
    return data;
  }
}

class JsonMeta {
  Node? node;
  Profile? profile;
  Additionals? additionals;

  JsonMeta({this.node, this.profile, this.additionals});

  JsonMeta.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    additionals = json['additionals'] != null
        ? new Additionals.fromJson(json['additionals'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.additionals != null) {
      data['additionals'] = this.additionals!.toJson();
    }
    return data;
  }
}

class Node {
  String? ws;

  Node({this.ws});

  Node.fromJson(Map<String, dynamic> json) {
    ws = json['ws'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ws'] = this.ws;
    return data;
  }
}

class Profile {
  String? avatar;
  String? coverImage;
  String? about;
  String? location;
  String? website;
  String? steem;
  String? hive;
  String? blurt;

  Profile(
      {this.avatar,
      this.coverImage,
      this.about,
      this.location,
      this.website,
      this.steem,
      this.hive,
      this.blurt});

  Profile.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    coverImage = json['cover_image'];
    about = json['about'];
    location = json['location'];
    website = json['website'];
    steem = json['steem'];
    hive = json['hive'];
    blurt = json['blurt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['cover_image'] = this.coverImage;
    data['about'] = this.about;
    data['location'] = this.location;
    data['website'] = this.website;
    data['steem'] = this.steem;
    data['hive'] = this.hive;
    data['blurt'] = this.blurt;
    return data;
  }
}

class Additionals {
  String? displayName;
  String? accountType;

  Additionals({this.displayName, this.accountType});

  Additionals.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['accountType'] = this.accountType;
    return data;
  }
}

class LeaderStat {
  int? last;
  int? missed;
  int? produced;
  int? sinceBlock;
  int? sinceTs;
  int? voters;

  LeaderStat(
      {this.last,
      this.missed,
      this.produced,
      this.sinceBlock,
      this.sinceTs,
      this.voters});

  LeaderStat.fromJson(Map<String, dynamic> json) {
    last = json['last'];
    missed = json['missed'];
    produced = json['produced'];
    sinceBlock = json['sinceBlock'];
    sinceTs = json['sinceTs'];
    voters = json['voters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last'] = this.last;
    data['missed'] = this.missed;
    data['produced'] = this.produced;
    data['sinceBlock'] = this.sinceBlock;
    data['sinceTs'] = this.sinceTs;
    data['voters'] = this.voters;
    return data;
  }
}
