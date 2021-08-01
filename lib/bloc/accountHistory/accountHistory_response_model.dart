class ApiResultModel {
  late String status;
  late int totalResults;
  late List<AvalonAccountHistoryItem> accountHistorys;

  ApiResultModel(
      {required this.status,
      required this.totalResults,
      required this.accountHistorys});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    accountHistorys = [];
    json.forEach((v) {
      accountHistorys.add(new AvalonAccountHistoryItem.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    data['posts'] = this.accountHistorys.map((v) => v.toJson()).toList();

    return data;
  }
}

class AvalonAccountHistoryItem {
  late int iId;
  late String phash;
  late int timestamp;
  late List<Txs> txs;
  late String miner;
  late double dist;
  late String hash;
  late String signature;

  AvalonAccountHistoryItem(
      {required this.iId,
      required this.phash,
      required this.timestamp,
      required this.txs,
      required this.miner,
      required this.dist,
      required this.hash,
      required this.signature});

  AvalonAccountHistoryItem.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    phash = json['phash'];
    timestamp = json['timestamp'];
    if (json['txs'] != null) {
      txs = [];
      json['txs'].forEach((v) {
        txs.add(new Txs.fromJson(v));
      });
    }
    miner = json['miner'];
    dist = json['dist'] + 0.0;
    hash = json['hash'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['phash'] = this.phash;
    data['timestamp'] = this.timestamp;
    if (this.txs != null) {
      data['txs'] = this.txs.map((txItem) => txItem.toJson()).toList();
    }
    data['miner'] = this.miner;
    data['dist'] = this.dist;
    data['hash'] = this.hash;
    data['signature'] = this.signature;
    return data;
  }
}

class Txs {
  late int type;
  late Data data;
  late String sender;
  late int ts;
  late String hash;
  late String signature;

  Txs({
    required this.type,
    required this.data,
    required this.sender,
    required this.ts,
    required this.hash,
    required this.signature,
  });

  Txs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = Data.fromJson(json['data']);
    sender = json['sender'] != null ? json['sender'] : "";
    ts = json['ts'];
    hash = json['hash'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data.toJson();

    data['sender'] = this.sender;
    data['ts'] = this.ts;
    data['hash'] = this.hash;
    data['signature'] = this.signature;
    return data;
  }
}

class Data {
  String? pub;
  String? author;
  String? link;
  int? vt;
  String? tag;
  int? tip;
  JsonData? jsonString;

  Data(
      {this.pub,
      this.author,
      this.link,
      this.vt,
      this.tag,
      this.tip,
      this.jsonString});

  Data.fromJson(Map<String, dynamic> json) {
    pub = json['pub'] != null ? json['pub'] : null;
    author = json['author'] != null ? json['author'] : null;
    link = json['link'] != null ? json['link'] : null;
    vt = json['vt'] != null ? json['vt'] : null;
    tag = json['tag'] != null ? json['tag'] : null;
    tip = json['tip'] != null ? json['tip'] : null;
    if (json['json'] != null) {
      jsonString = JsonData.fromJson(json['json']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pub'] = this.pub;
    data['author'] = this.author;
    data['link'] = this.link;
    data['vt'] = this.vt;
    data['tag'] = this.tag;
    data['tip'] = this.tip;

    if (jsonString != null) {
      data['json'] = jsonString!.toJson();
    }
    return data;
  }
}

class JsonData {
  String? description;
  String? title;

  JsonData({this.description, this.title});

  JsonData.fromJson(Map<String, dynamic> jsonString) {
    description = jsonString['description'];
    title = jsonString['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['title'] = this.title;
    return data;
  }
}
