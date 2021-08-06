import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class ApiResultModel {
  late User user;

  ApiResultModel({required this.user});

  ApiResultModel.fromJson(Map<String, dynamic> json, String currentUser) {
//    status = json['status'];

    user = new User.fromJson(json, currentUser);
  }

  Future<Map<String, dynamic>> toJson() async {
    String? _username = await sec.getUsername();
    Map<String, dynamic> data = new Map<String, dynamic>();

    data = this.user.toJson(_username);

    return data;
  }
}

class User {
  late String sId;
  late String name;
  late String pub;
  late int balance;
  Bw? bw;
  Bw? vt;
  Bw? pr;
  int? uv;
  List<String>? follows;
  List<String>? followers;
  late List<Keys> keys;
  JsonString? jsonString;
  List<String>? approves;
  int? nodeAppr;
  String? pubLeader;
  late bool alreadyFollowing;

  User(
      {required this.sId,
      required this.name,
      required this.pub,
      required this.balance,
      this.bw,
      this.vt,
      this.pr,
      this.uv,
      this.follows,
      this.followers,
      required this.keys,
      this.jsonString,
      this.approves,
      this.nodeAppr,
      this.pubLeader,
      required this.alreadyFollowing});

  User.fromJson(Map<String, dynamic> json, String currentUser) {
    sId = json['_id'];
    name = json['name'];
    pub = json['pub'];
    balance = json['balance'];
    bw = json['bw'] != null ? new Bw.fromJson(json['bw']) : null;
    vt = json['vt'] != null ? new Bw.fromJson(json['vt']) : null;
    pr = json['pr'] != null ? new Bw.fromJson(json['pr']) : null;
    uv = json['uv'];
    follows = json['follows'] != null ? json['follows'].cast<String>() : null;
    followers =
        json['followers'] != null ? json['followers'].cast<String>() : null;
    if (json['keys'] != null) {
      keys = [];
      json['keys'].forEach((v) {
        keys.add(new Keys.fromJson(v));
      });
    }
    jsonString =
        json['json'] != null ? new JsonString.fromJson(json['json']) : null;
    approves =
        json['approves'] != null ? json['approves'].cast<String>() : null;
    nodeAppr = json['node_appr'];
    pubLeader = json['pub_leader'];
    if (followers != null && followers!.contains(currentUser)) {
      alreadyFollowing = true;
    } else {
      alreadyFollowing = false;
    }
  }

  Map<String, dynamic> toJson(String currentUser) {
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
    data['follows'] = this.follows;
    data['followers'] = this.followers;
    data['keys'] = this.keys.map((v) => v.toJson()).toList();

    if (this.jsonString != null) {
      data['json'] = this.jsonString!.toJson();
    }
    data['approves'] = this.approves;
    data['node_appr'] = this.nodeAppr;
    data['pub_leader'] = this.pubLeader;
    if (followers != null && followers!.contains(currentUser)) {
      alreadyFollowing = true;
    } else {
      alreadyFollowing = false;
    }
    return data;
  }
}

class Bw {
  late int v;
  late int t;

  Bw({required this.v, required this.t});

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

class Keys {
  late String id;
  late String pub;
  late List<int> types;

  Keys({required this.id, required this.pub, required this.types});

  Keys.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pub = json['pub'];
    types = json['types'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pub'] = this.pub;
    data['types'] = this.types;
    return data;
  }
}

class JsonString {
  Node? node;
  Profile? profile;

  JsonString({this.node, this.profile});

  JsonString.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
    profile = new Profile.fromJson(json['profile']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Node {
  late String ws;

  Node({required this.ws});

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

  Profile(
      {this.avatar,
      this.coverImage,
      this.about,
      this.location,
      this.website,
      this.steem,
      this.hive});

  Profile.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] != null ? json['avatar'] : '';
    coverImage = json['cover_image'] != null ? json['cover_image'] : '';
    about = json['about'] != null ? json['about'] : '';
    location = json['location'] != null ? json['location'] : '';
    website = json['website'] != null ? json['website'] : '';
    steem = json['steem'] != null ? json['steem'] : '';
    hive = json['hive'] != null ? json['hive'] : '';
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
    return data;
  }
}
