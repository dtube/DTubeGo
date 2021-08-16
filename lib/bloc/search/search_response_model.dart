import 'package:dtube_togo/utils/growInt.dart';

class SearchResults {
  late int took;
  late bool timedOut;
  Shards? sShards;
  Hits? hits;

  SearchResults(
      {required this.took,
      required this.timedOut,
      required this.sShards,
      required this.hits});

  SearchResults.fromJson(Map<String, dynamic> json, int vpGrowth) {
    took = json['took'];
    timedOut = json['timed_out'];
    sShards =
        json['_shards'] != null ? new Shards.fromJson(json['_shards']) : null;
    hits =
        json['hits'] != null ? new Hits.fromJson(json['hits'], vpGrowth) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['took'] = this.took;
    data['timed_out'] = this.timedOut;
    if (this.sShards != null) {
      data['_shards'] = this.sShards!.toJson();
    }
    if (this.hits != null) {
      data['hits'] = this.hits!.toJson();
    }
    return data;
  }
}

class Shards {
  late int total;
  late int successful;
  late int skipped;
  late int failed;

  Shards(
      {required this.total,
      required this.successful,
      required this.skipped,
      required this.failed});

  Shards.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    successful = json['successful'];
    skipped = json['skipped'];
    failed = json['failed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['successful'] = this.successful;
    data['skipped'] = this.skipped;
    data['failed'] = this.failed;
    return data;
  }
}

class Hits {
  late int total;
  // Null maxScore;
  List<Hit>? hits;

  Hits(
      {required this.total,
      //this.maxScore,
      required this.hits});

