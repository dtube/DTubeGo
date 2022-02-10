import 'package:dtube_go/res/appConfigValues.dart';

class ApiResultModel {
  late String status;
  late int totalResults;
  late List<FeedItem> feed;

  ApiResultModel(
      {required this.status, required this.totalResults, required this.feed});

  ApiResultModel.fromJson(List<dynamic> json, String currentUser) {
//    status = json['status'];

    totalResults = json.length;
    feed = [];
    json.forEach((v) {
      feed.add(new FeedItem.fromJson(v, currentUser));
    });
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;

    data['FeedItems'] = this.feed.map((v) => v.toJson()).toList();

    return data;
  }
}

class FeedItem {
  late String sId;
  late String author;
  late String link;
  // Null pa;
  // Null pp;
  JsonString? jsonString;

  // List<Null> child;
  //List<Votes> votes;
  List<Votes>? upvotes;

  List<Votes>? downvotes;

  late int ts;
  String videoUrl = "";
  String thumbUrl = "";
  String videoSource = "";
  // Tags tags;
  late double dist;
  //List<String> tags = [];
  int summaryOfVotes = 0;
  bool? alreadyVoted = false;
  bool? alreadyVotedDirection = false; // false = downvote | true = upvote
  List<String> tags = [];
  FeedItem(
      {required this.sId,
      required this.author,
      required this.link,
      // this.pa,
      // this.pp,
      this.jsonString,
      // this.child,
      //this.votes,
      this.upvotes,
      this.downvotes,
      required this.ts,
      // this.tags,
      required this.dist,
      required this.tags
      //required this.tags
      });

