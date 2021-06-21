class ApiResultModel {
  late String status;
  late int totalResults;
  late List<FeedItem> feed;

  ApiResultModel(
      {required this.status, required this.totalResults, required this.feed});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    if (json != null) {
      feed = [];
      json.forEach((v) {
        feed.add(new FeedItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.feed != null) {
      data['FeedItems'] = this.feed.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedItem {
  late String sId;
  late String author;
  late String link;
  // Null pa;
  // Null pp;
  Json_String? json_string;

  // List<Null> child;
  //List<Votes> votes;
  List<Votes>? upvotes;
  List<Votes>? downvotes;
  late int ts;
  // Tags tags;
  late double dist;

  FeedItem(
      {required this.sId,
      required this.author,
      required this.link,
      // this.pa,
      // this.pp,
      this.json_string,
      // this.child,
      //this.votes,
      this.upvotes,
      this.downvotes,
      required this.ts,
      // this.tags,
      required this.dist});

  FeedItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    author = json['author'];
    link = json['link'];
    // pa = json['pa'];
    // pp = json['pp'];
    json_string =
        json['json'] != null ? new Json_String.fromJson(json['json']) : null;
    // if (json['child'] != null) {
    //   child = new List<Null>();
    //   json['child'].forEach((v) {
    //     child.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['votes'] != null) {
    //   votes = new List<Votes>();
    //   json['votes'].forEach((v) {
    //     votes.add(new Votes.fromJson(v));
    //   });
    // }

    if (json['votes'] != null) {
      upvotes = [];
      downvotes = [];
      json['votes'].forEach((v) {
        Votes _v = new Votes.fromJson(v);
        if (_v.vt > 0.0) {
          upvotes!.add(_v);
        } else {
          downvotes!.add(_v);
        }
      });
    }

    ts = json['ts'];
    // tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
    dist = json['dist'] + 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<Votes> allVotes = [];
    data['_id'] = this.sId;
    data['author'] = this.author;
    data['link'] = this.link;
    // data['pa'] = this.pa;
    // data['pp'] = this.pp;
    if (this.json_string != null) {
      data['json'] = this.json_string!.toJson();
    }
    // if (this.child != null) {
    //   data['child'] = this.child.map((v) => v.toJson()).toList();
    // }
    // this.upvotes.map((v) => v.toJson()).toList();
    if (this.upvotes != null || this.downvotes != null) {
      allVotes = this.upvotes! + this.downvotes!;
      data['votes'] = allVotes.map((v) => v.toJson()).toList();
    }
    data['ts'] = this.ts;
    // if (this.tags != null) {
    //   data['tags'] = this.tags.toJson();
    // }
    data['dist'] = this.dist;

    return data;
  }
}

class Json_String {
  Files? files;
  late String title;
  String? desc;
  late String dur;
  late String tag;
  late int hide;
  late int nsfw;
  late int oc;
  List<String>? refs;

  Json_String(
      {this.files,
      required this.title,
      this.desc,
      required this.dur,
      required this.tag,
      required this.hide,
      required this.nsfw,
      required this.oc,
      this.refs});

  Json_String.fromJson(Map<String, dynamic> json) {
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
    title = json['title'];
    desc = json['desc'];
    dur = json['dur'].toString();
    tag = json['tag'];
    hide = json['hide'];
    nsfw = json['nsfw'];
    oc = json['oc'];
    refs = json['refs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['files'] = this.files!.toJson();
    }
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['dur'] = this.dur;
    data['tag'] = this.tag;
    data['hide'] = this.hide;
    data['nsfw'] = this.nsfw;
    data['oc'] = this.oc;
    data['refs'] = this.refs;
    return data;
  }
}

class Files {
  String? youtube;
  Ipfs? ipfs;

  Files({this.youtube, this.ipfs});

  Files.fromJson(Map<String, dynamic> json) {
    youtube = json['youtube'];
    ipfs = json['ipfs'] != null ? new Ipfs.fromJson(json['ipfs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['youtube'] = this.youtube;
    if (this.ipfs != null) {
      data['ipfs'] = this.ipfs!.toJson();
    }
    return data;
  }
}

class Ipfs {
  Vid? vid;
  Img? img;
  String? gw;

  Ipfs({this.vid, this.img, required this.gw});

  Ipfs.fromJson(Map<String, dynamic> json) {
    vid = json['vid'] != null ? new Vid.fromJson(json['vid']) : null;
    img = json['img'] != null ? new Img.fromJson(json['img']) : null;
    gw = json['gw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vid != null) {
      data['vid'] = this.vid!.toJson();
    }
    if (this.img != null) {
      data['img'] = this.img!.toJson();
    }
    data['gw'] = this.gw;
    return data;
  }
}

class Vid {
  String? s240;
  String? s480;
  String? src;

  Vid({this.s240, this.s480, this.src});

  Vid.fromJson(Map<String, dynamic> json) {
    s240 = json['240'];
    s480 = json['480'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['240'] = this.s240;
    data['480'] = this.s480;
    data['src'] = this.src;
    return data;
  }
}

class Img {
  String? s118;
  String? s360;
  String? spr;

  Img({this.s118, this.s360, this.spr});

  Img.fromJson(Map<String, dynamic> json) {
    s118 = json['118'];
    s360 = json['360'];
    spr = json['spr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['118'] = this.s118;
    data['360'] = this.s360;
    data['spr'] = this.spr;
    return data;
  }
}

class Votes {
  late String u;
  late int ts;
  late int vt;
  String? tag;
  double? gross;
  double? claimable;

  Votes(
      {required this.u,
      required this.ts,
      required this.vt,
      this.tag,
      this.gross,
      this.claimable});

  Votes.fromJson(Map<String, dynamic> json) {
    u = json['u'];
    ts = json['ts'];
    vt = json['vt'];
    tag = json['tag'];
    gross = json['gross'] != null ? json['gross'] + 0.0 : 0.0;
    claimable = json['claimable'] != null ? json['claimable'] + 0.0 : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['u'] = this.u;
    data['ts'] = this.ts;
    data['vt'] = this.vt;
    data['tag'] = this.tag;
    data['gross'] = this.gross;
    data['claimable'] = this.claimable;
    return data;
  }
}

// class Tags {
//   int bitcoin;

//   Tags({this.bitcoin});

//   Tags.fromJson(Map<String, dynamic> json) {
//     bitcoin = json['bitcoin'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['bitcoin'] = this.bitcoin;
//     return data;
//   }
// }
