class Transaction {
  String? sender;
  int? ts;
  String? signature;
  String? hash;
  int type;
  TxData data;

  Transaction({required this.type, required this.data});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> txdata = new Map<String, dynamic>();
    txdata['type'] = this.type;
    txdata['data'] = this.data.toJson();

    if (this.sender != null) {
      txdata['sender'] = this.sender;
    }

    if (this.ts != null) {
      txdata['ts'] = this.ts;
    }

    if (this.signature != null) {
      txdata['signature'] = this.signature;
    }

    if (this.hash != null) {
      txdata['hash'] = this.hash;
    }

    return txdata;
  }
}

class TxData {
  String? author;
  String? link;
  int? vt;
  int? burn;
  int? tip;
  String? tag;
  String? receiver;
  String? target;
  int? amount;
  String? memo;
  Map<String, dynamic>? jsonmetadata;
  String? pa;
  String? pp;
  String? id;
  String? pub;
  List<int>? types;
  String? name;

  TxData(
      {this.author,
      this.link,
      this.vt,
      this.tip,
      this.tag,
      this.receiver,
      this.target,
      this.amount,
      this.memo,
      this.jsonmetadata,
      this.pp,
      this.pa,
      this.burn,
      this.id,
      this.pub,
      this.types,
      this.name});

  TxData.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    link = json['link'];
    vt = int.parse(json['vt']);
    tip = json['tip'];
    tag = json['tag'];
    receiver = json['receiver'];
    target = json['target'];
    amount = json['amount'];
    memo = json['memo'];
    jsonmetadata = json['json'];
    pa = json['pa'];
    pp = json['pp'];
    burn = int.parse(json['burn']);
    id = json['id'];
    pub = json['pub'];
    types = json['types'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.author != null) {
      data['author'] = this.author;
    }
    if (this.link != null) {
      data['link'] = this.link;
    }
    if (this.tip != null) {
      data['tip'] = this.tip;
    }
    if (this.jsonmetadata != null) {
      data['json'] = this.jsonmetadata;
    }
    if (this.vt != null) {
      data['vt'] = this.vt;
    }

    if (this.tag != null) {
      data['tag'] = this.tag;
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver;
    }
    if (this.target != null) {
      data['target'] = this.target;
    }
    if (this.amount != null) {
      data['amount'] = this.amount;
    }
    if (this.memo != null) {
      data['memo'] = this.memo;
    }

    if (this.pa != null) {
      data['pa'] = this.pa;
    }
    if (this.pp != null) {
      data['pp'] = this.pp;
    }
    if (this.burn != null) {
      data['burn'] = this.burn;
    }

    if (this.id != null) {
      data['id'] = this.id;
    }

    if (this.pub != null) {
      data['pub'] = this.pub;
    }

    if (this.types != null) {
      data['types'] = this.types;
    }
    if (this.name != null) {
      data['name'] = this.name;
    }

    return data;
  }
}

class UploadData {
  String link;
  String title;
  String parentAuthor;
  String parentPermlink;
  String description;
  String tag;
  double vpPercent;
  int vpBalance;
  double burnDtc;
  int dtcBalance;
  String duration;
  String thumbnailLocation;
  bool localThumbnail;
  String videoLocation;
  bool localVideoFile;
  bool originalContent;
  bool nSFWContent;
  bool unlistVideo;
  bool isEditing;
  bool isPromoted;

  String videoSourceHash;
  String video240pHash;
  String video480pHash;
  String videoSpriteHash;
  String thumbnail640Hash;
  String thumbnail210Hash;
  bool uploaded;
  bool crossPostToHive;

  UploadData(
      {required this.link,
      required this.parentAuthor,
      required this.parentPermlink,
      required this.title,
      required this.description,
      required this.tag,
      required this.vpPercent,
      required this.vpBalance,
      required this.burnDtc,
      required this.dtcBalance,
      required this.duration,
      required this.thumbnailLocation,
      required this.localThumbnail,
      required this.videoLocation,
      required this.localVideoFile,
      required this.originalContent,
      required this.nSFWContent,
      required this.unlistVideo,
      required this.isEditing,
      required this.isPromoted,
      required this.videoSourceHash,
      required this.video240pHash,
      required this.video480pHash,
      required this.videoSpriteHash,
      required this.thumbnail640Hash,
      required this.thumbnail210Hash,
      required this.uploaded,
      required this.crossPostToHive});
}

class DAOTransaction {
  String? sender;
  int? ts;
  String? signature;
  String? hash;
  int type;
  DAOTxData data;

  DAOTransaction({required this.type, required this.data});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> txdata = new Map<String, dynamic>();
    txdata['type'] = this.type;
    txdata['data'] = this.data.toJson();

    if (this.sender != null) {
      txdata['sender'] = this.sender;
    }

    if (this.ts != null) {
      txdata['ts'] = this.ts;
    }

    if (this.signature != null) {
      txdata['signature'] = this.signature;
    }

    if (this.hash != null) {
      txdata['hash'] = this.hash;
    }

    return txdata;
  }
}

class DAOTxData {
  int? id;
  int? amount;

  DAOTxData({this.id, this.amount});

  DAOTxData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['amount'] = this.amount;

    return data;
  }
}
