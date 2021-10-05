class ApiResultModel {
  late String status;
  late int totalResults;
  late List<AvalonNotification> notifications;

  ApiResultModel(
      {required this.status,
      required this.totalResults,
      required this.notifications});

  ApiResultModel.fromJson(List<dynamic> json) {
//    status = json['status'];

    totalResults = json.length;
    notifications = [];
    json.forEach((v) {
      notifications.add(new AvalonNotification.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    data['posts'] = this.notifications.map((v) => v.toJson()).toList();

    return data;
  }
}

class AvalonNotification {
  late String sId;
  late String u;
  late Tx tx;
  late int ts;

  AvalonNotification(
      {required this.sId, required this.u, required this.tx, required this.ts});

  AvalonNotification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    u = json['u'];
    tx = new Tx.fromJson(json['tx']);
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['u'] = this.u;
    data['tx'] = this.tx.toJson();

    data['ts'] = this.ts;
    return data;
  }
}

class Tx {
  late int type;
  late Data data;
  late String sender;
  late int ts;
  late String hash;
  late String signature;

  Tx(
      {required this.type,
      required this.data,
      required this.sender,
      required this.ts,
      required this.hash,
      required this.signature});

  Tx.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = new Data.fromJson(json['data']);
    sender = json['sender'];
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
  String? link;
  int? vt;
  String? tag;
  int? tip;
  String? receiver;
  double? amount;
  String? memo;
  String? author;

  Data(
      {this.link,
      this.vt,
      this.tag,
      this.tip,
      this.receiver,
      this.amount,
      this.memo,
      this.author});

  Data.fromJson(Map<String, dynamic> json) {
    link = json['pp'] != null
        ? json['pp']
        : json['link'] != null
            ? json['link']
            : '';
    author = json['pa'] != null
        ? json['pa']
        : json['author'] != null
            ? json['author']
            : '';

    vt = json['vt'] != null ? json['vt'] : 0;

    tag = json['tag'] != null ? json['tag'] : '';
    tip = json['tip'] != null ? json['tip'] : 0;
    receiver = json['receiver'] != null ? json['receiver'] : '';
    amount = json['amount'] != null ? json['amount'] * 1.0 : 0.0;
    memo = json['memo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['author'] = this.author;
    data['vt'] = this.vt;
    data['tag'] = this.tag;
    data['tip'] = this.tip;
    data['receiver'] = this.receiver;
    data['amount'] = this.amount;
    data['memo'] = this.memo;
    return data;
  }
}
