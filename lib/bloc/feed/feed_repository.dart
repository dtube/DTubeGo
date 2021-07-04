import 'package:dtube_togo/bloc/feed/feed_response_model.dart';
import 'package:dtube_togo/res/strings/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class FeedRepository {
  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink);
  Future<List<FeedItem>> getHotFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getTrendingFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getNewFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
  Future<List<FeedItem>> getUserFeed(
    String apiNode,
    String username,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  );
}

class FeedRepositoryImpl implements FeedRepository {
  @override
  Future<List<FeedItem>> getMyFeed(String apiNode, String applicationUser,
      String? fromAuthor, String? fromLink) async {
    String _url = apiNode +
        AppStrings.myFeedUrlFirst.replaceAll("##USERNAME", applicationUser);
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppStrings.myFeedUrlMore
              .replaceAll("##USERNAME", applicationUser)
              .replaceAll("##AUTHOR", fromAuthor)
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

  Future<List<FeedItem>> getHotFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  ) async {
    String _url = apiNode + AppStrings.hotFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppStrings.hotFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
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

  Future<List<FeedItem>> getTrendingFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  ) async {
    String _url = apiNode + AppStrings.trendingFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppStrings.trendingFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
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

  Future<List<FeedItem>> getNewFeed(
    String apiNode,
    String? fromAuthor,
    String? fromLink,
    String applicationUser,
  ) async {
    String _url = apiNode + AppStrings.newFeedUrlFirst;
    if (fromAuthor != null && fromLink != null) {
      _url = apiNode +
          AppStrings.newFeedUrlMore
              .replaceAll("##AUTHOR", fromAuthor)
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

  Future<List<FeedItem>> getUserFeed(String apiNode, String username,
      String? fromAuthor, String? fromLink, String applicationUser) async {
    String _url = apiNode +
        AppStrings.accountFeedUrlFirst.replaceAll("##USERNAME", username);
    if (fromLink != null) {
      _url = apiNode +
          AppStrings.accountFeedUrlMore
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
