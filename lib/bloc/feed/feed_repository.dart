import 'package:dtube_go/res/Config/APIUrlSchema.dart';
import 'package:dtube_go/utils/GlobalStorage/globalVariables.dart' as globals;
import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

abstract class FeedRepository {
  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink, String blockedUsers);
  Future<List<FeedItem>> getODFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers);
  Future<List<FeedItem>> getHotFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers);
  Future<List<FeedItem>> getTrendingFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers);
  Future<List<FeedItem>> getNewFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers);
  Future<List<FeedItem>> getUserFeed(
    String apiNode,
    String username,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getNewsFeed(String apiNode, String applicationUser);
  Future<List<FeedItem>> getNewFeedFiltered(String apiNode, String filterString,
      String tsRangeFilter, String applicationUsers);
  Future<List<FeedItem>> getMyFeedFiltered(String apiNode, String filterString,
      String tsRangeFilter, String applicationUser);
}

class FeedRepositoryImpl implements FeedRepository {
  @override

//moments feeds

  Future<List<FeedItem>> getNewFeedFiltered(String apiNode, String filterString,
      String tsRangeFilter, String applicationUser) async {
    String _url = apiNode +
        APIUrlSchema.newFeedUrlFiltered.replaceAll(
            "##FILTERSTRING",
            filterString.replaceAll(
                    '#', '') // somehow "#" in the taglist breaks the api
                +
                tsRangeFilter);

    var response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;

      List<FeedItem> feed = [];

      for (var f in _preFilterFeed) {
        // go through downvotes and check if one is from the applicationuser
        if (f.downvotes != null && f.downvotes!.length > 0) {
          bool downvotedByAppUser = false;

          for (var v in f.downvotes!) {
            if (v.u == applicationUser) {
              downvotedByAppUser = true;
              break;
            }
          }
          if (!downvotedByAppUser) {
            feed.add(f);
          }
        } else {
          feed.add(f);
        }
      }

      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getMyFeedFiltered(String apiNode, String filterString,
      String tsRangeFilter, String applicationUser) async {
    String _url = apiNode +
        APIUrlSchema.myFeedUrlFiltered
            .replaceAll("##USERNAME", applicationUser)
            .replaceAll("##FILTERSTRING", filterString + tsRangeFilter);

    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;

      List<FeedItem> feed = [];

      for (var f in _preFilterFeed) {
        // go through downvotes and check if one is from the applicationuser
        if (f.downvotes != null && f.downvotes!.length > 0) {
          bool downvotedByAppUser = false;

          for (var v in f.downvotes!) {
            if (v.u == applicationUser) {
              downvotedByAppUser = true;
              break;
            }
          }
          if (!downvotedByAppUser) {
            feed.add(f);
          }
        } else {
          feed.add(f);
        }
      }
      return feed;
    } else {
      throw Exception();
    }
  }

