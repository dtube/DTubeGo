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
  int? tip;
  String? tag;
  String? receiver;
  String? target;
  int? amount;
  String? memo;
  Map<String, dynamic>? jsonmetadata;
  String? pa;
  String? pp;

  TxData({
    this.author,
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
  });

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

    return data;
  }
}
