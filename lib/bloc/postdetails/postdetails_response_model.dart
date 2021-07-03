import 'package:dtube_togo/res/strings/strings.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class ApiResultModel {
  late String status;

  late Post post;

  ApiResultModel({required this.status, required this.post});

  ApiResultModel.fromJson(Map<String, dynamic> json, String currentUser) {
//    status = json['status'];

    post = new Post.fromJson(json, currentUser);
  }

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    String? _username = await sec.getUsername();
    data = this.post.toJson(_username!);

    return data;
  }
}

class Post {
  late String sId;
  late String author;
  late String link;
  // Null? pa;
  // Null? pp;
  PostJsonString? jsonString;
  // List<Null> child;
  //List<Votes>? votes;
  List<Votes>? upvotes;
  List<Votes>? downvotes;
  late int ts;
  // Tags? tags;
  late double dist;

  String? thumbUrl;
  String? videoUrl;
  bool? alreadyVoted = false;
  bool? alreadyVotedDirection = false; // false = downvote | true = upvote
  List<Comment>? comments;
  List<String> tags = [];

  Post(
      {required this.sId,
      required this.author,
      required this.link,
      // this.pa,
      // this.pp,
      this.jsonString,
      // this.child,
      //this.votes,
      this.upvotes,
      this.downvotes,
      required this.ts,
      //required this.tags,
      required this.dist,
      this.comments,
      required this.tags});

  Post.fromJson(Map<String, dynamic> json, String currentUser) {
    sId = json['_id'];
    author = json['author'];
    link = json['link'];

    jsonString =
        json['json'] != null ? new PostJsonString.fromJson(json['json']) : null;

    if (json['comments'] != null) {
      comments = [];

      json['comments'].forEach((key, value) {
        Comment _c = new Comment.fromJson(value, currentUser);
        comments!.add(_c);
      });

      comments?.forEach((c) {
        if (c.pa != "" && c.pp != link) {
          Comment? parent = comments?.firstWhere((parentComment) =>
              parentComment.author == c.pa && parentComment.link == c.pp);
          if (parent != null) {
            int indexOfParent = comments!.indexOf(parent);
            List<Comment> _childComments = [];
            if (parent.childComments != null) {
              _childComments = comments![indexOfParent].childComments!;
            }
            _childComments.add(c);
            comments![indexOfParent].childComments = _childComments;
          }
        }
      });
      List<Comment> copyOfComments = [...comments!];

      copyOfComments.forEach((c) {
        if (c.pa != "" && c.pp != link) {
          int indexOfChild = comments!.indexOf(c);
          comments!.removeAt(indexOfChild);
          print("test");
        }
      });
    }
    tags = [];
    tags.add(jsonString!.tag!.toLowerCase());
    if (json['votes'] != null) {
      upvotes = [];
      downvotes = [];
      json['votes'].forEach((v) {
        Votes _v = new Votes.fromJson(v);
        if (_v.vt > 0.0) {
          upvotes!.add(_v);
        } else {
          downvotes!.add(_v);
        }
        if (_v.tag != null &&
            _v.tag != "" &&
            !tags.contains(_v.tag!.toLowerCase())) {
          tags.add(_v.tag!.toLowerCase());
        }
      });
    }

    if (json['votes'] != null) {
      upvotes = [];
      downvotes = [];
      json['votes'].forEach((v) {
        Votes _v = new Votes.fromJson(v);
        if (_v.vt > 0.0) {
          upvotes!.add(_v);
          if (_v.u == currentUser) {
            alreadyVoted = true;
            alreadyVotedDirection = true;
          }
        } else {
          if (_v.u == currentUser) {
            alreadyVoted = true;
            alreadyVotedDirection = false;
          }
          downvotes!.add(_v);
        }
      });
    }
    if (jsonString?.files?.youtube != null) {
      videoUrl = jsonString?.files?.youtube;
    } else if (jsonString?.files?.ipfs != null) {
      String _gateway = AppStrings.ipfsVideoUrl;
      if (jsonString?.files?.ipfs!.gw != null) {
        _gateway = jsonString!.files!.ipfs!.gw! + '/ipfs/';
      }
      if (jsonString?.files?.ipfs?.vid?.s480 != null) {
        videoUrl = _gateway + jsonString!.files!.ipfs!.vid!.s480!;
      } else if (jsonString?.files?.ipfs?.vid?.s240 != null) {
        videoUrl = _gateway + jsonString!.files!.ipfs!.vid!.s240!;
      } else {
        videoUrl = _gateway + jsonString!.files!.ipfs!.vid!.src!;
      }
    }

    if (jsonString?.files?.youtube != null) {
      thumbUrl = "https://img.youtube.com/vi/" +
          jsonString!.files!.youtube! +
          "/mqdefault.jpg";
    } else {
      String _gateway = AppStrings.ipfsVideoUrl;
      if (jsonString?.files?.ipfs!.gw != null) {
        _gateway = jsonString!.files!.ipfs!.gw! + '/ipfs/';
      }

      if (jsonString?.files?.ipfs?.img?.s360 != null) {
        thumbUrl = _gateway + jsonString!.files!.ipfs!.img!.s360!;
      } else {
        thumbUrl = _gateway + jsonString!.files!.ipfs!.img!.s118!;
      }
    }

    ts = json['ts'];
    // tags = json['tags'] != null ? new Tags.fromJson(json['tags']) : null;
    dist = double.parse(json['dist'].toString());
  }

  Map<String, dynamic> toJson(String username) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<Votes> allVotes = [];
    data['_id'] = this.sId;
    data['author'] = this.author;
    data['link'] = this.link;
    // data['pa'] = this.pa;
    // data['pp'] = this.pp;
    if (this.jsonString != null) {
      data['json'] = this.jsonString?.toJson();
    }
    // if (this.child != null) {
    //   data['child'] = this.child.map((v) => v.toJson()).toList();
    // }