  FeedItem.fromJson(Map<String, dynamic> json, String currentUser) {
    sId = json['_id'];
    author = json['author'];
    link = json['link'];
    // pa = json['pa'];
    // pp = json['pp'];
    jsonString =
        json['json'] != null ? new JsonString.fromJson(json['json']) : null;
    if (json['votes'] != null) {
      upvotes = [];
      downvotes = [];
      json['votes'].forEach((v) {
        Votes _v = new Votes.fromJson(v);
        summaryOfVotes = summaryOfVotes + _v.vt;
        if (_v.vt > 0) {
          upvotes!.add(_v);
          if (_v.u == currentUser) {
            alreadyVoted = true;
            alreadyVotedDirection = true;
          }
        } else {
          downvotes!.add(_v);
          if (_v.u == currentUser) {
            alreadyVoted = true;
            alreadyVotedDirection = false;
          }
        }
        if (_v.tag != null &&
            _v.tag != "" &&
            !tags.contains(_v.tag!.toLowerCase())) {
          tags.add(_v.tag!.toLowerCase());
        }
      });
    }

    ts = json['ts'];
    // tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
    dist = json['dist'] + 0.0;
    if (jsonString?.files != null) {
      if (jsonString?.files?.youtube != null) {
        videoUrl = jsonString!.files!.youtube!;
        videoSource = "youtube";
      } else if (jsonString?.files?.ipfs?.vid != null) {
        videoSource = "ipfs";
        String _gateway = AppConfig.ipfsVideoUrl;
        if (jsonString?.files?.ipfs!.gw != null) {
          _gateway = jsonString!.files!.ipfs!.gw! + '/ipfs/';
        }
        if (jsonString?.files?.ipfs?.vid?.s480 != null) {
          videoUrl = _gateway + jsonString!.files!.ipfs!.vid!.s480!;
        } else if (jsonString?.files?.ipfs?.vid?.s240 != null) {
          videoUrl = _gateway + jsonString!.files!.ipfs!.vid!.s240!;
        } else {
          if (jsonString!.files!.ipfs!.vid?.src != null) {
            videoUrl = _gateway + jsonString!.files!.ipfs!.vid!.src!;
          }
        }
      } else if (jsonString!.files!.sia?.vid?.src != null) {
        videoSource = "sia";
        videoUrl = AppConfig.siaVideoUrl + jsonString!.files!.sia!.vid!.src!;
      } else {
        videoUrl = "";
      }
    } else {
      videoUrl = "";
    }
    if (jsonString?.thumbnailUrl != "" && jsonString?.thumbnailUrl != null) {
      if (jsonString!.thumbnailUrl!.contains("imgur") &&
          (jsonString!.thumbnailUrl!.contains("jpg") ||
              jsonString!.thumbnailUrl!.contains("png"))) {
        thumbUrl = jsonString!.thumbnailUrl!;
      } else {
        thumbUrl = "";
      }
    } else {
      if (jsonString?.files?.youtube != null) {
        thumbUrl = "https://i.ytimg.com/vi/" +
            jsonString!.files!.youtube! +
            "/mqdefault.jpg";
      } else {
        String _gateway = AppConfig.ipfsSnapUrl;

        if (jsonString?.files?.ipfs?.img?.s360 != null) {
          thumbUrl = _gateway + jsonString!.files!.ipfs!.img!.s360!;
        } else if (jsonString?.files?.ipfs?.img?.s118 != null) {
          thumbUrl = _gateway + jsonString!.files!.ipfs!.img!.s118!;
        } else {
          thumbUrl = '';
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<Votes> allVotes = [];
    data['_id'] = this.sId;
    data['author'] = this.author;
    data['link'] = this.link;

    if (this.jsonString != null) {
      data['json'] = this.jsonString!.toJson();
    }

    if (this.upvotes != null || this.downvotes != null) {
      allVotes = this.upvotes! + this.downvotes!;
      data['votes'] = allVotes.map((v) => v.toJson()).toList();
    }
    data['ts'] = this.ts;

    data['dist'] = this.dist;
    data['videoUrl'] = this.videoUrl;
    data['thumbUrl'] = this.thumbUrl;
    data['videoSource'] = this.videoSource;
    return data;
  }
}

class JsonString {
  Files? files;
  late String title;
  String? desc;
  late String dur;
  late String tag;
  late int hide;
  late int nsfw;
  late int oc;
  String? thumbnailUrl;
  List<String>? refs;

  JsonString(
      {this.files,
      required this.title,
      this.desc,
      required this.dur,
      required this.tag,
      required this.hide,
      required this.nsfw,
      required this.oc,
      this.refs});

  JsonString.fromJson(Map<String, dynamic> json) {
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
    title = json['title'] != null ? json['title'] : "";
    desc = json['desc'] != null ? json['desc'] : "";
    dur = json['dur'].toString();
    tag = json['tag'] != null ? json['tag'] : "";
    if (json['hide'] is int) {
      hide = json['hide'];
    } else {
      if (json["hide"] == true) {
        hide = 1;
      } else {
        hide = 0;
      }
    }
    if (json['thumbnailUrl'] != null) {
      thumbnailUrl = json['thumbnailUrl'];
    }
    if (json['nsfw'] is int) {
      nsfw = json['nsfw'];
    } else {
      if (json["nsfw"] == true) {
        nsfw = 1;
      } else {
        nsfw = 0;
      }
    }
    if (json['oc'] is int) {
      oc = json['oc'];
    } else {
      if (json["oc"] == true) {
        oc = 1;
      } else {
        oc = 0;
      }
    }

    refs = json['refs'] != null ? json['refs'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['files'] = this.files!.toJson();
    }
    data['title'] = this.title;

    data['dur'] = this.dur;
    data['tag'] = this.tag;
    data['hide'] = this.hide;
    data['nsfw'] = this.nsfw;
    data['oc'] = this.oc;
    data['refs'] = this.refs;

    data['desc'] = this.desc != null ? this.desc : "";

    data['tag'] = this.tag;

    if (this.thumbnailUrl != null) {
      data['thumbnailUrl'] = this.thumbnailUrl!;
    }
    return data;
  }
}

class Files {
  String? youtube;
  Ipfs? ipfs;
  Sia? sia;

  Files({this.youtube, this.ipfs, this.sia});

  Files.fromJson(Map<String, dynamic> json) {
    youtube = json['youtube'];
    ipfs = json['ipfs'] != null ? new Ipfs.fromJson(json['ipfs']) : null;
    sia = json['sia'] != null ? new Sia.fromJson(json['sia']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['youtube'] = this.youtube;
    if (this.ipfs != null) {
      data['ipfs'] = this.ipfs!.toJson();
    }
    if (this.sia != null) {
      data['sia'] = this.sia!.toJson();
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

class Sia {
  SiaVid? vid;

  Sia({this.vid});

  Sia.fromJson(Map<String, dynamic> json) {
    vid = json['vid'] != null ? new SiaVid.fromJson(json['vid']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vid != null) {
      data['vid'] = this.vid!.toJson();
    }

    return data;
  }
}

class SiaVid {
  String? src;

  SiaVid({this.src});

  SiaVid.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['src'] = this.src;
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
