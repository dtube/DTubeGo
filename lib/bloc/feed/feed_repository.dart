import 'package:dtube_go/bloc/feed/feed_bloc_full.dart';
import 'package:dtube_go/res/appConfigValues.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class FeedRepository {
  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink, String blockedUsers);
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
        AppConfig.newFeedUrlFiltered.replaceAll(
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
        AppConfig.myFeedUrlFiltered
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
        AppConfig.myFeedUrlFirst.replaceAll("##USERNAME", applicationUser);
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.myFeedUrlMore
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
    String _url = apiNode + AppConfig.hotFeedUrlFirst;

    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.hotFeedUrlMore
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
    String _url = apiNode + AppConfig.trendingFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.trendingFeedUrlMore
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

  Future<List<FeedItem>> getNewFeed(String apiNode, String? fromAuthor,
      String? fromLink, String applicationUser, String blockedUsers) async {
    String _url = apiNode + AppConfig.newFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppConfig.newFeedUrlMore
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
        AppConfig.accountFeedUrlFirst.replaceAll("##USERNAME", username);
    if (fromLink != null) {
      _url = apiNode +
          AppConfig.accountFeedUrlMore
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
}
