import 'package:dtube_go/utils/growInt.dart';

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

  List<Hit>? hits;

  Hits({required this.total, required this.hits});

  Hits.fromJson(Map<String, dynamic> json, int vpGrowth) {
    total = json['total']['value'];

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

  Hit.fromJson(Map<String, dynamic> json, int vpGrowth) {
    sId = json['_id'];

    sSource = json['_source'] != null
        ? new Source.fromJson(json['_source'], vpGrowth)
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
  String? tags;
  JsonData? jsonstring;
  int? ts;

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

  Source.fromJson(Map<String, dynamic> json, int vpGrowth) {
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
    tags = json['tags'] != null ? json['tags'] : "";
    ts = json['ts'] != null ? json['ts'] : 0;

    jsonstring =
        json['json'] != null ? new JsonData.fromJson(json['json']) : null;
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
  //Files files; // thumbnails makes more or less sense bc of ipfs
  int? hide;
  int? nsfw;
  int? oc;
  //String thumbnailUrl; // thumbnails makes more or less sense bc of ipfs
  String? title;

  List<String>? tags;

  JsonData(
      {this.desc,
      this.dur,
      this.hide,
      this.nsfw,
      this.oc,
      this.title,
      this.tags});

  JsonData.fromJson(Map<String, dynamic> json) {
    desc = json['desc'] != null ? json['desc'] : "";
    dur = json['dur'] != null ? json['dur'].toString() : "0";
    hide = json['hide'] != null ? json['hide'] : 0;
    nsfw = json['nsfw'] != null ? json['nsfw'] : 0;
    oc = json['oc'] != null ? json['oc'] : 0;
    title = json['title'] != null ? json['title'] : "";
    tags = json['tags'] != null ? json['tags'].cast<String>() : null;
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
    return data;
  }
}