    if (this.upvotes != null || this.downvotes != null) {
      allVotes = this.upvotes! + this.downvotes!;
      data['votes'] = allVotes.map((v) => v.toJson()).toList();
    }
    data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    data['alreadyVoted'] = alreadyVoted;
    data['ts'] = this.ts;
    // if (this.tags != null) {
    //   data['tags'] = this.tags?.toJson();
    // }
    data['dist'] = this.dist;
    data['videoUrl'] = this.videoUrl;
    data['thumbUrl'] = this.thumbUrl;
    data['tags'] = this.tags;
    return data;
  }
}

class PostJsonString {
  Files? files;
  String? dur;
  late String title;
  String? desc;
  String? tag;
  late int hide;
  late int nsfw;
  late int oc;
  List<String>? refs;

  PostJsonString(
      {this.files,
      this.dur,
      required this.title,
      this.desc,
      this.tag,
      required this.hide,
      required this.nsfw,
      required this.oc,
      required this.refs});

  PostJsonString.fromJson(Map<String, dynamic> json) {
    files = json['files'] != null ? new Files.fromJson(json['files']) : null;
    dur = json['dur'].toString();
    title = json['title'];
    desc = json['description'] == null ? json['desc'] : json['description'];
    tag = json['tag'];
    hide = json['hide'];
    nsfw = json['nsfw'];
    oc = json['oc'];
    if (json['refs'] != null) {
      refs = [];
      json['refs'].forEach((v) {
        refs?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.files != null) {
      data['files'] = this.files?.toJson();
    }
    data['dur'] = this.dur;
    data['title'] = this.title;
    data['description'] = this.desc;
    data['tag'] = this.tag;
    data['hide'] = this.hide;
    data['nsfw'] = this.nsfw;
    data['oc'] = this.oc;
    data['refs'] = this.refs;
    return data;
  }
}

class Files {
  Ipfs? ipfs;
  String? youtube;

  Files({this.youtube, this.ipfs});

  Files.fromJson(Map<String, dynamic> json) {
    youtube = json['youtube'];
    ipfs = json['ipfs'] != null ? new Ipfs.fromJson(json['ipfs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['youtube'] = this.youtube;
    if (this.ipfs != null) {
      data['ipfs'] = this.ipfs?.toJson();
    }
    return data;
  }
}

class Ipfs {
  Vid? vid;
  Img? img;
  String? gw;

  Ipfs({this.vid, this.img, this.gw});

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
    gross =
        json['gross'] != null ? double.parse(json['gross'].toString()) : 0.0;
    claimable = json['claimable'] != null
        ? double.parse(json['claimable'].toString())
        : 0.0;
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

class CommentJsonString {
  // late String title; // comments never have a title?
  late String description;
  late String title;
  List<String>? refs;

  CommentJsonString(
      {
      //required this.title,
      required this.description,
      required this.title,
      this.refs});

  CommentJsonString.fromJson(Map<String, dynamic> json) {
    //title = json['title'];
    if (json['description'] != null) {
      description = json['description'];
    } else {
      description = "";
    }

    if (json['refs'] != null) {
      refs = [];
      json['refs'].forEach((v) {
        refs?.add(v);
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    //data['title'] = this.title;
    data['description'] = this.description;
    data['title'] = this.title;

    //data['refs'] = this.refs;
    return data;
  }
}

class Comment {
  late String id;
  late String author;
  late String link;
  late String pa;
  late String pp;
  late CommentJsonString commentjson;
  late List<Votes>? upvotes;
  late List<Votes>? downvotes;
  late bool alreadyVoted = false;
  late bool alreadyVotedDirection = false; // false = downvote | true = upvote
  List<Comment>? childComments;

  Comment(
      {required this.id,
      required this.author,
      required this.link,
      required this.pa,
      required this.pp,
      required this.commentjson,
      required this.upvotes,
      required this.downvotes,
      required this.alreadyVoted,
      required this.alreadyVotedDirection});

  Comment.fromJson(Map<String, dynamic> json, String currentUser) {
    id = json['id'];
    author = json['author'];
    link = json['link'];
    pa = json['pa'];
    pp = json['pp'];

    commentjson = CommentJsonString.fromJson(json['json']);
    if (json['votes'] != null) {
      upvotes = [];
      downvotes = [];
      json['votes'].forEach((v) {
        Votes _v = new Votes.fromJson(v);
        if (_v.vt > 0.0) {
          upvotes!.add(_v);
          if (_v.u == currentUser) {
            alreadyVoted = true;
            alreadyVotedDirection = true;
          }
        } else {
          if (_v.u == currentUser) {
            alreadyVoted = true;
            alreadyVotedDirection = false;
          }
          downvotes!.add(_v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    List<Votes> allVotes = [];
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['link'] = this.link;
    data['pa'] = this.pa;
    data['pp'] = this.pp;
    data['commentjson'] = commentjson.toJson();
    if (this.upvotes != null || this.downvotes != null) {
      allVotes = this.upvotes! + this.downvotes!;
      data['votes'] = allVotes.map((v) => v.toJson()).toList();
    }

    data['alreadyVoted'] = alreadyVoted;
    data['alreadyVotedDirection'] = alreadyVotedDirection;

    return data;
  }
}

// class Tags {
//   int meme;

//   Tags({this.meme});

//   Tags.fromJson(Map<String, dynamic> json) {
//     meme = json['meme'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['meme'] = this.meme;
//     return data;
//   }
// }
