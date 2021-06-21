import 'package:dtube_togo/bloc/feed/feed_response_model.dart';
import 'package:dtube_togo/res/strings/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class FeedRepository {
  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser);
  Future<List<FeedItem>> getHotFeed(String apiNode);
  Future<List<FeedItem>> getTrendingFeed(String apiNode);
  Future<List<FeedItem>> getNewFeed(String apiNode);
  Future<List<FeedItem>> getUserFeed(String apiNode, String username);
}

class FeedRepositoryImpl implements FeedRepository {
  @override
  Future<List<FeedItem>> getMyFeed(
      String apiNode, String applicationUser) async {
    var response = await http.get(Uri.parse(apiNode +
        AppStrings.myFeedUrl.replaceAll("##USERNAME", applicationUser)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getHotFeed(String apiNode) async {
    var response = await http.get(Uri.parse(apiNode + AppStrings.hotFeedUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getTrendingFeed(String apiNode) async {
    var response =
        await http.get(Uri.parse(apiNode + AppStrings.trendingFeedUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getNewFeed(String apiNode) async {
    var response = await http.get(Uri.parse(apiNode + AppStrings.newFeedUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data).feed;
      return feed;
    } else {
      throw Exception();
    }
  }

  Future<List<FeedItem>> getUserFeed(String apiNode, String username) async {
    var response = await http.get(Uri.parse(apiNode +
        AppStrings.accountFeedUrl.replaceAll("##USERNAME", username)));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      List<FeedItem> feed = ApiResultModel.fromJson(data).feed;
      return feed;
    } else {
      throw Exception();
    }
  }
}
