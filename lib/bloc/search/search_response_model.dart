import 'package:dtube_go/res/Config/UploadConfigValues.dart';
import 'package:dtube_go/utils/Avalon/growInt.dart';

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

  SearchResults.fromJson(
      Map<String, dynamic> json, int vpGrowth, String currentUser) {
    took = json['took'];
    timedOut = json['timed_out'];
    sShards =
        json['_shards'] != null ? new Shards.fromJson(json['_shards']) : null;
    hits = json['hits'] != null
        ? new Hits.fromJson(json['hits'], vpGrowth, currentUser)
        : null;
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

  List<Hit>? hits;

  Hits({required this.total, required this.hits});

  Hits.fromJson(Map<String, dynamic> json, int vpGrowth, String currentUser) {
    total = json['total']['value'];

    if (json['hits'] != null) {
      hits = [];
      json['hits'].forEach((v) {
        hits!.add(new Hit.fromJson(v, vpGrowth, currentUser));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total']['value'] = this.total;

    if (this.hits != null) {
      data['hits'] = this.hits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Total {
  late int value;

  Total({required this.value});

  Total.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;

    return data;
  }
}

class Hit {
  late String sId;

  Source? sSource;

  Hit({
    required this.sId,
    this.sSource,
  });

  Hit.fromJson(Map<String, dynamic> json, int vpGrowth, String currentUser) {
    sId = json['_id'];

    sSource = json['_source'] != null
        ? new Source.fromJson(json['_source'], vpGrowth, currentUser)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['_id'] = this.sId;

    if (this.sSource != null) {
      data['_source'] = this.sSource!.toJson();
    }

    return data;
  }
}

class Source {
  //users
  int? balance;
  String? createdBy;
  int? createdOn;
  List<String>? followers;
  List<String>? follows;
  String? name;
  String? pubLeader;
  int? vt;
  int? vtTs;
//posts
  String? author;
  String? link;
  double? dist;
  List<String>? tags = [];
  JsonData? jsonstring;
  int? ts;
  List<Votes>? upvotes;
  List<Votes>? downvotes;

  String videoUrl = "";
  String thumbUrl = "";
  String videoSource = "";
  int summaryOfVotes = 0;
  bool? alreadyVoted = false;
  bool? alreadyVotedDirection = false; // false = downvote | true = upvote

  Source(
      {this.balance,
      this.followers,
      this.follows,
      this.name,
      this.pubLeader,
      this.vt,
      this.author,
      this.dist,
      this.link,
      this.tags,
      this.ts});

  Source.fromJson(Map<String, dynamic> json, int vpGrowth, String currentUser) {
    //users
    balance = json['balance'] != null ? json['balance'] : 0;

    followers =
        json['followers'] != null ? json['followers'].cast<String>() : [];
    follows = json['follows'] != null ? json['follows'].cast<String>() : [];

    name = json['name'] != null ? json['name'] : "";

    pubLeader = json['pub_leader'] != null ? json['pub_leader'] : "";
    if (json['vt'] != null) {
      var currentVT = growInt(
          json['vt']['v'], json['vt']['t'], (json['balance'] / vpGrowth), 0, 0);
      vt = currentVT['v'] != null ? currentVT['v'] : 0;
      vtTs = json['vt']['t'];
    }
//posts
    author = json['author'] != null ? json['author'] : "";
    dist = json['dist'] != null ? json['dist'] + 0.0 : 0.0;
    link = json['link'] != null ? json['link'] : "";
    // tags = json['tags'] != null ? json['tags'] : "";
    ts = json['ts'] != null ? json['ts'] : 0;

    jsonstring =
        json['json'] != null ? new JsonData.fromJson(json['json']) : null;
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
            !tags!.contains(_v.tag!.toLowerCase())) {
          tags!.add(_v.tag!.toLowerCase());
        }
      });
    }
    if (jsonstring?.files != null) {
      if (jsonstring?.files?.youtube != null) {
        videoUrl = jsonstring!.files!.youtube!;
        videoSource = "youtube";
      } else if (jsonstring?.files?.ipfs?.vid != null) {
        videoSource = "ipfs";
        String _gateway = UploadConfig.ipfsVideoUrl;
        if (jsonstring?.files?.ipfs!.gw != null) {
          _gateway = jsonstring!.files!.ipfs!.gw! + '/ipfs/';
        }
        if (jsonstring?.files?.ipfs?.vid?.s480 != null) {
          videoUrl = _gateway + jsonstring!.files!.ipfs!.vid!.s480!;
        } else if (jsonstring?.files?.ipfs?.vid?.s240 != null) {
          videoUrl = _gateway + jsonstring!.files!.ipfs!.vid!.s240!;
        } else {
          if (jsonstring!.files!.ipfs!.vid?.src != null) {
            videoUrl = _gateway + jsonstring!.files!.ipfs!.vid!.src!;
          }
        }
      } else if (jsonstring!.files!.sia?.vid?.src != null) {
        videoSource = "sia";
        videoUrl = UploadConfig.siaVideoUrl + jsonstring!.files!.sia!.vid!.src!;
      } else {
        videoUrl = "";
      }
    } else {
      videoUrl = "";
    }
    if (jsonstring?.thumbnailUrl != "" && jsonstring?.thumbnailUrl != null) {
      thumbUrl = jsonstring!.thumbnailUrl!;
    } else {
      if (jsonstring?.files?.youtube != null) {
        thumbUrl = "https://i.ytimg.com/vi/" +
            jsonstring!.files!.youtube! +
            "/mqdefault.jpg";
      } else {
        String _gateway = UploadConfig.ipfsSnapUrl;

        if (jsonstring?.files?.ipfs?.img?.s360 != null) {
          thumbUrl = _gateway + jsonstring!.files!.ipfs!.img!.s360!;
        } else if (jsonstring?.files?.ipfs?.img?.s118 != null) {
          thumbUrl = _gateway + jsonstring!.files!.ipfs!.img!.s118!;
        } else {
          thumbUrl = '';
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //users
    data['balance'] = this.balance != null ? this.balance : 0;
    data['followers'] = this.followers != null ? this.followers : null;
    data['follows'] = this.follows != null ? this.follows : null;

    data['name'] = this.name != null ? this.name : "";

    data['pub_leader'] = this.pubLeader != null ? this.pubLeader : "";
    data['vt'] = this.vt != null ? this.vt : 0;
    data['vtTs'] = this.vtTs != null ? this.vtTs : 0;
//posts
    data['author'] = this.author != null ? this.author : "";
    data['dist'] = this.dist != null ? this.dist : 0.0;
    data['link'] = this.link != null ? this.link : "";
    data['tags'] = this.tags != null ? this.tags : "";
    data['ts'] = this.ts != null ? this.ts : 0;

    if (this.jsonstring != null) {
      data['json'] = this.jsonstring!.toJson();
    }

    return data;
  }
}

class JsonData {
  String? desc;
  String? dur;
  Files? files; // thumbnails makes more or less sense bc of ipfs
  int? hide;
  int? nsfw;
  int? oc;
  String? thumbnailUrl; // thumbnails makes more or less sense bc of ipfs
  String? title;

  List<String>? tags;

  String? tag;

  List<String>? refs;

  JsonData(
      {this.files,
      this.title,
      this.desc,
      this.dur,
      this.tag,
      this.hide,
      this.nsfw,
      this.oc,
      this.refs});

  JsonData.fromJson(Map<String, dynamic> json) {
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
    desc = json['desc'] != null ? json['desc'] : "";
    dur = json['dur'] != null ? json['dur'].toString() : "0";
    if (json['thumbnailUrl'] != null) {
      thumbnailUrl = json['thumbnailUrl'];
    }
    if (json['hide'] is int) {
      hide = json['hide'];
    } else {
      if (json["hide"] == true) {
        hide = 1;
      } else {
        hide = 0;
      }
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

    title = json['title'] != null ? json['title'] : "";
    tags = json['tags'] != null ? json['tags'].cast<String>() : null;
    refs = json['refs'] != null ? json['refs'].cast<String>() : null;
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc != null ? this.desc : "";
    data['dur'] = this.dur != null ? this.dur : "";
    data['hide'] = this.hide != null ? this.hide : 0;
    data['nsfw'] = this.nsfw != null ? this.nsfw : 0;
    data['oc'] = this.oc != null ? this.oc : 0;
    data['title'] = this.title != null ? this.title : "";
    data['tags'] = this.tags != null ? this.tags : "";
    data['tag'] = this.tag;
    if (this.files != null) {
      data['files'] = this.files!.toJson();
    }
    data['refs'] = this.refs;
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