  // common feeds

  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink, String blockedUsers) async {
    String _url = apiNode +
        APIUrlSchema.myFeedUrlFirst.replaceAll("##USERNAME", applicationUser);
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          APIUrlSchema.myFeedUrlMore
              .replaceAll("##USERNAME", applicationUser)
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }

    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<String> _blockedUsers = blockedUsers.split(",");
      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;
      List<FeedItem> feed = [];
      for (var f in _preFilterFeed) {
        // check if creator is blocked from applicationUser
        if (!_blockedUsers.contains(f.author)) {
          // go through downvotes and check if one is from the applicationuser
          if (f.downvotes != null && f.downvotes!.length > 0) {
            bool downvotedByAppUser = false;

            for (var v in f.downvotes!) {
              if (v.u == applicationUser) {
                downvotedByAppUser = true;
                break;
              }
            }
            if (!downvotedByAppUser) {
              feed.add(f);
            }
          } else {
            feed.add(f);
          }
        }
      }
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getHotFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers) async {
    String _url = apiNode + APIUrlSchema.hotFeedUrlFirst;

    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          APIUrlSchema.hotFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<String> _blockedUsers = blockedUsers.split(",");
      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;
      List<FeedItem> feed = [];
      for (var f in _preFilterFeed) {
        // check if creator is blocked from applicationUser
        if (!_blockedUsers.contains(f.author)) {
          // go through downvotes and check if one is from the applicationuser
          if (f.downvotes != null && f.downvotes!.length > 0) {
            bool downvotedByAppUser = false;

            for (var v in f.downvotes!) {
              if (v.u == applicationUser) {
                downvotedByAppUser = true;
                break;
              }
            }
            if (!downvotedByAppUser) {
              feed.add(f);
            }
          } else {
            feed.add(f);
          }
        }
      }
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getTrendingFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers) async {
    String _url = apiNode + APIUrlSchema.trendingFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          APIUrlSchema.trendingFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<String> _blockedUsers = blockedUsers.split(",");
      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;
      List<FeedItem> feed = [];
      for (var f in _preFilterFeed) {
        // check if creator is blocked from applicationUser
        if (!_blockedUsers.contains(f.author)) {
          // go through downvotes and check if one is from the applicationuser
          if (f.downvotes != null && f.downvotes!.length > 0) {
            bool downvotedByAppUser = false;

            for (var v in f.downvotes!) {
              if (v.u == applicationUser) {
                downvotedByAppUser = true;
                break;
              }
            }
            if (!downvotedByAppUser) {
              feed.add(f);
            }
          } else {
            feed.add(f);
          }
        }
      }
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getODFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers) async {
    String _url = apiNode + APIUrlSchema.newFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          APIUrlSchema.newFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<String> _blockedUsers = blockedUsers.split(",");
      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;
      List<FeedItem> feed = [];

      for (var f in _preFilterFeed) {
        // check if creator is blocked from applicationUser
        if (!_blockedUsers.contains(f.author) &&
            globals.verifiedUsers.contains(f.author)) {
          // go through downvotes and check if one is from the applicationuser
          if (f.downvotes != null && f.downvotes!.length > 0) {
            bool downvotedByAppUser = false;

            for (var v in f.downvotes!) {
              if (v.u == applicationUser) {
                downvotedByAppUser = true;
                break;
              }
            }
            if (!downvotedByAppUser) {
              feed.add(f);
            }
          } else {
            feed.add(f);
          }
        }
      }

      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getNewFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers) async {
    String _url = apiNode + APIUrlSchema.newFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          APIUrlSchema.newFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<String> _blockedUsers = blockedUsers.split(",");
      List<FeedItem> _preFilterFeed =
          ApiResultModel.fromJson(data, applicationUser).feed;
      List<FeedItem> feed = [];

      for (var f in _preFilterFeed) {
        // check if creator is blocked from applicationUser
        if (!_blockedUsers.contains(f.author)) {
          // go through downvotes and check if one is from the applicationuser
          if (f.downvotes != null && f.downvotes!.length > 0) {
            bool downvotedByAppUser = false;

            for (var v in f.downvotes!) {
              if (v.u == applicationUser) {
                downvotedByAppUser = true;
                break;
              }
            }
            if (!downvotedByAppUser) {
              feed.add(f);
            }
          } else {
            feed.add(f);
          }
        }
      }

      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getUserFeed(String apiNode, String username,
      String? fromAuthor, String? fromLink, String applicationUser) async {
    String _url = apiNode +
        APIUrlSchema.accountFeedUrlFirst.replaceAll("##USERNAME", username);
    if (fromLink != null) {
      _url = apiNode +
          APIUrlSchema.accountFeedUrlMore
              .replaceAll("##USERNAME", username)
              .replaceAll("##AUTHORNAME", username)
              .replaceAll("##LINK", fromLink);
    }
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getNewsFeed(
    String apiNode,
    String applicationUser,
  ) async {
    String tsFrom = await sec.getNewsTS();
    String tsTo = (DateTime.now().millisecondsSinceEpoch).toString();

    String _url = apiNode +
        APIUrlSchema.newFeedUrlFiltered.replaceAll("##FILTERSTRING",
            "&authors=dtube,dtube-onboarding&tsrange=" + tsFrom + "," + tsTo);

    var responseDTube = await http.get(Uri.parse(_url));
    if (responseDTube.statusCode == 200) {
      var data = json.decode(responseDTube.body);
      List<FeedItem> feed = ApiResultModel.fromJson(data, applicationUser).feed;
      //await sec.persistCurrenNewsTS(int.tryParse(tsTo)!);
      return feed;
    } else {
      throw Exception();
    }
  }
}
