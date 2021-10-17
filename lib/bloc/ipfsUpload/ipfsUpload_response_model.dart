class UploadStatusResponse {
  late bool finished;
  // Null debugInfo;
  late bool sourceStored;
  // Null sourceAudioCpuEncoding;
  // Null sourceVideoGpuEncoding;
  late IpfsAddSourceVideo ipfsAddSourceVideo;
  late Sprite sprite;
  late List<EncodedVideos> encodedVideos;

  UploadStatusResponse(
      {required this.finished,
      //this.debugInfo,
      required this.sourceStored,
      // this.sourceAudioCpuEncoding,
      // this.sourceVideoGpuEncoding,
      required this.ipfsAddSourceVideo,
      required this.sprite,
      required this.encodedVideos});

  UploadStatusResponse.fromJson(Map<String, dynamic> json) {
    finished = json['finished'];
    // debugInfo = json['debugInfo'];
    sourceStored = json['sourceStored'];
    // sourceAudioCpuEncoding = json['sourceAudioCpuEncoding'];
    // sourceVideoGpuEncoding = json['sourceVideoGpuEncoding'];
    ipfsAddSourceVideo =
        IpfsAddSourceVideo.fromJson(json['ipfsAddSourceVideo']);
    sprite = Sprite.fromJson(json['sprite']);
    encodedVideos = [];
    json['encodedVideos'].forEach((v) {
      encodedVideos.add(new EncodedVideos.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['finished'] = this.finished;
    //data['debugInfo'] = this.debugInfo;
    data['sourceStored'] = this.sourceStored;
    // data['sourceAudioCpuEncoding'] = this.sourceAudioCpuEncoding;
    // data['sourceVideoGpuEncoding'] = this.sourceVideoGpuEncoding;
    data['ipfsAddSourceVideo'] = this.ipfsAddSourceVideo.toJson();
    data['sprite'] = this.sprite.toJson();
    data['encodedVideos'] = this.encodedVideos.map((v) => v.toJson()).toList();

    return data;
  }
}

class IpfsAddSourceVideo {
  late double progress;
  late String encodeSize;
  String? lastTimeProgress;
  // Null? errorMessage;
  late String step;
  // Null positionInQueue;
  String? hash;
  int? fileSize;

  IpfsAddSourceVideo(
      {required this.progress,
      required this.encodeSize,
      this.lastTimeProgress,
      //this.errorMessage,
      required this.step,
      // this.positionInQueue,
      this.hash,
      this.fileSize});

  IpfsAddSourceVideo.fromJson(Map<String, dynamic> json) {
    progress =
        json['progress'] != null && json['progress'] != "Waiting in queue..."
            ? double.parse(json['progress'].replaceAll('%', ''))
            : 0.0;
    encodeSize = json['encodeSize'];
    lastTimeProgress = json['lastTimeProgress'];
    //errorMessage = json['errorMessage'];
    step = json['step'];
    // positionInQueue = json['positionInQueue'];
    hash = json['hash'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['progress'] = this.progress;
    data['encodeSize'] = this.encodeSize;
    data['lastTimeProgress'] = this.lastTimeProgress;
    // data['errorMessage'] = this.errorMessage;
    data['step'] = this.step;
    // data['positionInQueue'] = this.positionInQueue;
    data['hash'] = this.hash;
    data['fileSize'] = this.fileSize;
    return data;
  }
}

class Sprite {
  late SpriteCreation spriteCreation;
  late IpfsAddSourceVideo ipfsAddSprite;

  Sprite({required this.spriteCreation, required this.ipfsAddSprite});

  Sprite.fromJson(Map<String, dynamic> json) {
    spriteCreation = SpriteCreation.fromJson(json['spriteCreation']);
    ipfsAddSprite = IpfsAddSourceVideo.fromJson(json['ipfsAddSprite']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spriteCreation'] = this.spriteCreation.toJson();
    data['ipfsAddSprite'] = this.ipfsAddSprite.toJson();

    return data;
  }
}

class SpriteCreation {
  late double progress;
  late String encodeSize;
  String? lastTimeProgress;
  // Null errorMessage;
  String? step;
  // Null positionInQueue;

  SpriteCreation({
    required this.progress,
    required this.encodeSize,
    this.lastTimeProgress,
    // this.errorMessage,
    this.step,
    // this.positionInQueue
  });

  SpriteCreation.fromJson(Map<String, dynamic> json) {
    progress =
        json['progress'] != null && json['progress'] != "Waiting in queue..."
            ? double.parse(json['progress'].replaceAll('%', ''))
            : 0.0;
    encodeSize = json['encodeSize'];
    lastTimeProgress = json['lastTimeProgress'];
    // errorMessage = json['errorMessage'];
    step = json['step'];
    // positionInQueue = json['positionInQueue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['progress'] = this.progress;
    data['encodeSize'] = this.encodeSize;
    data['lastTimeProgress'] = this.lastTimeProgress;
    // data['errorMessage'] = this.errorMessage;
    data['step'] = this.step;
    // data['positionInQueue'] = this.positionInQueue;
    return data;
  }
}

class EncodedVideos {
  late SpriteCreation encode;
  late IpfsAddSourceVideo ipfsAddEncodeVideo;

  EncodedVideos({required this.encode, required this.ipfsAddEncodeVideo});

  EncodedVideos.fromJson(Map<String, dynamic> json) {
    encode = SpriteCreation.fromJson(json['encode']);
    ipfsAddEncodeVideo =
        IpfsAddSourceVideo.fromJson(json['ipfsAddEncodeVideo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['encode'] = this.encode.toJson();
    data['ipfsAddEncodeVideo'] = this.ipfsAddEncodeVideo.toJson();

    return data;
  }
}
