class ApiResultModel {
  late String status;

  late Auth auth;

  ApiResultModel({required this.status, required this.auth});

  ApiResultModel.fromJson(Map<String, dynamic> json) {
//    status = json['status'];
    auth = Auth.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();

    data = this.auth.toJson();

    return data;
  }
}

class Auth {
  late String sId;
  late String name;
  late String pub;
  late List<Keys> keys;

  Auth(
      {required this.sId,
      required this.pub,
      required this.name,
      required this.keys});

  Auth.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    pub = json['pub'];

    if (json['keys'] != null) {
      keys = [];
      json['keys'].forEach((v) {
        keys.add(new Keys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['pub'] = this.pub;

    if (this.keys != null) {
      data['keys'] = this.keys.map((v) => v.toJson()).toList();
    }
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