  Hits.fromJson(Map<String, dynamic> json, int vpGrowth) {
    total = json['total']['value'];
    //maxScore = json['max_score'];
    if (json['hits'] != null) {
      hits = [];
      json['hits'].forEach((v) {
        hits!.add(new Hit.fromJson(v, vpGrowth));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total']['value'] = this.total;

    //data['max_score'] = this.maxScore;
    if (this.hits != null) {
      data['hits'] = this.hits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Total {
  late int value;
  //String relation;

  Total({required this.value
      //, this.relation
      });

  Total.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    //relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    //data['relation'] = this.relation;
    return data;
  }
}

class Hit {
  //late String sIndex;
  // String sType;
  late String sId;
  // Null nScore;
  Source? sSource;
  //List<int> sort;

  Hit({
    //required this.sIndex,
    // this.sType,
    required this.sId,
    // this.nScore,
    this.sSource,
    //this.sort
  });

  Hit.fromJson(Map<String, dynamic> json, int vpGrowth) {
    //sIndex = json['_index'];
    // sType = json['_type'];
    sId = json['_id'];
    // nScore = json['_score'];
    sSource = json['_source'] != null
        ? new Source.fromJson(json['_source'], vpGrowth)
        : null;
    // sort = json['sort'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['_index'] = this.sIndex;
    // data['_type'] = this.sType;
    data['_id'] = this.sId;
    // data['_score'] = this.nScore;
    if (this.sSource != null) {
      data['_source'] = this.sSource!.toJson();
    }
    //data['sort'] = this.sort;
    return data;
  }
}

class Source {
  // List<String> approves;
  late int balance;
  // int baseBwGrowth;
  // Bw bw;
  late String createdBy;
  late int createdOn;
  List<String>? followers;
  List<String>? follows;
  // Json json;
  // List<Keys> keys;
  late String name;
  // int nodeAppr;
  // String pub;
  String? pubLeader;
  late int vt;
  late int vtTs;
  // Bw pr;
  // int uv;

  Source({
    // this.approves,
    required this.balance,
    // this.baseBwGrowth,
    // this.bw,
    // required this.createdBy,
    // required this.createdOn,
    this.followers,
    this.follows,
    // this.json,
    // this.keys,
    required this.name,
    // this.nodeAppr,
    // this.pub,
    this.pubLeader,
    required this.vt,
    //this.pr,
    //this.uv
  });

  Source.fromJson(Map<String, dynamic> json, int vpGrowth) {
    // approves = json['approves'].cast<String>();
    balance = json['balance'];
    // baseBwGrowth = json['baseBwGrowth'];
    // bw = json['bw'] != null ? new Bw.fromJson(json['bw']) : null;
    // createdBy = json['created']['by'];
    // createdOn = json['created']['ts'];
    followers = json['followers'].cast<String>();
    follows = json['follows'].cast<String>();
    // json = json['json'] != null ? new Json.fromJson(json['json']) : null;
    // if (json['keys'] != null) {
    //   keys = new List<Keys>();
    //   json['keys'].forEach((v) {
    //     keys.add(new Keys.fromJson(v));
    //   });
    // }
    name = json['name'];
    // nodeAppr = json['node_appr'];
    // pub = json['pub'];
    pubLeader = json['pub_leader'];
    var currentVT = growInt(
        json['vt']['v'], json['vt']['t'], (json['balance'] / vpGrowth), 0, 0);
    vt = currentVT['v']!;
    vtTs = json['vt']['t'];
    // pr = json['pr'] != null ? new Bw.fromJson(json['pr']) : null;
    // uv = json['uv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['approves'] = this.approves;
    data['balance'] = this.balance;
    //data['baseBwGrowth'] = this.baseBwGrowth;
    // if (this.bw != null) {
    //   data['bw'] = this.bw.toJson();
    // }
    // data['createdBy'] = this.createdBy;
    // data['createdOn'] = this.createdOn;

    data['followers'] = this.followers;
    data['follows'] = this.follows;
    // if (this.json != null) {
    //   data['json'] = this.json.toJson();
    // }
    // if (this.keys != null) {
    //   data['keys'] = this.keys.map((v) => v.toJson()).toList();
    // }
    data['name'] = this.name;
    //data['node_appr'] = this.nodeAppr;
    //data['pub'] = this.pub;

    data['pub_leader'] = this.pubLeader != null ? this.pubLeader : null;
    data['vt'] = this.vt;
    data['vtTs'] = this.vtTs;

    // if (this.pr != null) {
    //   data['pr'] = this.pr.toJson();
    // }
    // data['uv'] = this.uv;
    return data;
  }
}

// class Bw {
//   late int t;
//   late int v;

//   Bw({required this.t, required this.v});

//   Bw.fromJson(Map<String, dynamic> json) {
//     t = json['t'];
//     v = json['v'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['t'] = this.t;
//     data['v'] = this.v;
//     return data;
//   }
// }

// class Created {
//   late String by;
//   late int ts;

//   Created({required this.by, required this.ts});

//   Created.fromJson(Map<String, dynamic> json) {
//     by = json['by'];
//     ts = json['ts'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['by'] = this.by;
//     data['ts'] = this.ts;
//     return data;
//   }
// }

// class Json {
//   Profile profile;
//   Node node;

//   Json({this.profile, this.node});

//   Json.fromJson(Map<String, dynamic> json) {
//     profile =
//         json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
//     node = json['node'] != null ? new Node.fromJson(json['node']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.profile != null) {
//       data['profile'] = this.profile.toJson();
//     }
//     if (this.node != null) {
//       data['node'] = this.node.toJson();
//     }
//     return data;
//   }
// }

// class Profile {
//   String about;
//   String avatar;
//   String coverImage;
//   String hive;
//   String location;
//   String steem;
//   String website;

//   Profile(
//       {this.about,
//       this.avatar,
//       this.coverImage,
//       this.hive,
//       this.location,
//       this.steem,
//       this.website});

//   Profile.fromJson(Map<String, dynamic> json) {
//     about = json['about'];
//     avatar = json['avatar'];
//     coverImage = json['cover_image'];
//     hive = json['hive'];
//     location = json['location'];
//     steem = json['steem'];
//     website = json['website'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['about'] = this.about;
//     data['avatar'] = this.avatar;
//     data['cover_image'] = this.coverImage;
//     data['hive'] = this.hive;
//     data['location'] = this.location;
//     data['steem'] = this.steem;
//     data['website'] = this.website;
//     return data;
//   }
// }

// class Node {
//   String ws;

//   Node({this.ws});

//   Node.fromJson(Map<String, dynamic> json) {
//     ws = json['ws'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ws'] = this.ws;
//     return data;
//   }
// }

// class Keys {
//   String id;
//   String pub;
//   List<int> types;

//   Keys({this.id, this.pub, this.types});

//   Keys.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     pub = json['pub'];
//     types = json['types'].cast<int>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['pub'] = this.pub;
//     data['types'] = this.types;
//     return data;
//   }

