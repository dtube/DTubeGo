import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class ApiResultModel {
  late String status;

  late ThirdPartyMetadata metadata;

  ApiResultModel({required this.status, required this.metadata});

  ApiResultModel.fromJson(Map<String, dynamic> json, String currentUser) {
//    status = json['status'];

    metadata = new ThirdPartyMetadata.fromJson(json, currentUser);
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    String? _username = await sec.getUsername();
    data = this.metadata.toJson(_username);

    return data;
  }
}

class ThirdPartyMetadata {
  late String sId;
  late String title;
  late String description;
  late String thumbUrl;
  // Tags? tags;
  late Duration duration;
  late String videoUrl;
  late double votingWeight; // TODO: load votingweight here?
  late bool oc;
  late bool nsfw;
  late bool unlist;
  late double burnDTC;
  late String channelId;

  ThirdPartyMetadata({
    required this.sId,
    required this.title,
    required this.description,
    required this.thumbUrl,
    required this.duration,
    required this.videoUrl,
    required this.votingWeight,
    required this.oc,
    required this.nsfw,
    required this.unlist,
    required this.burnDTC,
    required this.channelId,
  });

  ThirdPartyMetadata.fromJson(Map<String, dynamic> json, String currentUser) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    thumbUrl = json['thumburl'];
    duration = json['duration'];
    videoUrl = json['videoUrl'];
    votingWeight = json['votingWeight'];
    oc = json['oc'];
    nsfw = json['nsfw'];
    unlist = json['unlist'];
    burnDTC = json['burnDTC'];
    channelId = json['channelId'];
  }

  Map<String, dynamic> toJson(String username) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // List<Votes> allVotes = [];
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumbUrl'] = this.thumbUrl;
    data['duration'] = this.duration;
    data['videoUrl'] = this.videoUrl;
    data['votingWeight'] = this.votingWeight;
    data['oc'] = this.oc;
    data['nsfw'] = this.nsfw;
    data['unlist'] = this.unlist;
    data['burnDTC'] = this.burnDTC;
    data['channelId'] = this.channelId;
    return data;
  }
}
